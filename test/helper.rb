require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :test)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require "minitest/autorun"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', "app" , "main",'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'test'))

require "salama"
require "interpreter"
