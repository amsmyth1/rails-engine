require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    it { should belong_to :merchant }
  end
  describe ".paginate" do
    it "takes arguments for page and per_page to display results" do
      answer = Item.paginate(page: 3, per_page: 2)

      item_1 = create(:item)
      item_2 = create(:item)
      item_3 = create(:item)
      item_4 = create(:item)
      item_5 = create(:item)
      item_6 = create(:item)

      expect(answer).to eq([item_5, item_6])
    end
  end

  describe ".search" do
    it "returns items that names match the search frament" do
      item_1 = create(:item, name: "the")
      item_2 = create(:item, name: "there")
      item_3 = create(:item, name: "either")
      item_4 = create(:item, name: "wtihe")
      item_5 = create(:item, name: "we")
      item_6 = create(:item, name: "athe")

      expect(Item.search("the")).to eq([item_1, item_2, item_3, item_6])
    end
  end
end
