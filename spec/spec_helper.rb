$LOAD_PATH.unshift(File.join(File.dirname(File.dirname(__FILE__)),'lib'))
require 'rumember'
begin; require 'rubygems'; rescue LoadError; end
require 'rspec'

RSpec.configure do |config|
end
