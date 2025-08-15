class StatesController < ApplicationController
  before_action :set_service
  RETURN_DTO = {
    index: GetStateDto,
    show:  GetStateDto,
    create: GetStateDto,
    update: GetStateDto
  }
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
    state = @service.update_state(params[:id], state_params)
    state ? render(json: state) : head(:not_found)
  end

  private

  def set_service
    @service = StateService.new
  end

  def state_params
    params.require(:state).permit(:name, :abbreviation)
  end
end
