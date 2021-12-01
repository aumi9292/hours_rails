class EmployeesController < ApplicationController
  load_and_authorize_resource

  def index
    render :json => Employee.all
  end

  def show
    render :json => Employee.find(params[:id])
  end
end