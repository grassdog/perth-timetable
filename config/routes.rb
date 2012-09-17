PerthTimetable::Application.routes.draw do
  get 'time_table/:stop_number/:date', :to => 'time_table#show'
end
