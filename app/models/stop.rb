class Stop < ActiveRecord::Base
  has_many :stop_times, :primary_key => 'stop_id'
  has_one :parent_stop, :class_name => 'Stop', :foreign_key => 'parent_station', :primary_key => 'stop_id'
end