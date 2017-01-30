class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :debit_transactions, foreign_key: :debited_user_id
  has_many :credit_transactions, foreign_key: :credited_user_id

  def transactions_list
  	Transaction.where(credited_user_id: self.id).or(Transaction.where(debited_user_id: self.id)).order(created_at: :desc)
  end

  def list_attributes
  	self.attributes.symbolize_keys.slice(:email, :name)
  end
end
