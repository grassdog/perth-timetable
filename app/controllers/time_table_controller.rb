class TimeTableController < ApplicationController
  def show
    timetable = Timetable.get_time_table_for_week(params[:stop_number], Date.parse(params[:date]))

    render :json => timetable
  end

  def stops
    stops = {:stops => Stop.all.map { |s| { :stop_number => s.stop_id, :stop_name => s.name, :lat => s.lat, :long => s.lon } } }

    render :json => stops
  end

  def routes
    render :json => Route.get_all_routes_for_stop(params[:stop_number])
  end
end
