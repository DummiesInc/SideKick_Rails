# app/dtos/get_state_dto.rb
class GetStateDto
  attr_reader :id, :name, :abbreviation

  def initialize(state)
    @id = state.id
    @name = state.name
    @abbreviation = state.abbreviation
  end

  def as_json(*)
    {
      id: id,
      name: name,
      abbreviation: abbreviation
    }
  end
end
