class CreateInitialTables < ActiveRecord::Migration
  def up
    create_table "agencies", :force => true do |t|
      t.integer "agency_id"
      t.string  "name"
      t.string  "url"
      t.string  "timezone"
      t.string  "lang"
    end

    create_table "services", :force => true do |t|
      t.integer "service_id"
      t.boolean  "monday"
      t.boolean  "tuesday"
      t.boolean  "wednesday"
      t.boolean  "thursday"
      t.boolean  "friday"
      t.boolean  "saturday"
      t.boolean  "sunday"
      t.date  "start_date"
      t.date  "end_date"
    end

    create_table "trips", :force => true do |t|
      t.integer  "route_id"
      t.integer  "service_id"
      t.integer  "trip_id"
      t.string  "headsign"
      t.integer  "shape_id"
    end

    create_table "stops", :force => true do |t|
      t.integer  "location_type"
      t.integer  "parent_station"
      t.integer "stop_id"
      t.integer  "code"
      t.string  "name"
      t.string  "description"
      t.float  "lat"
      t.float  "lon"
    end

    create_table "shapes", :force => true do |t|
      t.integer  "shape_id"
      t.float  "pt_lat"
      t.float  "pt_lon"
      t.integer  "pt_sequence"
      t.float  "dist_traveled"
    end

    create_table "routes", :force => true do |t|
      t.integer "route_id"
      t.integer  "agency_id"
      t.string  "short_name"
      t.string  "long_name"
      t.string  "description"
      t.integer  "route_type"
      t.string  "url", :limit => 1024
    end

    create_table "landmarks", :force => true do |t|
      t.integer "landmark_id"
      t.string  "name"
      t.float  "pt_lat"
      t.float  "pt_lon"
      t.integer  "type_id"
      t.string  "type_name"
    end

    create_table "deviations", :force => true do |t|
      t.integer  "service_id"
      t.date  "date"
      t.integer  "exception_type"
    end

    create_table "stop_times", :force => true do |t|
      t.integer  "trip_id"
      t.string  "arrival_time"
      t.string  "departure_time"
      t.integer  "stop_id"
      t.integer  "stop_sequence"
      t.integer  "pickup_type"
      t.integer  "drop_off_type"
      t.float  "shape_dist_traveled"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end