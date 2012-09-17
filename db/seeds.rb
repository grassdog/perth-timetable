p "Starting at #{Time.now}"

connection = ActiveRecord::Base.connection()

p "deleting all current data"
connection.execute("delete from agencies")
connection.execute("delete from deviations")
connection.execute("delete from landmarks")
connection.execute("delete from routes")
connection.execute("delete from services")
connection.execute("delete from shapes")
connection.execute("delete from stops")
connection.execute("delete from stop_times")
connection.execute("delete from trips")

# agency_id, agency_name,agency_url,agency_timezone,agency_lang
p "importing agency.txt"
connection.execute("drop table if exists temp")
connection.execute("create table temp (agency_id integer, name character varying(255), url character varying(255), timezone character varying(255), lang character varying(255));")
connection.execute("copy temp from '/Users/tlauchen/RubymineProjects/perth-timetable/doc/rawdata/agency.txt' delimiters ',' csv header;")
connection.execute("insert into agencies (agency_id, name, url, timezone, lang) select * from temp")

# service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date
p "importing calendar.txt"
connection.execute("drop table if exists temp")
connection.execute("create table temp (service_id integer, monday boolean, tuesday boolean, wednesday boolean, thursday boolean, friday boolean, saturday boolean, sunday boolean, start_date date, end_date date);")
connection.execute("copy temp from '/Users/tlauchen/RubymineProjects/perth-timetable/doc/rawdata/calendar.txt' delimiters ',' csv header;")
connection.execute("insert into services (service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday, start_date, end_date) select * from temp")

# service_id,date,exception_type
p "importing calendar_dates.txt"
connection.execute("drop table if exists temp")
connection.execute("create table temp (service_id integer, date date, exception_type integer);")
connection.execute("copy temp from '/Users/tlauchen/RubymineProjects/perth-timetable/doc/rawdata/calendar_dates.txt' delimiters ',' csv header;")
connection.execute("insert into deviations (service_id, date, exception_type) select * from temp")

# landmark_id,landmark_name,landmark_pt_lat, landmark_pt_lon,landmark_typeid,landmark_typename
p "importing custom_landmarks.txt"
connection.execute("drop table if exists temp")
connection.execute("create table temp (landmark_id integer, name character varying(255), pt_lat double precision,  pt_lon double precision, typeid integer, typename character varying(255));")
connection.execute("copy temp from '/Users/tlauchen/RubymineProjects/perth-timetable/doc/rawdata/custom_landmarks.txt' delimiters ',' csv header;")
connection.execute("insert into landmarks (landmark_id, name, pt_lat,  pt_lon, type_id, type_name) select * from temp")

# route_id,agency_id,route_short_name,route_long_name,route_desc,route_type,route_url
p "importing routes.txt"
connection.execute("drop table if exists temp")
connection.execute("create table temp (route_id integer, agency_id integer, short_name character varying(255), long_name character varying(255), description character varying(255), route_type integer, url character varying(1024));")
connection.execute("copy temp from '/Users/tlauchen/RubymineProjects/perth-timetable/doc/rawdata/routes.txt' delimiters ',' csv header;")
connection.execute("insert into routes (route_id, agency_id, short_name, long_name, description, route_type, url) select * from temp")

# location_type, parent_station, stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon
p "importing stops.txt"
connection.execute("drop table if exists temp")
connection.execute("create table temp (location_type integer, parent_station integer, stop_id integer, code integer, name character varying(255), description character varying(255), lat double precision, lon double precision);")
connection.execute("copy temp from '/Users/tlauchen/RubymineProjects/perth-timetable/doc/rawdata/stops.txt' delimiters ',' csv header;")
connection.execute("insert into stops (location_type, parent_station, stop_id, code, name, description, lat, lon) select * from temp")

# route_id,service_id,trip_id,trip_headsign,shape_id
p "importing trips.txt"
connection.execute("drop table if exists temp")
connection.execute("create table temp (route_id integer, service_id integer, trip_id integer, headsign character varying(255), shape_id integer);")
connection.execute("copy temp from '/Users/tlauchen/RubymineProjects/perth-timetable/doc/rawdata/trips.txt' delimiters ',' csv header;")
connection.execute("insert into trips (route_id, service_id, trip_id, headsign, shape_id) select * from temp")

# shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, shape_dist_traveled
p "importing shapes.txt"
connection.execute("drop table if exists temp")
connection.execute("create table temp (shape_id integer, pt_lat double precision, pt_lon double precision, pt_sequence integer, dist_traveled double precision);")
connection.execute("copy temp from '/Users/tlauchen/RubymineProjects/perth-timetable/doc/rawdata/shapes.txt' delimiters ',' csv header;")
connection.execute("insert into shapes (shape_id, pt_lat, pt_lon, pt_sequence, dist_traveled) select * from temp")

# trip_id,arrival_time,departure_time,stop_id,stop_sequence,pickup_type,drop_off_type, shape_dist_traveled
p "importing stop_times.txt"
connection.execute("drop table if exists temp")
connection.execute("create table temp (trip_id integer, arrival_time character varying(255), departure_time character varying(255), stop_id integer, stop_sequence integer, pickup_type integer, drop_off_type integer, shape_dist_traveled double precision);")
connection.execute("copy temp from '/Users/tlauchen/RubymineProjects/perth-timetable/doc/rawdata/stop_times.txt' delimiters ',' csv header;")
connection.execute("insert into stop_times (trip_id, arrival_time, departure_time, stop_id, stop_sequence, pickup_type, drop_off_type, shape_dist_traveled) select * from temp")

connection.execute("drop table if exists temp")

p "Finished at #{Time.now}"