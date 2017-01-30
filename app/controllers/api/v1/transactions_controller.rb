class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate_api_user!
  before_action :credit_user_exists?, only: [:transfer, :deposit]
  before_action :valid_amount?, only: [:transfer, :withdraw, :deposit]
  before_action :can_transfer?, only: [:transfer, :withdraw]

  def index
    transactions = current_user.transactions_list
    render json: {success: true, data: {transactions: transactions.map{|transaction| transaction.list_attributes}, balance: current_user.balance}}
  end

  def transfer
    credit = nil
    CreditTransaction.transaction do
      credit = CreditTransaction.create(credited_user: @credited_user, amount: params[:amount], debited_user: current_user)
    end
    render json: {success: true, data: {amount: credit.amount, credited_user: credit.credited_user.list_attributes, debited_user: credit.debited_user.list_attributes}}, status: :ok
  end

  def deposit
    credit = nil
    CreditTransaction.transaction do
      credit = CreditTransaction.create(credited_user: @credited_user, amount: params[:amount])
    end
    render json: {success: true, data: {amount: credit.amount, credited_user: credit.credited_user.list_attributes}}, status: :ok
  end

  def balance
    render json: {success: true, data: {balance: current_user.balance, user: current_user.list_attributes}}, status: :ok
  end

  def withdraw
    debit = nil
    DebitTransaction.transaction do
      debit = DebitTransaction.create(debited_user: current_user, amount: params[:amount])
    end
    render json: {success: true, data: {amount: debit.amount, debited_user: debit.debited_user.list_attributes}}, status: :ok
  end

  private

  def credit_user_exists?
    @credited_user = User.where(email: params[:credited_user]).try(:first)
    render json: {errors: [I18n.t("user.credit_user_not_found")]}, status: :unprocessable_entity and return if @credited_user.blank?
  end

  def valid_amount?
    params[:amount] = params[:amount].to_f
    render json: {errors: [I18n.t("transaction.create.invalid_amount")]}, status: :unprocessable_entity and return if params[:amount] <= 0
  end

  def can_transfer?
    render json: {errors: [I18n.t("transaction.create.insufficiant_amount")]}, status: :unprocessable_entity and return if current_user.balance < params[:amount]
  end
end