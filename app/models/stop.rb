class Stop < ActiveRecord::Base
  has_many :stop_times, :primary_key => 'stop_id'
  has_one :parent_station, :class_name => 'Stop', :foreign_key => 'parent_station', :primary_key => 'stop_id'

  scope :full_text_search, lambda { |stop_number, start_date, end_date|
  }
end