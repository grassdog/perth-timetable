class StopTime < ActiveRecord::Base
  belongs_to :trip, :primary_key => 'trip_id'
  belongs_to :stop, :primary_key => 'stop_id'
end