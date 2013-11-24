# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def logged_in?
		session[:user_id]
	end
	
    def findImageID(listing)
        #print "\n\n\n***app_helper line 8 #{listing.id}***\n\n\n"
        @listing_image_arr = ListingImage.find(:all, :conditions => ["listing_id = ?", listing.id])
        #return the id if it's found
        if @listing_image_arr.size > 0  #there should only be one under the precondition
            @listing_image_arr[0].id
        else
            -1
        end
   end
	 
end
