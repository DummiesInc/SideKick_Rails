# app/controllers/franchises_controller.rb
class FranchiseController < ApplicationController
  before_action :set_service

  # GET /franchises/customer/:customer_id
  def for_customer
    result = @service.list_franchises_for_customer(params[:customer_id])
    render json: result
  end

  def all_franchises
    # puts "Test #{pagination_params}"
    result = @service.list_franchises(pagination_params)
    render json: result
  end

  def get_franchise_profile
    result = @service.franchise_profile(params[:franchise_id])
    render json: result
  end

  private

  def set_service
    @service = FranchiseService.new
  end

  def pagination_params
    {
      page: (params[:page] || 1).to_i,
      per_page: (params[:perPage] || 10).to_i,
      franchise_name: params.dig(:param, :franchiseName)
    }
  end
end
