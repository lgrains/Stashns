class ListingImagesController < ApplicationController
	before_filter :login_required
  def index
    @listing_images = ListingImage.find(:all, :conditions => 'parent_id is null')
  end

  def new
    @listing_image = ListingImage.new
  end

  def show
    @listing_image = ListingImage.find(params[:id])
  end

  def create
    @listing_image = ListingImage.create! params[:listing_image]
    redirect_to :action => 'show', :id = @listing_image
   rescue ActiveRecord::RecordInvalid
    render :action => 'new'  
  end
end
