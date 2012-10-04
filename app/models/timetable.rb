class Timetable
  def self.get_time_table_for_week stop_number, date, routes
    begin
      stop = Stop.find_by_stop_id(stop_number)
      return { "timetable" => [] } if stop.nil?

      stop_numbers = stop.child_stops.map { |s| s.stop_id }
      stop_numbers << stop.stop_id

      stops = {}
      (0..6).each do |delta|
        times = get_time_table_for_date(stop_numbers, date + delta, routes)
        times.each do |single_stop|
          stop = stops[single_stop["stop_number"]] ||= { "stop_name" => single_stop["stop_name"], "stop_number" => single_stop["stop_number"], "routes" => {} }
          route = stop["routes"][single_stop["route_number"] + single_stop["headsign"]] ||= { "route_number" => single_stop["route_number"], "route_name" => single_stop["route_name"], "headsign" => single_stop["headsign"], "departure_times" => [] }
          route["departure_times"] << single_stop["departure"]
        end
      end

      stops.each do |key, s|
        s["routes"] = s["routes"].map { |key, r| r }
      end

      timetable = { "timetable" => stops.map { |number, route_data| route_data } }
      return timetable
    rescue
      return { "timetable" => [] }
    end
  end


  def self.get_time_table_for_date stop_numbers, date, routes = nil
    connection = ActiveRecord::Base.connection()
    result = connection.execute("SELECT
                                  stop.stop_id as stop_number,
                                  stop.name as stop_name,
                                  r.short_name as route_number,
                                  r.long_name as route_name,
                                  t.headsign,
                                  '#{date.to_formatted_s(:db)}'::DATE + stopt.departure_time::INTERVAL as departure
                                  FROM services s
                                  JOIN trips t ON t.service_id = s.service_id
                                  JOIN routes r ON r.route_id = t.route_id
                                  JOIN stop_times stopt ON stopt.trip_id = t.trip_id
                                  JOIN stops stop ON stop.stop_id = stopt.stop_id
                                  WHERE s.start_date <= '#{date.to_formatted_s(:db)}'
                                    AND s.end_date >= '#{date.to_formatted_s(:db)}'
                                    AND ((s.sunday AND EXTRACT(DOW FROM '#{date.to_formatted_s(:db)}'::DATE) = 0)
                                         OR (s.monday AND EXTRACT(DOW FROM '#{date.to_formatted_s(:db)}'::DATE) = 1)
                                         OR (s.tuesday AND EXTRACT(DOW FROM '#{date.to_formatted_s(:db)}'::DATE) = 2)
                                         OR (s.wednesday AND EXTRACT(DOW FROM '#{date.to_formatted_s(:db)}'::DATE) = 3)
                                         OR (s.thursday AND EXTRACT(DOW FROM '#{date.to_formatted_s(:db)}'::DATE) = 4)
                                         OR (s.friday AND EXTRACT(DOW FROM '#{date.to_formatted_s(:db)}'::DATE) = 5)
                                         OR (s.saturday AND EXTRACT(DOW FROM '#{date.to_formatted_s(:db)}'::DATE) = 6)
                                         OR EXISTS (SELECT 1 FROM deviations d
                                                    WHERE d.date = '#{date.to_formatted_s(:db)}'
                                                      AND exception_type = 1
                                                      AND d.service_id = s.service_id))
                                    AND NOT EXISTS (SELECT 1 FROM deviations d
                                                    WHERE d.date = '#{date.to_formatted_s(:db)}'
                                                      AND exception_type = 2
                                                      AND d.service_id = s.service_id)
                                    AND stop.stop_id IN (#{stop_numbers.join(", ")})
                                    #{build_routes_clause(routes)}
                                  ORDER BY r.short_name, departure_time")

    result.to_a
  end

  def self.build_routes_clause routes
    return "" if routes.nil? || routes.empty?

    conditions = routes.map do |mapping|
      key = mapping.first[0]
      headsign = mapping.first[1]
      "(r.short_name = '#{key}' AND t.headsign = '#{headsign}')"
    end

    "AND (#{conditions.join(" OR ")})"
  end
end