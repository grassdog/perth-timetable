PerthTimetable::Application.routes.draw do
  get 'time_table/:stop_number/:date', :to => 'time_table#show'
  get 'stops', :to => 'time_table#stops'
  get 'routes/:stop_number', :to => 'time_table#routes'
end
