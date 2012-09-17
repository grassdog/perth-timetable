class TimeTableController < ApplicationController
  def show
    timetable = Timetable.get_time_table_for_week(params[:stop_number], Date.parse(params[:date]))

    render :json => timetable
  end
end
