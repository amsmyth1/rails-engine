class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions, :dependent => :delete_all
  has_many :invoice_items, :dependent => :delete_all
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

  def self.delete_if_only_item(item_id)
    joins(:invoice_items).select('invoices.id, count(invoice_items) as item_count')
    .group('invoices.id')
    .where('invoice_items.item_id = ?', item_id)
    .having('count(invoice_items) = ?', 1)
    .destroy_all
  end
end
