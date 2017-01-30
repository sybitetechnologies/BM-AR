require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do

  before(:each) do
    @current_user = create(:user, balance: 100)
    @credited_user = create(:user, balance: 20)
    allow(controller).to receive(:current_user).and_return(@current_user)
  end

  it "get current user balance" do
    get :balance
    response_obj = JSON.parse(response.body)
    expect(response_obj["data"]).to eql({"balance" => 100.0, "user" => {"email"=> @current_user.email, "name"=> @current_user.name}})
    expect(response).to have_http_status(:ok)
  end

  describe "transfer from one account to another account" do
    context "Invalid transaction" do
      it "raise error if for invalid user" do
        post :transfer, params: {credited_user: "invalid", amount: 100}
        response_obj = JSON.parse(response.body)
        expect(response_obj["errors"]).to eql([I18n.t("user.credit_user_not_found")])
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "raise error if there are insufficient funds" do
        credited_user = create(:user)
        post :transfer, params: {credited_user: credited_user.email, amount: 500}
        response_obj = JSON.parse(response.body)
        expect(response_obj["errors"]).to eql([I18n.t("transaction.create.insufficiant_amount")])
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "raise error if there are insufficient funds" do
        credited_user = create(:user)
        post :transfer, params: {credited_user: credited_user.email, amount: -10}
        response_obj = JSON.parse(response.body)
        expect(response_obj["errors"]).to eql([I18n.t("transaction.create.invalid_amount")])
      end
    end

    context "valid transaction" do
      it "should be able to transfer" do
        post :transfer, params: {credited_user: @credited_user.email, amount: 50}
        response_obj = JSON.parse(response.body)
        expect(response_obj["data"]["amount"]).to eql(50.to_f)
        expect(@credited_user.reload.balance).to eql(70.to_f)
        expect(@current_user.reload.balance).to eql(50.to_f)
      end
    end
  end

  describe "deposit money in the account" do
    context "Invalid transaction" do
      it "raise error if for invalid user" do
        post :deposit, params: {credited_user: "invalid", amount: 100}
        response_obj = JSON.parse(response.body)
        expect(response_obj["errors"]).to eql([I18n.t("user.credit_user_not_found")])
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "raise error if there are insufficient funds" do
        credited_user = create(:user)
        post :deposit, params: {credited_user: credited_user.email, amount: -10}
        response_obj = JSON.parse(response.body)
        expect(response_obj["errors"]).to eql([I18n.t("transaction.create.invalid_amount")])
      end
    end

    context "valid transaction" do
      it "should be able to deposit" do
        post :deposit, params: {credited_user: @credited_user.email, amount: 50}
        response_obj = JSON.parse(response.body)
        expect(response_obj["data"]["amount"]).to eql(50.to_f)
        expect(@credited_user.reload.balance).to eql(70.to_f)
        expect(@current_user.reload.balance).to eql(100.to_f)

        post :deposit, params: {credited_user: @current_user.email, amount: 20}
        expect(@current_user.reload.balance).to eql(120.to_f)
      end
    end
  end

  describe "withdraw money from account" do
    context "Invalid transaction" do
      it "raise error if there are insufficient funds for withdraw" do
        credited_user = create(:user)
        post :withdraw, params: {amount: 500}
        response_obj = JSON.parse(response.body)
        expect(response_obj["errors"]).to eql([I18n.t("transaction.create.insufficiant_amount")])
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "Valid transaction" do
      it "should be able to withdraw amount" do
        post :withdraw, params: {amount: 50}
        response_obj = JSON.parse(response.body)
        expect(@current_user.reload.balance).to eql(50.to_f)
      end
    end
  end

  describe "get mini statement" do
    it "should list all the transactions" do
      create(:transaction, credited_user: @current_user)
      create(:transaction, debited_user: @current_user)
      create(:transaction, debited_user: @current_user)
      get :index
      response_obj = JSON.parse(response.body)
      expect(response_obj["data"]["transactions"].length).to eql(3)
    end
  end
end