class StatesController < ApplicationController
  before_action :set_service

  # # dto:generate
  # RETURN_DTO = {
  #   index:  { response: GetStateDto },
  #   show:   { response: GetStateDto },
  #   create: { request: UpdateStateDto, response: GetStateDto },
  #   update: { request: UpdateStateDto, response: GetStateDto }
  # }

  # dtov2:generate
  RETURN_DTO = {
    index:  { response: GetStateDto },
    show:   { response: GetStateDto },
    create: { params: UpdateStateDto, response: GetStateDto },
    update: { params: UpdateStateDto, response: GetStateDto }
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
