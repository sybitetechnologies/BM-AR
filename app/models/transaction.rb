class Transaction < ApplicationRecord
  after_create :update_balance
  belongs_to :credited_user, :class_name => "User", foreign_key: :credited_user_id, optional: true
  belongs_to :debited_user, :class_name => "User", foreign_key: :debited_user_id, optional: true

  def update_balance
    credit_user = User.where(id: self.credited_user_id).try(:first)
    credit_user.update_attributes(balance: credit_user.balance + self.amount) unless credit_user.blank?
    debit_user = User.where(id: self.debited_user_id).try(:first)
    debit_user.update_attributes(balance: debit_user.balance - self.amount) unless debit_user.blank?
  end

  def list_attributes
    attribs = self.attributes.symbolize_keys.slice(:amount)
    attribs[:credited_user] = self.try(:credited_user).try(:list_attributes)
    attribs[:debited_user] = self.try(:debited_user).try(:list_attributes)
    attribs
  end
end
