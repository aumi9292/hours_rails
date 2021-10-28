class DateHoursController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    pp_dates = get_all_days_from_pay_period(params[:employee_id], params[:pay_period_id])

    d_hs = Employee
    .find(params[:employee_id])
    .date_hours
    .where(pay_period_id: params[:pay_period_id])

    totals = d_hs.sum(:hours)

    #render :json => {date_hours: d_hs, totals: totals} # currently only returning date_hours an employee has worked, not all date_hours in the pay_period

    render :json => {date_hours: merge_date_hours_worked_with_pp_days(d_hs.to_a, pp_dates), totals: totals}
  end

  def create
    DateHour.transaction do
      @date_hours = DateHour.create(date_hours_params)
    end 
    render :json => @date_hours 
  end

  private

  def date_hours_params
    params.permit(date_hours: [:pay_period_id, :employee_id, :hours, :date, :day]).require(:date_hours)
  end

  def merge_date_hours_worked_with_pp_days(d_hs, pp_dates)
    pp_dates.each { |pp_d| d_hs << pp_d if d_hs.none? { |dt| dt[:date].to_s == pp_d[:date]} }
    d_hs.sort_by! {|d_h| Date.strptime(d_h[:date].to_s)}
    d_hs
  end

  def get_all_days_from_pay_period(e_id, pp_id)
    pp_dates = generate_pp_range(pp_id).to_a
    pp_dates.map { |date| format_date_hour({date: date}, e_id, pp_id) }
  end

  def generate_pp_range(pp_id) 
    pp = PayPeriod.find(pp_id)
    Range.new(pp.start_date.to_s, pp.end_date.to_s)
  end

  def format_date_hour(row, e_id, pp_id )
    d_h = parse_date_hour(row)
    d_h.merge({ employee_id: e_id, pay_period_id: pp_id })
  end

  def parse_date_hour(d_h)
    { date: d_h[:date], day: Date.parse(d_h[:date]).strftime('%A'), hours: d_h[:hours] || "0.0000" }
  end

  # def calculate_hours(d_hs)
  #   total = d_hs.reduce(0) {|total, d_h| total + d_h[:hours].to_f}
  #   '%.4f' % total
  # end
end