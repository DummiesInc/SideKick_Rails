# app/controllers/investment_sites_controller.rb
class InvestmentSiteController < ApplicationController
  # GET /investment_sites/search
  def search
    service = InvestmentSiteService.new(search_params)
    sites = service.call

    render json: sites
  end

  private

  def search_params
    params.permit(:north, :south, :east, :west)
  end
end
