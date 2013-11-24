

class UsersController < ApplicationController
	before_filter :login_required
	

  def edit
	#print "\n\n\n***#{session[:user_id]}***\n\n\n"
	#@user = User.find(session[:user_id]	)
	@user = current_user
  end
  
  def update
  
	#print "\n\n***********#{params[:user][:id]}**********\n\n"
    if params[:commit].eql?('Cancel')
        redirect_to :controller => :welcome
    else
    	user = current_user
    	if user.update_attributes(params[:user])
    		flash[:notice] = 'Your updates were saved'
    		redirect_to :controller => :welcome
    	else
    		flash[:notice] = 'Your changes could not be saved'
    		render :action => :edit
    	end
    end
  end
end
