class WeeksController < ApplicationController
  before_action {@weeks = Week.all.order(:start_date)}

  def index
    @week = Week.new(start_date: Week.default_start_date)
    @weeks << @week

    Week.roles.each do |role|
      @week.assignments.build(role: role)
    end
  end

  def create
    @week = Week.new(week_params)
    @week.start_date = Week.default_start_date
    @week.save
    scheduler = Scheduler.new(@week)
    Week.roles.each {|role| scheduler.assign(role)}

    if @week.persisted?
      redirect_to weeks_path
    else
      render 'index'
    end
  end

  def edit
    @week = Week.find(params[:id])
    render 'index'
  end

  def update
    @week = Week.find(params[:id])
    if @week.update_attributes(week_params)
      redirect_to weeks_path
    else
      render 'index'
    end
  end

  def destroy
    @week = Week.find(params[:id])
    @week.destroy
    redirect_to weeks_path
  end


private

  def week_params
    params.require(:week).permit(:start_date, :assignments_attributes => [:person_id, :role, :id] )
  end
end
