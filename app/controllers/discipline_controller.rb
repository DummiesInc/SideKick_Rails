class DisciplineController < ApplicationController
  before_action :set_service

  RETURN_DTO = {
    index: { response: GetDisciplineDto },
    show:  { response: GetDisciplineDto },
  }

  def index
    render json: @service.list_disciplines
  end

  def show
    discipline = @service.get_discipline(params[:id])
    discipline ? render(json: discipline) : head(:not_found)
  end

  private

  def set_service
    @service = DisciplineService.new
  end
end
