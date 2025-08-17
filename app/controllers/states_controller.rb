class StatesController < ApplicationController
  before_action :set_service

  # GET /states
  def index
    render json: @service.list_states
  end

  # GET /states/:id
  def show
    state = @service.get_state(params[:id])
    state ? render(json: state) : head(:not_found)
  end

  # PUT /states/:id
  def update
    result = @service.update_state(params[:id], state_params)

    if result.is_a?(Array)
      render json: { errors: result }, status: :unprocessable_entity
    elsif result
      render json: result
    else
      head :not_found
    end
  end

  private

  def set_service
    @service = StateService.new
  end

  def state_params
    params.permit(:name, :abbreviation)
  end
end
