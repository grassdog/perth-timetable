class Trip < ActiveRecord::Base
  belongs_to :route, :primary_key => 'route_id'
  belongs_to :service, :primary_key => 'service_id'
  has_many :stop_times, :primary_key => 'trip_id'
end