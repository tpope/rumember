class Rumember
  class Note < Abstract
    integer_reader :id
    time_reader :created, :modified
    reader :title

    def text
      @attributes['$t']
    end
  end
end
