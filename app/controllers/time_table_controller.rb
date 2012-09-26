class TimeTableController < ApplicationController
  def show
    timetable = Timetable.get_time_table_for_week(params[:stop_number], Date.parse(params[:date]))

    render :json => timetable
  end

  def stops
    render :json => Stop.get_stops_for_coordinates(params[:start_lat], params[:start_long], params[:end_lat], params[:end_long])
  end

  def routes
    render :json => Route.get_all_routes_for_stop(params[:stop_number])
  end
end
