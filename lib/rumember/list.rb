class Rumember
  class List < Abstract

    reader :name, :filter
    boolean_reader :archived, :deleted, :locked, :smart
    integer_reader :id, :position
    alias to_s name

    def params
      {'list_id' => id}
    end

    def tasks
      list = dispatch('tasks.getList')['tasks']['list']
      if list.kind_of?(Array)
        taskseries = list.flat_map { |l| if l['taskseries'].kind_of?(Array) then l['taskseries'] else [l['taskseries']] end }
      else
        taskseries = if list['taskseries'].kind_of?(Array) then list['taskseries'] else [list['taskseries']] end
      end
      taskseries.map do |t|
        Task.new(self, t)
      end
    end

  end
end
