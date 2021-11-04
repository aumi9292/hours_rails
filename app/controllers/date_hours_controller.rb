class DateHoursController < ApplicationController

  def index
    pp_dates = get_all_days_from_pay_period(params[:employee_id], params[:pay_period_id])

    specified_pay_period = PayPeriod.find(params[:pay_period_id])

    d_hs = Employee
    .find(params[:employee_id])
    .date_hours
    .where(pay_period_id: specified_pay_period.id)


    totals = d_hs.sum(:hours)

    date_hours = merge_date_hours_worked_with_pp_days(d_hs.to_a, pp_dates)

    render json: { date_hours: date_hours, totals: totals }
  end

  def create
    errors = false

    DateHour.transaction do
      begin
        @date_hours = DateHour.create!(date_hours_params)
      rescue ActiveRecord::RecordInvalid => e
        errors = true
        @date_hours = { errors: e.message }
        raise ActiveRecord::Rollback
      end
    end

    status = errors ? 422 : 200
    render json: @date_hours, status: status
  end

  def update
    # @date_hour = DateHour.find(params[:id])
    @date_hours = []
    errors = false

    begin
      DateHour.transaction do
        edit_date_hours_params.each do |updated_date_hour|
          @date_hour = DateHour.find(updated_date_hour[:id])
          @date_hour.update!(updated_date_hour)
          @date_hours << @date_hour
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      errors = true
      @date_hours = { errors: e.message }
    end

    status = errors ? 422 : 200
    render json: @date_hours, status: status
  end

  private

  def date_hours_params
    # params.permit(date_hours: [:pay_period_id, :employee_id, :hours, :date, :day]).require(:date_hours) # original, messy
    # params.require(:date_hours).permit([:pay_period_id, :employee_id, :hours, :date, :day]) # raises undefined method permit for Array

    params.require(:date_hours).map do |p|
      p.permit(:pay_period_id, :employee_id, :hours, :date, :day)
    end
  end

  def edit_date_hours_params
    params.require(:date_hours).map do |p|
      p.permit(:pay_period_id, :employee_id, :hours, :date, :day, :id)
    end
  end

  def merge_date_hours_worked_with_pp_days(d_hs, pp_dates)
    (d_hs | pp_dates).uniq { |d_h| d_h[:date] }.sort_by { |d_h| d_h[:date] }
  end

  def get_all_days_from_pay_period(e_id, pp_id)
    pp_dates = generate_pp_range(pp_id).to_a
    pp_dates.map { |date| DateHour.new(date: date, employee_id: e_id, pay_period_id: pp_id) }
  end

  def generate_pp_range(pp_id)
    pp = PayPeriod.find(pp_id)
    Range.new(pp.start_date.to_s, pp.end_date.to_s)
  end
end