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
      dispatch('tasks.getList')['tasks']['list']['taskseries'].map do |ts|
        Task.new(self, ts)
      end
    end

  end
end
