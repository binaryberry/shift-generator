class WeeksController < ApplicationController
  before_action {@weeks = Week.all.order(:start_date)}
  respond_to :json

  def index
    @week = Week.new(start_date: Week.default_start_date)
    Week.roles.each do |role|
      @week.assignments.build(role: role)
    end
  end

  def create
    @week = Week.new(start_date: Week.default_start_date)
    scheduler = Scheduler.new(@week)
    Week.roles.each{|role| scheduler.assign(role)} #PAUL: I now have a bug where only one assignment per week happens.
    if @week.persisted?
      redirect_to weeks_path
    else
      render 'index'
    end
  end

  def edit
    @week = Week.find(params[:id])
  end

  def update
    @week = Week.find(params[:id])
    if @week.update_attributes(week_params) #PAUL: error message here saying I'm not giving the :week to weeks_params -
      # param is missing or the value is empty: week
      # ActionController::ParameterMissing in WeeksController#update
      flash[:success] = "Week updated"
      redirect_to weeks_path
    else
      flash[:error] = "Week errored"
      render 'edit'
    end
  end

  def destroy
    @week = Week.find(params[:id])
    @week.destroy
    redirect_to weeks_path
  end


private

  def week_params
    params.require(:week).permit(:start_date, :assignments_attributes => [:person_id, :role] )
  end
end
