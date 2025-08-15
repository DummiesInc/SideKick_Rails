class StateService
    def list_states
      State.all.map { |s| GetStateDto.new(s) }
    end
  
    def get_state(id)
      state = State.find_by(id: id)
      state ? GetStateDto.new(state) : nil
    end
  
    def update_state(id, params)
      state = State.find_by(id: id)
      return nil unless state
  
      state.update(params)
      GetStateDto.new(state)
    end
end
  