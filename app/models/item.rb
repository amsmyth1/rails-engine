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
    where('lower(name) LIKE ?', "%#{query.downcase}%")
  end
end
