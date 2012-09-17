class AddIndices < ActiveRecord::Migration
  def up
    add_index :agencies, :agency_id
    add_index :services, :service_id
    add_index :trips, :trip_id
    add_index :trips, :service_id
    add_index :stops, :stop_id
    add_index :shapes, :shape_id
    add_index :routes, :route_id
    add_index :landmarks, :landmark_id
    add_index :deviations, :service_id
    add_index :stop_times, :stop_id
  end

  def down
    remove_index :agencies, :agency_id
    remove_index :services, :service_id
    remove_index :trips, :trip_id
    remove_index :trips, :service_id
    remove_index :stops, :stop_id
    remove_index :shapes, :shape_id
    remove_index :routes, :route_id
    remove_index :landmarks, :landmark_id
    remove_index :deviations, :service_id
    remove_index :stop_times, :stop_id
  end
end