class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  def self.potential_revenue(limit)
    joins(:transactions)
    .joins(:invoice_items)
    .where('invoices.status = ?', 'packaged')
    .where('transactions.result = ?', 'success')
    .select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as rev')
    .group('invoices.id')
    .order('rev desc')
    .limit(limit)
  end
end
