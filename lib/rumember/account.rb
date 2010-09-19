class Rumember
  class Account

    include Dispatcher
    attr_reader :auth_token

    def initialize(interface, auth_token)
      @interface = interface
      @auth_token = auth_token
    end

    def parent
      @interface
    end

    def params
      {'auth_token' => auth_token}
    end

    def new_timeline
      Timeline.new(self)
    end

    def timeline
      @timeline ||= new_timeline
    end

    def smart_add(name)
      timeline.smart_add(name)
    end

    def username
      @username ||= dispatch('auth.checkToken')['auth']['user']['username']
    end

    def inspect
      "#<#{self.class.inspect}: #{username}>"
    end

  end
end
