require File.dirname(__FILE__) + '/../test_helper'
require 'exchanges_controller'

# Re-raise errors caught by the controller.
class ExchangesController; def rescue_action(e) raise e end; end

class ExchangesControllerTest < Test::Unit::TestCase
  def setup
    @controller = ExchangesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
