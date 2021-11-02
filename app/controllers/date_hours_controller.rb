class DateHoursController < ApplicationController

  def index
    pp_dates = get_all_days_from_pay_period(params[:employee_id], params[:pay_period_id])

    begin 
      d_hs = Employee
      .find(params[:employee_id])
      .date_hours
      .where(pay_period_id: params[:pay_period_id])

      totals = d_hs.sum(:hours)
    rescue ActiveRecord::RecordNotFound
      d_hs = []
      totals = "0.0000"
    end

    date_hours = merge_date_hours_worked_with_pp_days(d_hs.to_a, pp_dates)

    render :json => { date_hours: date_hours, totals: totals }
  end

  def create
    DateHour.transaction do
      begin
        @date_hours = DateHour.create!(date_hours_params)
      rescue ActiveRecord::RecordInvalid => e
        render :json => { errors: e.message }, status: 406
        return
      end
    end 
    render :json => @date_hours 
  end

  private

  def date_hours_params
    params.permit(date_hours: [:pay_period_id, :employee_id, :hours, :date, :day]).require(:date_hours)
  end

  def merge_date_hours_worked_with_pp_days(d_hs, pp_dates)
    (d_hs | pp_dates).uniq { |d_h| d_h[:date] }.sort_by { |d_h| d_h[:date] }
  end

  def get_all_days_from_pay_period(e_id, pp_id)
    pp_dates = generate_pp_range(pp_id).to_a
    pp_dates.map { |date| DateHour.new(date: date, employee_id: e_id, pay_period_id: pp_id) }
  end

  def generate_pp_range(pp_id) 
    begin
      pp = PayPeriod.find(pp_id)
      Range.new(pp.start_date.to_s, pp.end_date.to_s)
    rescue ActiveRecord::RecordNotFound
      []
    end
  end
end