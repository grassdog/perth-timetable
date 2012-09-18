class Timetable
  def self.get_time_table_for_week stop_number, date
    timetable = {}
    (0..6).each do |delta|
      selected_date = date + delta
      timetable[selected_date] = get_time_table_for_date(stop_number, selected_date)
    end

    timetable
  end

  def self.get_time_table_for_date stop_number, date
    connection = ActiveRecord::Base.connection()
    result = connection.execute("SELECT
                                  stop.stop_id as stop_number,
                                  stop.name as stop_name,
                                  r.short_name as route_number,
                                  r.long_name as route_name,
                                  t.headsign,
                                  stopt.departure_time,
                                  CURRENT_DATE + stopt.departure_time::INTERVAL as departure
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
                                    AND stop.stop_id = #{stop_number}
                                  ORDER BY departure_time")

    result.to_a
  end
end