# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_qstash_session_id'
  include AuthenticatedSystem
  
  #before_filter :authorize, :except => ['login', 'logout', 'welcome']
  before_filter :login_from_cookie
  

end
