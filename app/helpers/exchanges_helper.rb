module ExchangesHelper

	#return the owner of the listing involved in the exchange
	def getOwner(exchange)
		listing = Listing.find(exchange.listing_id)
		User.find(listing.user_id)
		
	end
   
end
