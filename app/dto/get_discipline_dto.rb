# class GetDisciplineDto
#     attr_accessor :id, :name, :abbreviation, :isForProvider
  
#     def initialize(discipline)
#       @id = discipline.id
#       @name = discipline.name
#       @abbreviation = discipline.abbreviation
#       @isForProvider = discipline.isForProvider
#     end
  
#     def as_json(*)
#       {
#         id: id,
#         name: name,
#         abbreviation: abbreviation,
#         isForProvider: isForProvider
#       }
#     end
#   end
GetDisciplineDto = Struct.new(:id, :name, :abbreviation, :isForProvider) do
  def initialize(discipline)
    super(discipline.id, discipline.name, discipline.abbreviation, discipline.isForProvider)
  end

  def as_json(*)
    {
      id: id,
      name: name,
      abbreviation: abbreviation,
      isForProvider: isForProvider
    }
  end
end
