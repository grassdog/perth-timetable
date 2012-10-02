class Route < ActiveRecord::Base
  belongs_to :agency
  has_many :trips

  def self.get_all_routes_for_stop stop_number
    stop = Stop.find_by_stop_id stop_number
    return { :routes => []} if stop.nil?

    stop_numbers = [stop_number] if stop.child_stops.empty?
    stop_numbers = stop.child_stops.map { |s| s.stop_id } unless stop.child_stops.empty?

    routes = []
    stop_numbers.each do |s|
      routes += get_routes_for_stop_with_no_children(s)
    end
    { :routes => routes }
  end

  def self.get_routes_for_stop_with_no_children stop_number
    connection = ActiveRecord::Base.connection()
    result = connection.execute("SELECT DISTINCT
                                  r.short_name as route_number,
                                  r.long_name as route_name,
                                  t.headsign,
                                  stop.stop_id as stop_number,
                                  stop.name as stop_name
                                  FROM services s
                                  JOIN trips t ON t.service_id = s.service_id
                                  JOIN routes r ON r.route_id = t.route_id
                                  JOIN stop_times stopt ON stopt.trip_id = t.trip_id
                                  JOIN stops stop ON stop.stop_id = stopt.stop_id
                                  WHERE stop.stop_id = #{stop_number}
                                  ORDER BY r.short_name")
    result.to_a
  end
end