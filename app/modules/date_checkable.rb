module DateCheckable

  def self.revenue_by_date_error?(start_date, end_date)
    if start_date.nil? || end_date.nil?
      true
    elsif start_date == "" || end_date == ""
      true
    elsif end_date < start_date
      true
    end
  end

  def self.clean_date(date)
    new_date = date.split("-")
    Date.new(new_date[0].to_i, new_date[1].to_i, new_date[2].to_i)
  end
end
