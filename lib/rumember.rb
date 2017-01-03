class Rumember

  class Error < RuntimeError
  end

  class ResponseError < Error
    attr_accessor :code
  end

  API_KEY = '36f62f69fba7135e8049adbe307ff9ba'
  SHARED_SECRET = '0c33513097c09be4'
  API_VERSION = '2'

  module Dispatcher

    def dispatch(method, params = {})
      parent.dispatch(method, self.params.merge(params))
    end

    def transaction_dispatch(*args)
      response = dispatch(*args)
      yield response if block_given?
      Transaction.new(self, response)
    end

    def lists
      dispatch('lists.getList')['lists']['list'].map do |list|
        List.new(self, list)
      end
    end

    def locations
      dispatch('locations.getList')['locations']['location'].map do |list|
        Location.new(self, list)
      end
    end

  end

  def self.run(argv)
    if argv.empty?
      puts "Logged in as #{account.username}"
    else
      account.smart_add(argv.join(' '))
    end
  rescue Error
    $stderr.puts "#$!"
    exit 1
  rescue Interrupt
    $stderr.puts "Interrupted!"
    exit 130
  end

  attr_reader :api_key, :shared_secret, :api_version

  def initialize(api_key = API_KEY, shared_secret = SHARED_SECRET, api_version = API_VERSION)
    @api_key = api_key
    @shared_secret = shared_secret
    @api_version = api_version
  end

  def api_sig(params)
    require 'digest/md5'
    Digest::MD5.hexdigest(
      shared_secret + params.sort_by {|k,v| k.to_s}.join
    )
  end

  def sign(params)
    params = params.merge('api_key' => api_key)
    params.update('api_sig' => api_sig(params))
  end

  def params(params)
    require 'cgi'
    sign(params).map do |k,v|
      "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
    end.join('&')
  end

  def auth_url(perms = :delete, extra = {})
    "https://rememberthemilk.com/services/auth?" +
      params({'perms' => perms}.merge(extra))
  end

  def authenticate
    require 'launchy'
    frob = dispatch('auth.getFrob')['frob']
    Launchy.open(auth_url(:delete, 'frob' => frob))
    first = true
    puts 'Press enter when authentication is complete'
    $stdin.gets
    dispatch('auth.getToken', 'frob' => frob)['auth']
  end

  def reconfigure
    token = authenticate['token']
    File.open(self.class.config_file,'w') do |f|
      f.puts "auth_token: #{token}"
    end
  end

  def self.config_file
    File.expand_path('~/.rtm.yml')
  end

  def account(auth_token = nil)
    if auth_token
      Account.new(self, auth_token)
    else
      require 'yaml'
      @account ||=
        begin
          reconfigure unless File.exist?(self.class.config_file)
          t = YAML.load(File.read(self.class.config_file))['auth_token']
          account(t)
        end
    end
  end

  alias autoconfigure account

  def self.account
    @account ||= new.account
  end

  def url(params)
    "https://api.rememberthemilk.com/services/rest?#{params(params)}"
  end

  def dispatch(method, params = {})
    require 'json'
    require 'open-uri'
    raw = open(url(params.merge('method' => "rtm.#{method}", 'format' => 'json'))).read
    rsp = JSON.parse(raw)['rsp']
    case rsp['stat']
    when 'fail'
      error = ResponseError.new(rsp['err']['msg'])
      error.code = rsp['err']['code']
      error.set_backtrace caller
      raise error
    when 'ok'
      rsp.delete('stat')
      rsp
    else
      raise ResponseError.new(rsp.inspect)
    end
  end

  autoload :Abstract, 'rumember/abstract'
  autoload :Account, 'rumember/account'
  autoload :Timeline, 'rumember/timeline'
  autoload :Transaction, 'rumember/transaction'
  autoload :List, 'rumember/list'
  autoload :Location, 'rumember/location'
  autoload :Task, 'rumember/task'

end
