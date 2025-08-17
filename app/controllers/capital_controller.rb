class CapitalController < ApplicationController
  before_action :set_service

  def index
    render json: @service.list_capitals
  end

  private
  def set_service
    @service = CapitalService.new
  end
end