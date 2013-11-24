module ListingsHelper
    
    

    #helper methods to get all colors, types, patterns or themes
    #these are used to populate the select objects when creating
    #or editing a new listing
	def getColors
		c = Color.find(:all, :order => "color_group")        
	end
	
	def getTypes
		s = Fabric.find(:all, :order=>"fabric_type")
		#@locations.unshift(Location.new(:name => "--- to be set ---"))
		s.unshift(Fabric.new(:fabric_type=>"-unknown-", :id=>99))
		s
	end
    
	def getPatterns
		s = Pattern.find(:all, :order=>"pattern_type")
		s.unshift(Pattern.new(:pattern_type=>"-none-", :id=>99))
		s
	end
	
	def getThemes
		s=Theme.find(:all, :order=>"name")
		s.unshift(Theme.new(:name=>"-none-", :id=>99))
		s
	end
    
    def getBlocks
       s = BlockPattern.find(:all, :order=>"name_of_pattern")
       s.unshift(BlockPattern.new(:name_of_pattern => "-unknown-", :id=>99))
       s
    end
    #===========================================================
    #Methods to get the colors, themes, patterns or fabrics for the index action
    
    def getStr(listing, choice)
        #print "\n\n****#{choice}  #{@PATTERN}***\n\n\n"
        obj = case choice
                when @PATTERN: listing.patterns
                when @THEME: listing.themes
                when @FABRIC: listing.fabrics
                when @COLOR: listing.colors
               end
        #print "\n\n****#{obj}***\n\n\n"
         if obj.size > 0
            str = String.new
            obj.inject(str) do |memo, o| memo << 
                case choice
                    when @PATTERN: o.pattern_type
                    when @THEME: o.name
                    when @FABRIC: o.fabric_type
                    when @COLOR: o.name
                 end
                 memo << ", " 
             end #inject
          str.rstrip!.chomp!(',')
          str
        else
            "-unspecified-"
        end #if
    end
    
   #method to get the image for a particular listing
   def getImage(listing)
    #print"\n\n\n***#{listing.id}***\n\n\n"
    @listing_image_arr = ListingImage.find(:all, :conditions => ["listing_id = ?", listing.id], :limit=> 1)
    if @listing_image_arr.size > 0
        @listing_image = @listing_image_arr[0]
        send_data(@listing_image.data,
                    :filename => @listing_image.name,
                    :type => @listing_image.content_type,
                    :disposition => "inline")
	
    end
   end
   
   #this method is used when we are creating the browse listing.  If the
   #listing is an offer, we go calculate the rating for the provider.
   #will render a number of spools for that rating.
   #pre-condition: listing is an offer
   def getProviderRating(pid)
		#find all exchanges where this pid is the provider id rating
		exchanges = Exchange.find(:all, :conditions => ["provider_id = ?", pid])
		#next find all ratings for these exchanges
		ratings = exchanges.inject([]){|memo, e| memo << Rating.find(:all, :conditions => ["rateable_id = ?", e.id])}
		ratings.flatten!
		if ratings.size > 0
			sum = ratings.inject(0){|memo, r| memo + r.rating}
			avg = (sum.to_f)/((ratings.size).to_f)
		end
   end
    
   
end
