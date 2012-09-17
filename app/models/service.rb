class Service < ActiveRecord::Base
  has_many :deviations, :primary_key => "service_id"
  has_many :trips, :primary_key => "service_id"
end