# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120914063407) do

  create_table "agencies", :force => true do |t|
    t.integer "agency_id"
    t.string  "name"
    t.string  "url"
    t.string  "timezone"
    t.string  "lang"
  end

  add_index "agencies", ["agency_id"], :name => "index_agencies_on_agency_id"

  create_table "deviations", :force => true do |t|
    t.integer "service_id"
    t.date    "date"
    t.integer "exception_type"
  end

  add_index "deviations", ["service_id"], :name => "index_deviations_on_service_id"

  create_table "landmarks", :force => true do |t|
    t.integer "landmark_id"
    t.string  "name"
    t.float   "pt_lat"
    t.float   "pt_lon"
    t.integer "type_id"
    t.string  "type_name"
  end

  add_index "landmarks", ["landmark_id"], :name => "index_landmarks_on_landmark_id"

  create_table "routes", :force => true do |t|
    t.integer "route_id"
    t.integer "agency_id"
    t.string  "short_name"
    t.string  "long_name"
    t.string  "description"
    t.integer "route_type"
    t.string  "url",         :limit => 1024
  end

  add_index "routes", ["route_id"], :name => "index_routes_on_route_id"

  create_table "services", :force => true do |t|
    t.integer "service_id"
    t.boolean "monday"
    t.boolean "tuesday"
    t.boolean "wednesday"
    t.boolean "thursday"
    t.boolean "friday"
    t.boolean "saturday"
    t.boolean "sunday"
    t.date    "start_date"
    t.date    "end_date"
  end

  add_index "services", ["service_id"], :name => "index_services_on_service_id"

  create_table "shapes", :force => true do |t|
    t.integer "shape_id"
    t.float   "pt_lat"
    t.float   "pt_lon"
    t.integer "pt_sequence"
    t.float   "dist_traveled"
  end

  add_index "shapes", ["shape_id"], :name => "index_shapes_on_shape_id"

  create_table "stop_times", :force => true do |t|
    t.integer "trip_id"
    t.string  "arrival_time"
    t.string  "departure_time"
    t.integer "stop_id"
    t.integer "stop_sequence"
    t.integer "pickup_type"
    t.integer "drop_off_type"
    t.float   "shape_dist_traveled"
  end

  add_index "stop_times", ["stop_id"], :name => "index_stop_times_on_stop_id"

  create_table "stops", :force => true do |t|
    t.integer "location_type"
    t.integer "parent_station"
    t.integer "stop_id"
    t.integer "code"
    t.string  "name"
    t.string  "description"
    t.float   "lat"
    t.float   "lon"
  end

  add_index "stops", ["stop_id"], :name => "index_stops_on_stop_id"

  create_table "trips", :force => true do |t|
    t.integer "route_id"
    t.integer "service_id"
    t.integer "trip_id"
    t.string  "headsign"
    t.integer "shape_id"
  end

  add_index "trips", ["service_id"], :name => "index_trips_on_service_id"
  add_index "trips", ["trip_id"], :name => "index_trips_on_trip_id"

end
