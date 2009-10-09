require 'rubygems'
begin
  require 'spec'
rescue LoadError
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__) + '/../jibernate-libs')

require 'java'
require 'hibernate'
#require 'mocha'

# Spec::Runner.configure do |config|
#   config.mock_with :mocha
# end
