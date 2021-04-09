class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  scope :paginate, -> (page:, per_page:) {
    page = (page || 1).to_i
    per_page = (per_page || 20).to_i
    limit(per_page).offset((page - 1) * per_page)
  }

  def self.search(query)
    result = where('lower(name) LIKE ?', "%#{query.downcase}%")
  end
  def self.search_one_by_name(query)
    result = where('lower(name) LIKE ?', "%#{query.downcase}%")
    .order(:name)
    .limit(1)[0]
  end

  def self.search_min_price(min_price)
    result = where('unit_price >= ?', min_price).order(:name)
  end
  def self.search_one_min_price(min_price)
    result = where('unit_price >= ?', min_price).order(:name).limit(1)[0]
  end

  def self.search_max_price(max_price)
    result = where('unit_price <= ?', max_price).order(:name)
  end

  def self.search_one_max_price(max_price)
    result = where('unit_price <= ?', max_price).order(:name).limit(1)[0]
  end

  def self.search_price_range(min_price, max_price)
    result = where('unit_price >= ?', min_price).where('unit_price <= ?', max_price).order(:name)
  end
  def self.search_one_price_range(min_price, max_price)
    result = where('unit_price >= ?', min_price).where('unit_price <= ?', max_price).order(:name).limit(1)
  end
end
