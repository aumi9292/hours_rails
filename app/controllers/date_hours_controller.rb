class DateHoursController < ApplicationController
  def index
    pp_dates = get_all_days_from_pay_period(params[:employee_id], params[:pay_period_id])

    d_hs = Employee.find(params[:employee_id])
    .date_hours
    .select { |d_h| d_h.pay_period_id == params[:pay_period_id].to_i }

    render :json => merge_date_hours_worked_with_pp_days(d_hs, pp_dates)
  end

  private

  def merge_date_hours_worked_with_pp_days(d_hs, pp_dates)
    pp_dates.each { |pp_d| d_hs << pp_d if d_hs.none? { |dt| dt[:date].to_s == pp_d[:date]} }
    d_hs.sort_by! {|d_h| Date.strptime(d_h[:date].to_s)}
    {date_hours: d_hs, totals: calculate_hours(d_hs)}
  end

  def get_all_days_from_pay_period(e_id, pp_id)
    pp_dates = generate_pp_range(pp_id).to_a
    pp_dates.map { |date| format_date_hour({date: date}, e_id, pp_id) }
  end

  def generate_pp_range(pp_id) 
    pp = PayPeriod.find(pp_id)
    Range.new(pp.start_date.to_s, pp.end_date.to_s)
  end

  def format_date_hour(row, e_id, pp_id, id = nil)
    d_h = parse_date_hour(row)
    row
    d_h.merge({ id: row[:id] || id, employee_id: e_id, pay_period_id: pp_id })
  end

  def parse_date_hour(d_h)
    { date: d_h[:date], day: Date.parse(d_h[:date]).strftime('%A'), hours: d_h[:hours] || "0.0000" }
  end

  def calculate_hours(d_hs)
    total = d_hs.reduce(0) {|total, d_h| total + d_h[:hours].to_i}
    '%.4f' % total
  end
end