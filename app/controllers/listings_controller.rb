require 'tempfile'

class ListingsController < ApplicationController

	before_filter :login_required
   

	def index	
		list
	end

	def list
        @user = current_user
        @listings = Listing.find(:all, :conditions=> ["user_id = ?", @user.id], :order => :type)
        @header_type = "Listings for #{@user.first_name} #{@user.last_name}"
        
        render :action => :list
	end
	
	
	
	def new
    #run before rendering new.rhtml
      @choice = params[:id].to_i    #:id is a string, needs to be converted to an integer
      #print "\n\n\n***22 #{params[:id]}, #{@choice}***\n\n\n"
      
        @listing = case params[:id]
            when "1": Yardage.new(params[:listing])
            when "2": Block.new(params[:listing])
            when "3": Kit.new(params[:listing])
            when "4": Magazine.new(params[:listing])
            when "5": QuiltTop.new(params[:listing])
            else print "\n\n\n***Illegal ID in listings#new #{@choice}***\n\n\n"
        end #case
        #print "\n\n\n***#{@listing.type}***\n\n\n"
		@listing.status = 'new'
        @picture = ListingImage.new
        @edit = false
        #these variables are quasi-constants from the tables to poplulate the check-box and select lists
        setConstArrays()
	end
	
	def create
		 if params[:commit].eql?('Cancel')
            redirect_to :controller => :listings, :action => :list
        else
	        #run after the submit button is pressed
	        #print "\n\n\n***#{params[:format]}***\n\n\n" #---- it's a string
	        @listing = case params[:id]
	                when "1": Yardage.new(params[:listing])
	                when "2": Block.new(params[:listing])
	                when "3": Kit.new(params[:listing])
	                when "4": Magazine.new(params[:listing])
	                when "5": QuiltTop.new(params[:listing])
	            end #case
	            
	        #@listing = Listing.new(params[:listing])
	        @listing.user_id = current_user.id
			@listing.status = 'new'
	        #now handle the listing_image
	        @listing_image = ListingImage.new(params[:listing_image])
	        @listing_image.listing_id = @listing.id   
	        # get the join class item - color   
	       if params[:colors] && params[:colors].size > 0
	            color_ids = params[:colors]
	            color_ids.each {|c| @listing.colors << Color.find(c) }
	       end
	       Listing.transaction do
	            
	            #print "\n\n\n***#{@listing.id}***\n\n\n"
	            @listing_image.listing = @listing
	            @listing.save!  
	            @listing_image.save!
	            redirect_to :action => :list
	             
	       end    #transaction
		end
       rescue ActiveRecord::RecordInvalid => e
            @listing_image.valid?
            #print "80 \n\n\n*** In rescue #{params[:id]}, #{choice}, #{tmp_id.to_s} *** \n\n\n"
            #render :action => :edit, :id => params[:id]
            @choice = params[:id]
            setConstArrays()
            render :action => :new, :id => params[:id]
	end
    
   #needed to display the correct listing image.  
   def listing_image
		
		@listing_image = ListingImage.find(params[:id])
		if @listing_image
			#print "\n\n\n  91#{@listing.id}***\n\n\n"
			send_data(@listing_image.data,
						:filename => @listing_image.name,
						:type => @listing_image.content_type,
						:disposition => "inline")
		# else
			# print "\n\n\n  97 ***\n\n\n"
			# @f = File.new("nopix.jpg")
			# send_data("nopix.jpg".data, 
					# :filename => "nopix.jpg", 
					# :type => "nopix.jpg".content_type, 
					# :disposition=>"inline")
	   end
	 end

	
	def edit
        @listing = Listing.find(params[:id])
        @choice = @listing.type
        @edit = true
        #these variables are quasi-constants from the tables to poplulate the check-box and select lists
        setConstArrays()
        
	end
	
	def update
    
        if params[:commit].eql?('Cancel')
            redirect_to :controller => :listings, :action => :list
        else
            @listing = Listing.find(params[:id])
            
            #remove all the colors then add the checked ones back in
            @colors = @listing.colors
            #print "\n\n\n***the listing's colors should be #{@colors}***\n\n\n"
            Listing.transaction do
               @colors.each{|c| @listing.colors.delete(Color.find(c))}
               
               #now add back the checked colors
               if params[:colors] && params[:colors].size > 0 
        			params[:colors].each{|c| @listing.colors << Color.find(c)}
        		end
                
                
                
                #if there is a new uploaded_picture listing_image[uploaded_picture] 
                # delete the old one and add in the new one
                unless params[:listing_image][:uploaded_picture].blank?
                    #print "\n\n\n***140 #{@listing.id} ***\n\n\n"
                    pix_to_delete = ListingImage.find(:all, 
                            :conditions => ["listing_id = ?", @listing.id])
                    #print "\n\n\n***142 #{pix_to_delete.size}***\n\n\n"
                    pix_to_delete.each{|e| e.destroy}
                    @listing_image = ListingImage.new(params[:listing_image])
                    #next line needs to be there so that the image's id gets updated
                    @listing_image.listing = @listing
                    @listing_image.save!  
                end
                #update_attributes! calls save! so an exception is raised if the record is invalid
                @listing.update_attributes!(params[:listing])
               redirect_to :controller => :welcome
            end #transaction     
        end #if cancel or submit
        rescue ActiveRecord::RecordInvalid => e
            @listing_image.valid?
            @edit = true
            @choice = @listing.type
            setConstArrays()
            render :action => :edit, :id => params[:id]
      
	end
    
    #1/8/08 modified to use the paginating_find plugin.  
    #This plugin uses the #find method, and adds a :page
    #option.  #find works the same as always without the
    #:page hash.  
    #Also had to modify browse.rhtml slightly (see comments at the 
    #top of that file
    def browse
        #@listings = Listing.find(:all, :order => "type")
        @user = current_user
        @listings = Listing.find(:all, 
                    :conditions => ["user_id != ? and status = 'new'",@user.id ],
                    :order => :type, 
                    :page => {:size => 4, :current => params[:page]})
        @header_type = "Browse All Listings"
       
        
    end
    
    def view
        @listing = Listing.find(params[:id])
        
    end
    
    def remove
        listing = Listing.find(params[:id])
        #remove colors
        
        colors = listing.colors
        colors.each{|c| listing.colors.delete(Color.find(c))}
        
        #delete the listing_image
        listing_image = ListingImage.find(:all, :conditions => ["listing_id = ?", listing.id])
        #get back an array, there should only be one element in it 
        if listing_image.length == 1
            listing_image[0].destroy
        end
        listing_image.each{|li| li.destroy}
        listing.destroy
        
        redirect_to :controller => :welcome
        
    end
	
	
    #params[:query] is a string, it may contain 1 or more words.  Break it up into an 
    #array of words.  Then for each word in the array, first surround it with %'s, i.e. %red%.
    #See if it is a color word.  If so, select all listings with that as one of the colors (use inner join)
    #if not a color word, do a concat() type search of themes, patterns, fabrics and the description field
    def search
        unless params[:query].blank?
            @listings = custom_search(params[:query])
            #print "\n\n\n***203 #{@listings}***\n\n\n"
            @header_type = "Search for \"" + params[:query] + "\""
        
            #will render search.rhtml by default
        else
            browse
        end
    end
    
    private
    
    def getColorGroupNames
        color_groups = Color.find(:all, :select => "color_group")
        color_groups.collect{|c| c.color_group}.uniq!
    end
    
    def makeColorHash(color_group_names)
        #need set of colors for each color group name
        color_hash = Hash.new
        for cg in color_group_names
            tmp_arr = Color.find(:all, :conditions => "color_group = '#{cg}'")
            color_hash["#{cg}"] = tmp_arr
        end
        color_hash
    end
    
    def getFabricsNew
        Fabric.find(:all, :order => "fabric_type")
    end
    
    def getFabricsEdit
        f = Fabric.find(:all, :order => "fabric_type")
        f.inject([]){|memo, f| memo << [f.fabric_type, f.id] }   
    end
    
    def getThemesNew
        Theme.find(:all, :order => "name")
    end
    
    def getThemesEdit
        f = Theme.find(:all, :order => "name")
        f.inject([]){|memo, f| memo << [f.name, f.id] }   
    end
    
    def getPatternsNew
        Pattern.find(:all, :order => "pattern_type")
    end
    
    def getPatternsEdit
        f = Pattern.find(:all, :order => "pattern_type")
        f.inject([]){|memo, f| memo << [f.pattern_type, f.id] }  
    end
    
    #params[:query] (cominginto params_list)  is a string, it may contain 1 or more words.  Break it up into an 
    #array of words.  Then for each word in the array, first surround it with %'s, i.e. %red%.
    #See if it is a color word.  If so, select all listings with that as one of the colors (use inner join)
    #if not a color word, first surround it with %'s, i.e. %red%..  
    #do a concat() type search of themes, patterns, fabrics and the description field
    def custom_search(params_list)
        search_terms = params_list
         #print "\n\n\n***#{search_terms.size}***\n\n\n"  ==> gives # of letters in the :query
         search_terms_array = search_terms.split(' ')
         
         ids = Array.new
         
         for word in search_terms_array
            word = word.singularize()
            isaColorWord = Color.find(:all, :conditions => ["name = ?", word])
            if isaColorWord.size > 0    #The size should only ever be 1
                ids.concat(Listing.connection.select_all("select distinct listings.id from listings
                    inner join colors_listings on listings.id = colors_listings.listing_id
                    where colors_listings.color_id = \'" + isaColorWord[0].id.to_s + "\'").map{|i| i['id'].to_i})
                
            else
                p_word = '%' + word + '%'
                temp_ids =  Listing.connection.select_all('select distinct listings.id 
                    from listings, fabrics, themes, patterns where 
                    listings.fabric_type = fabrics.id and 
                    listings.theme = themes.id and 
                    listings.pattern = patterns.id and 
                    concat(fabrics.fabric_type, \'////\', themes.name, 
                    \'////\', patterns.pattern_type, \'////\', listings.description) 
                    like \'' + p_word + '\'').map{|i| i['id'].to_i}
                if temp_ids.size > 0 
                    ids.concat(temp_ids)
                else
                    ids.concat(Listing.find(:all, :conditions => Listing.conditions_by_like(word)))
                end
            end
            
        end     #for
            
        ids
        Listing.find(ids)
        #print "\n\n\n***293 #{ids.size}***\n\n\n"
        
    end
    
    def setConstArrays
        @color_group_names = getColorGroupNames()
        @color_hash = makeColorHash(@color_group_names)
        @fabrics_new = getFabricsNew()
        @fabrics_edit = getFabricsEdit()
        @themes = getThemesNew()
        @themes_edit = getThemesEdit()
        @patterns = getPatternsNew()
        @patterns_edit = getPatternsEdit()
    end
    
    

end
