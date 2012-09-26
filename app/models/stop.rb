class Stop < ActiveRecord::Base
  has_many :stop_times, :primary_key => 'stop_id'
  has_one :parent_stop, :class_name => 'Stop', :foreign_key => 'parent_station', :primary_key => 'stop_id'
  has_many :child_stops, :class_name => 'Stop', :foreign_key => 'parent_station', :primary_key => 'stop_id'

  def self.get_stops_for_coordinates start_lat = nil, start_long = nil, end_lat = nil, end_long = nil
    stops_query = Stop.where(:parent_station => nil)
    stops_query = stops_query.where("lat <= ?", start_lat) unless start_lat.nil?
    stops_query = stops_query.where("lon >= ?", start_long) unless start_long.nil?
    stops_query = stops_query.where("lat >= ?", end_lat) unless end_lat.nil?
    stops_query = stops_query.where("lon <= ?", end_long) unless end_long.nil?

    {:stops => stops_query.all.map { |s| { :stop_number => s.stop_id, :stop_name => s.name, :lat => s.lat, :long => s.lon } } }
  end
end