class CustomerController < ApplicationController
  before_action :set_service

  def create
    customer = @service.create_customer(customer_params)
    render json: customer, status: :created
  end

  private

  def set_service
    @service = CustomerService.new
  end

  def customer_params
    {
      first_name: params[:firstName],
      last_name: params[:lastName],
      buy_in_reason: params[:buyInReason],
      vision: params[:vision],
      involvement: params[:involvement],
      capital_id: params[:capitalId],
      finance_required: params[:financeRequired],
      start_date: params[:startDate]
    }
  end
end