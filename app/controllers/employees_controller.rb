class EmployeesController < ApplicationController
  def index
    render :json => Employee.all
  end

  def show
    render :json => Employee.find(params[:id])
  end
end