module ApplicationHelper
  def last_updated_date
    File.mtime(Rails.root.join("REVISION")).to_date rescue Time.zone.today
  end
end
