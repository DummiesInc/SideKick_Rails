class DisciplineService
  def list_disciplines
    Discipline.all.map { |d| GetDisciplineDto.new(d) }
  end

  def get_discipline(id)
    discipline = Discipline.find_by(id: id)
    discipline ? GetDisciplineDto.new(discipline) : nil
  end
end