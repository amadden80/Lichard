require 'test/unit'
require_relative 'lib/Lichard'

class Application < Lichard
  get '/testing_request_methods' do
    'get'
  end
  post '/testing_request_methods' do
    'post'
  end
  put '/testing_request_methods' do
    'put'
  end
  delete '/testing_request_methods' do
    'delete'
  end
  patch '/testing_request_methods' do
    'patch'
  end
end

class Test_Lichard < Test::Unit::TestCase

  def setup
    @app = Application.new
    puts 'Testing'
  end

  def test_methods_responds_with_different_block
    [:get, :post, :patch, :delete, :put].each do |method|
      response = @app.router.process(method, '/testing_request_methods')
      message = method.to_s + ' request does not get evalute get block'
      assert((response==method.to_s), message)
    end
  end

end
