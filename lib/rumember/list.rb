class Rumember
  class List < Abstract

    reader :name, :filter
    boolean_reader :archived, :deleted, :locked, :smart
    integer_reader :id, :position
    alias to_s name

    def params
      {'list_id' => id}
    end

    def tasks(params = {})
      list = dispatch('tasks.getList', params)['tasks']['list']
      if list.kind_of?(Array)
        list.flat_map do |l|
          ll = List.new(@parent, {'id' => l['id']})
          (l['taskseries'].kind_of?(Array) ? l['taskseries'] : [l['taskseries']]).map do |t|
            Task.new(ll, t)
          end
        end
      else
        (list['taskseries'].kind_of?(Array) ? list['taskseries'] : [list['taskseries']]).map do |t|
          Task.new(self, t)
        end
      end
    end

  end
end
