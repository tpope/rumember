class Rumember
  class Task < Abstract
    integer_reader :id, :location_id, :parent_task_id
    time_reader :created, :modified
    reader :name, :source, :url
    alias taskseries_id id

    def task_id
      Integer(@attributes['task']['id'])
    end

    def completed?
      !(@attributes['task']['completed'].empty?)
    end

    def deleted?
      !(@attributes['task']['completed'].empty?)
    end

    def postponed
      Integer(@attributes['task']['postponed'])
    end

    def priority
      @attributes['task']['priority'] == "N" ? 0 : Integer(@attributes['task']['priority'])
    end

    def tags
      if @attributes['tags'].empty?
        []
      else
        Array(@attributes['tags']['tag'])
      end
    end

    def params
      {'taskseries_id' => taskseries_id, 'task_id' => task_id}
    end

    def transaction_dispatch(*args)
      super(*args) do |response|
        @attributes = response['list']['taskseries']
      end
    end

    def delete
      transaction_dispatch('tasks.delete')
    end

    def complete
      transaction_dispatch('tasks.complete')
    end

    def uncomplete
      transaction_dispatch('tasks.uncomplete')
    end

    def postpone
      transaction_dispatch('tasks.postpone')
    end

    def add_tags(tags)
      transaction_dispatch('tasks.addTags', 'tags' => tags)
    end

    def remove_tags(tags)
      transaction_dispatch('tasks.removeTags', 'tags' => tags)
    end

    def raise_priority
      transaction_dispatch('tasks.movePriority', 'direction' => 'up')
    end

    def lower_priority
      transaction_dispatch('tasks.movePriority', 'direction' => 'down')
    end

    def move_to(list)
      transaction_dispatch(
        'tasks.moveTo',
        'from_list_id' => parent.id,
        'to_list_id' => list.id
      ).tap do
        @parent = list
      end
    end

    %w(Estimate Name Priority Recurrence URL).each do |attr|
      define_method("set_#{attr.downcase}") do |value|
        transaction_dispatch("tasks.set#{attr}", attr.downcase => value)
      end
      alias_method "#{attr.downcase}=", "set_#{attr.downcase}"
    end

    def set_tags(tags)
      transaction_dispatch('tasks.setTags', 'tags' => Array(tags).join(' '))
    end
    alias tags= set_tags

    def set_due_date(url)
      transaction_dispatch('tasks.setDueDate', 'url' => url)
    end
    alias due_date= set_due_date

    def set_location(id)
      id = id.location_id if id.respond_to?(:location_id)
      transaction_dispatch('tasks.setLocation', id)
    end
    alias location= set_location

  end
end
