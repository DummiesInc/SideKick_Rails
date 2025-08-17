class StateService
  def list_states
    State.all
  end

  def get_state(id)
    State.find_by(id: id)
  end

  def update_state(id, attributes)
    state = State.find_by(id: id)
    return nil unless state

    state.update(attributes) ? state : state.errors.full_messages
  end
end
