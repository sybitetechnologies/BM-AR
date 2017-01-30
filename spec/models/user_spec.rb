require 'rails_helper'

RSpec.describe User, type: :model do

	it { should have_many(:debit_transactions) }
	it { should have_many(:credit_transactions) }


	describe ".list_attributes" do
		it "should list details" do
			user = create(:user)
			expect(user.list_attributes).to eql({email: user.email, name: user.name})
		end
	end
	describe ".transactions_list" do
		it "list tranctions which are debit or credit both" do
			user = create(:user)
			trans1 = create(:transaction, credited_user: user)
			trans2 = create(:transaction, debited_user: user)
			expect(user.transactions_list).to match_array([trans1, trans2])
		end
	end

end