class WeeksController < ApplicationController
  # before_action {@weeks = Week.all.order(:start_date)}

  def index
    @weeks = Week.where('start_date > ?', Date.today - 6 )
    @week = Week.new(start_date: Week.default_start_date)
    @weeks << @week

    Week.roles.each do |role|
      @week.assignments.build(role: role)
    end
  end

  def history
    @weeks = Week.where('start_date < ?', Date.today - 6 )
    @week = Week.new(start_date: Week.default_start_date)
    @history = true

    render 'index'
  end

  def create
    @week = Week.new
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
    @weeks = Week.where('start_date > ?', Date.today + 1 )
    @week = Week.find(params[:id])
    render 'index'
  end

  def update
    @week = Week.find(params[:id])
    week_params["assignment"].values.each do |attribute|
      add_person_to_assignment(attribute)
    end
    if @week.persisted?
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

  def add_person_to_assignment(attribute)
    if attribute["id"].present?
      assignmt = @week.assignments.find(attribute["id"])
      assignmt.update_attribute(:person_id, attribute["person_id"])
      assignmt.save!
    else
      @week.assignments.create!(role: attribute["role"], person_id: attribute["person_id"])
    end
  end

  def week_params
    params.require(:week).permit(:start_date, :assignment => [:person_id, :role, :id])
  end
end
