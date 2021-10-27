require 'Date'

class PayPeriodsController < ApplicationController

  def index
    render :json => PayPeriod.all
  end

  def show
    render :json => PayPeriod.find(params[:id])
  end
end