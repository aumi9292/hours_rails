class DateHoursController < ApplicationController
  def index
    render json: Employee.find(params[:employee_id])
    .date_hours
    .select { |d_h| d_h.pay_period_id == params[:pay_period_id].to_i }
  end
end