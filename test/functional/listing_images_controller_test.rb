require File.dirname(__FILE__) + '/../test_helper'
require 'listing_images_controller'

# Re-raise errors caught by the controller.
class ListingImagesController; def rescue_action(e) raise e end; end

class ListingImagesControllerTest < Test::Unit::TestCase
  def setup
    @controller = ListingImagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
