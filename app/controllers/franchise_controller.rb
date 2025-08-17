# app/controllers/franchises_controller.rb
class FranchiseController < ApplicationController
  before_action :set_service

  # GET /franchises/customer/:customer_id
  def for_customer
    result = @service.list_franchises_for_customer(params[:customer_id])
    render json: result
  end

  private

  def set_service
    @service = FranchiseService.new
  end
end
