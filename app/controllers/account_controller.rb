class AccountController < ApplicationController
 
	before_filter :login_required, :only => [ :change_password]


  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
	if logged_in? 
		redirect_to(:controller => 'welcome')
	end
  end

  def login
    return unless request.post?
	@login = params[:login]
    self.current_user = User.authenticate(params[:login], params[:password])
	if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => 'welcome')
      flash[:notice] = "Logged in successfully"
	
    end

  end

  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default(:action => 'welcome')
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => 'account', :action => 'login')
  end
  
  def activate
	@user = User.find_by_activation_code(params[:id])
	if @user and @user.activate
		self.current_user = @user
		flash[:notice] = "Your account has been activated."
	end
	redirect_back_or_default(:controller => 'account', :action => 'login')
  end
  
  def forgot_password
    return unless request.post?
    if @user = User.find_by_email(params[:email])
      @user.forgot_password
      @user.save
      redirect_back_or_default(:controller => 'account', :action => 'login')
      flash[:notice] = "A password reset link has been sent to your email address" 
    else
      flash[:notice] = "Could not find a user with that email address" 
    end
  end

 
  def reset_password
    password_reset_code = request.post? ? params[:password_reset_code] : params[:id]
    return if password_reset_code.blank?
    if @user = User.find_by_password_reset_code(password_reset_code)
      self.current_user = @user
      redirect_to(:action => 'change_password')
    else
      logger.error "Invalid Password Reset Code entered." 
      flash[:notice] = "Invalid Password Reset Code entered. Please check your Code and try again." 
    end
  end

  def change_password
    return unless request.post?
    if (params[:password] == params[:password_confirmation])
      current_user.password_confirmation = params[:password_confirmation]
      current_user.password = params[:password]
      current_user.reset_password
      flash[:notice] = current_user.save ? "Password reset" : "Password not reset" 
      redirect_back_or_default(:controller => 'welcome')
    else
      flash[:notice] = "Password mismatch" 
    end  
  end

end
