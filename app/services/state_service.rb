# app/services/state_service.rb
class StateService
  # Returns an array of serialized states
  def list_states
    State.all.map { |s| GetStateDto.new(s).as_json }
  end

  # Returns a single serialized state or nil
  def get_state(id)
    state = State.find_by(id: id)
    state ? GetStateDto.new(state).as_json : nil
  end

  # Updates a state and returns the serialized result, or nil if not found
  def update_state(id, params)
    state = State.find_by(id: id)
    return nil unless state

    state.update(params)
    GetStateDto.new(state).as_json
  end
end
