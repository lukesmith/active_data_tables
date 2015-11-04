require 'active_record'

class Event < ActiveRecord::Base

  def to_s
    "#{title} - #{description} - #{date}"
  end

end
