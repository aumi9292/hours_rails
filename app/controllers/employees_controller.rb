class EmployeesController < ApplicationController
  def index
    #@employees = Employee.all # instance variable for resource is automatically created and available in view
    render :json => Employee.all
  end

  def show
    render :json => Employee.find(params[:id])
  end
end