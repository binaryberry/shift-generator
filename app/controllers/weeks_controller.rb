class WeeksController < ApplicationController
  before_action {@weeks = Week.all.order(:start_date)}

	def index
    @week = Week.new
    Week.roles.each do |role|
      @week.assignments.build(role: role)
    end
	end

  def create
    @week = Week.new(week_params)
    scheduler = Scheduler.new(@week)
    Week.roles.each{|role| scheduler.assign(role)}
    if @week.persisted?
      redirect_to weeks_path if @week.persisted?
    else
      render 'index'
    end
  end

  def edit
    @week = Week.find(params[:id])
  end

  def destroy
    @week = Week.find(params[:id])
    @week.destroy
    render 'index'
  end


private

  def week_params
    params.require(:week).permit(:start_date, :assignments_attributes => [:person_id, :role] )
  end
end
