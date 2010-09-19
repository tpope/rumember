class Rumember
  class Timeline

    include Dispatcher
    attr_reader :id, :parent

    def initialize(parent, id = nil)
      @parent = parent
      @id = (id || parent.dispatch('timelines.create').fetch('timeline')).to_i
    end

    def params
      {'timeline' => id}
    end

    def smart_add(name)
      dispatch('tasks.add', 'parse' => 1, 'name' => name)
    end
  end
end
