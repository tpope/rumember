class Rumember
  class Location < Abstract
    integer_reader :id, :zoom
    reader :name, :address
    boolean_reader :viewable
    reader :latitude, :longitude do |l|
      Float(l)
    end
    alias to_s name
  end
end
