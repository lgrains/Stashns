class ExchangesController < ApplicationController
	before_filter :login_required
    def index
        list
    end
    
    def list
        @user = current_user
        @open_exchanges = Exchange.find(:all, 
            :conditions=> ["(provider_id = ? or recipient_id = ?) and status = 'open'", @user, @user])
        #@oe_recip = @open_exchanges.collect{|o| User.find(o.recipient_id)}
        #print "\n\n\n***#{@oe_recip}***\n\n\n"
         @closed_exchanges = Exchange.find(:all, 
            :conditions=> ["(provider_id = ? or recipient_id = ?) and status = 'complete'", @user, @user])
        @header_type = "Exchanges for #{@user.first_name} #{@user.last_name}"
        
        render :action => :list
    end
    
    def new
        @listing = Listing.find(params[:id])
        @user = current_user
        @owner = User.find(@listing.user_id)
        @exchange = Exchange.new
    
    end
    
    def create
        if params[:commit].eql?('Cancel')
            redirect_to :controller => :listings, :action => :view, :id => params[:id]
        else
            #the button pushed was submit - create the new exchange
            @listing = Listing.find(params[:id])
            @user = current_user
            @owner = User.find(@listing.user_id)
            
            @exchange = Exchange.new(params[:exchange])
            @exchange.status = "open"
            @exchange.listing_id = @listing.id
			@exchange.cost = @listing.cost_of_exchange
            #print "\n\n\n***#{@user.first_name}***\n\n\n"
            if @listing.listing_type.downcase.eql?('request')
                @exchange.provider_id = @user.id
                @exchange.recipient_id = @owner.id
            else    #it's an offer
                @exchange.provider_id = @owner.id
                @exchange.recipient_id = @user.id            
            end
        
            #the status of @listing needs to be updated to 'in_exchange'
            @listing.status = "in_exchange"
            
            #wrap the saves and updates in a transaction - if one fails they all need to fail
            
            Exchange.transaction do
                #update the listing
                @listing.update_attributes!(params[:listing])
                @exchange.save! 
            end #transaction
             #send the email to the owner and user both
             #print "\n\n\n***#{@exchange.id}***\n\n\n"
            ExchangeMailer.deliver_notify(@exchange)
            
            redirect_to :controller => :welcome
        end
		
    
    end
    
    def view
        #when a member needs to view and accept an exchange
        @exchange = Exchange.find(params[:id])
        @provider = User.find(@exchange.provider_id)
        @recipient = User.find(@exchange.recipient_id)
        @listing = Listing.find(@exchange.listing_id)
        @user = current_user
        @owner = User.find(@listing.user_id)
    end
    
    def accept
         if params[:commit].eql?('Not Yet')
            redirect_to :controller => :listings, :action => :view, :id => Exchange.find(params[:id]).listing_id
         elsif params[:commit].eql?('Back')
			redirect_to :action => :list
		 else
            exchange = Exchange.find(params[:id])
			#print "\n\n\n***96-#{exchange.listing_id}***\n\n\n"
             listing = Listing.find(exchange.listing_id)
            listing.status = "complete"
            exchange.status = "complete"
            
            Exchange.transaction do
                #update the listing
                listing.update_attributes!(params[:listing])
                                
                #save the exchange
                exchange.update_attributes!(params[:exchange]) 
               
            end #transaction
            
            ExchangeMailer.deliver_complete(exchange)
            
            redirect_to :controller => :welcome
            
         end    #if params
        
    end
    
    def ratings
        #called when clicking on one of the pink spools to give a rating. 
        #the params[:id] is the exchange.listing_id and the params[:format] is the 
        #rating.
        
        exchange = Exchange.find(params[:id])
        rating = params[:format]
        exchange.rating = rating
        
        exchange.save!   #what if it doesn't save??
        
        render :partial => "shared/spool_display", :layout => false, :locals => {:num => rating.to_i}
        
    end
end
