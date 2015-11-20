class WeeksController < ApplicationController

	def index
		@weeks = Week.all

    @week = Week.new
    Week.roles.each do |role|
      @week.assignments.build(role: role)
    end
	end

  def create
    @week = Week.create(week_params)
    redirect_to weeks_path
  end

  def edit
    @week = Week.find(params[:id])
    redirect_to weeks_path
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
