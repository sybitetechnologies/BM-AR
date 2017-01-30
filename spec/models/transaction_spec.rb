require 'rails_helper'

RSpec.describe Transaction, type: :model do

	it { should belong_to(:credited_user) }
	it { should belong_to(:debited_user) }


	describe "list_attributes" do
		it "should list details" do
			trans = create(:transaction)
			expect(trans.list_attributes).to eql({amount: 20.0, credited_user: trans.credited_user.list_attributes, debited_user: trans.debited_user.list_attributes})
		end
	end
end