# app/dto/update_state_dto.rb
UpdateStateDto = Struct.new(:id, :name, :abbreviation) do
  def initialize(params)
    super(
      params[:id]&.to_i,        # convert id to integer
      params[:name],
      params[:abbreviation]
    )
  end

  def as_json(*)
    { id: id, name: name, abbreviation: abbreviation }
  end
end
