require 'rails_helper'

RSpec.describe DateCheckable, type: :module do
  describe "::revenue_by_date_error?" do
    it "returns true if the parameters given in the url are faulty" do
      start_date = Date.new(2011, 12, 12)
      end_date = ""

      expect(DateCheckable.revenue_by_date_error?(start_date, end_date)).to eq(true)
      end_date = Date.new(2011, 12, 12)
      start_date = ""

      expect(DateCheckable.revenue_by_date_error?(start_date, end_date)).to eq(true)
      end_date = ""
      start_date = ""

      expect(DateCheckable.revenue_by_date_error?(start_date, end_date)).to eq(true)
      end_date = ""
      start_date = nil

      expect(DateCheckable.revenue_by_date_error?(start_date, end_date)).to eq(true)
      end_date = nil
      start_date = nil

      expect(DateCheckable.revenue_by_date_error?(start_date, end_date)).to eq(true)
      end_date = nil
      start_date = Date.new(2011, 12, 12)

      expect(DateCheckable.revenue_by_date_error?(start_date, end_date)).to eq(true)
    end
  end
  describe "::clean_date" do
    it "takes a string date seperated by hyphens and creates a date object" do

      expect(DateCheckable.clean_date("2012-12-12")).to eq(Date.new(2012, 12, 12))
    end
  end
end
