class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  scope :paginate, -> (page:, per_page:) {
    page = (page || 1).to_i
    per_page = (per_page || 20).to_i
    limit(per_page).offset((page - 1) * per_page)
  }

  def self.find_one(query)
    answer = where('lower(name) LIKE ?', "%#{query.downcase}%").limit(1)[0]
    if answer == nil
      answer = []
    else
      answer
    end
  end
  def self.find(query)
    where('lower(name) LIKE ?', "%#{query.downcase}%")
  end

  def self.total_revenue(merchant_id)
    joins(:transactions)
    .where('transactions.result = ?', 'success')
    .where('invoices.status = ?', 'shipped')
    .where(id: merchant_id)
    .pluck('sum(invoice_items.quantity * invoice_items.unit_price) as rev')[0]
  end

  def total_revenue
    transactions
    .where('transactions.result = ?', 'success')
    .where('invoices.status = ?', 'shipped')
    .pluck('sum(invoice_items.quantity * invoice_items.unit_price) as rev')[0]
  end

  def self.total_revenue_of_unshipped_items(limit = 10)
    joins(:transactions)
    .where('transactions.result = ?', 'success')
    .where('invoices.status = ?', 'packaged')
    .select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as rev')
    .group('invoices.id')
    .order('rev desc')
    .limit(limit)
  end

  def self.top_merchants_by_total_revenue(limit)
    joins(:transactions)
    .where('transactions.result = ?', 'success')
    .where('invoices.status = ?', 'shipped')
    .group(:id)
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as rev')
    .order('rev desc')
    .limit(limit)
  end

  def self.total_revenue_by_date(start_date, end_date)
    joins(:transactions)
    .where('transactions.result = ?', 'success')
    .where('invoices.status = ?', 'shipped')
    .where('invoices.updated_at >= ?', start_date)
    .where('invoices.updated_at <= ?', end_date)
    .pluck('sum(invoice_items.quantity * invoice_items.unit_price) as rev')[0]
  end

  def self.revenue_by_month
    joins(:transactions)
    .where('transactions.result = ?', 'success')
    .where('invoices.status = ?', 'shipped')
    .select("DATE_TRUNC('year', invoices.updated_at) AS year, DATE_TRUNC('month', invoices.updated_at) AS month, sum(invoice_items.quantity * invoice_items.unit_price) as rev")
    .group('year', 'month')
    .order('year', 'month')
    .pluck("DATE_TRUNC('year', invoices.updated_at) AS year", "DATE_TRUNC('month', invoices.updated_at) AS month", 'sum(invoice_items.quantity * invoice_items.unit_price) as rev')
  end
end
