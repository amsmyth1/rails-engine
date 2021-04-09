class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  def self.potential_revenue
    joins(:transactions)
    .where('transactions.result = ?', 'success')
    .where('invoices.status = ?', 'packaged')
  end
end
