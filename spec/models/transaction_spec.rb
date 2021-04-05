require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "validations" do
    it { should belong_to :invoice }
    it { should have_many(:invoice_items).through(:invoice) }
    it { should have_many(:items).through(:invoice) }
    it { should have_one(:customers).through(:invoice) }
  end
end
