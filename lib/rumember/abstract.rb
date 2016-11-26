class Rumember
  class Abstract

    include Dispatcher
    attr_reader :parent

    def initialize(parent, attributes)
      @parent = parent
      @attributes = attributes
    end

    def params
      {}
    end

    def self.reader(*methods, &block)
      methods.each do |method|
        define_method(method) do
          value = @attributes[method.to_s]
          if block && !value.nil?
            yield value
          else
            value
          end
        end
      end
    end

    def self.integer_reader(*methods)
      reader(*methods) do |value|
        Integer(value) unless value.kind_of?(String) && value.empty?
      end
    end

    def self.boolean_reader(*methods)
      reader(*methods) do |value|
        value == '1' ? true : false
      end
      methods.each do |method|
        alias_method "#{method}?", method
      end
    end

    def self.time_reader(*methods)
      reader(*methods) do |value|
        Time.parse(value) unless value.empty?
      end
    end

  end
end
