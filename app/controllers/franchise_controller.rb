# app/controllers/franchises_controller.rb
class FranchiseController < ApplicationController
  before_action :set_service

  # GET /franchises/customer/:customer_id
  def for_customer
    franchises = @service.list_franchises_for_customer(params[:customer_id])
    render json: franchises
  end

  private

  def set_service
    @service = FranchiseService.new
  end
end
