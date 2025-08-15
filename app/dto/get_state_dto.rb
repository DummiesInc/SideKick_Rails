class GetStateDto
    attr_reader :id, :name, :abbreviation
  
    def initialize(state)
      @id = state.id
      @name = state.name
      @abbreviation = state.abbreviation
    end
  end
  