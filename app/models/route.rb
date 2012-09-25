class Route < ActiveRecord::Base
  belongs_to :agency
  has_many :trips

  def self.get_all_routes_for_stop stop_number
      connection = ActiveRecord::Base.connection()
      result = connection.execute("SELECT DISTINCT
                                    r.short_name as route_number,
                                    r.long_name as route_name,
                                    t.headsign
                                    FROM services s
                                    JOIN trips t ON t.service_id = s.service_id
                                    JOIN routes r ON r.route_id = t.route_id
                                    JOIN stop_times stopt ON stopt.trip_id = t.trip_id
                                    JOIN stops stop ON stop.stop_id = stopt.stop_id
                                    WHERE stop.stop_id = #{stop_number}
                                    ORDER BY r.short_name")
      { :routes => result.to_a }
    end
end