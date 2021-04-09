module DateCheckable

  def revenue_by_date_error?
    if params[:start].nil? || params[:end].nil?
      true
    elsif params[:start] == "" || params[:end] == ""
      true
    elsif params[:end] < params[:start]
      true
    end
  end
  
  def clean_date(date)
    new_date = date.split("-")
    Date.new(new_date[0].to_i, new_date[1].to_i, new_date[2].to_i)
  end
end
