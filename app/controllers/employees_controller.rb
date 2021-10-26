class EmployeesController < ApplicationController
  def index
    render :json => {'a' => 'b'}
  end
end