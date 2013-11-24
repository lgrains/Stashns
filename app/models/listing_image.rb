class ListingImage < ActiveRecord::Base
    belongs_to :listing
    
    def validate
        if (content_type =~ /bmp/)
            errors.add(:image, '-- sorry, no .bmp\'s.')
        end
        if (data && data.length != 0 && ( ! (content_type =~ /^image/) ))
            errors.add(:image, '-- Only .jpg, .gif, .png, etc. may be
            uploaded as a picture.')
        end
        if (data && data.length > 409600)
            errors.add(:image, '-- that image file is too big!')
        end
    end

                        
    def uploaded_picture=(picture_field)
        if picture_field.size > 0
            self.name = base_part_of(picture_field.original_filename)
            self.content_type = picture_field.content_type.chomp
            self.data = picture_field.read
            self.original_filename = picture_field.original_filename
        end
    end
    
    def base_part_of(file_name)
        File.basename(file_name).gsub(/[^\w._-]/, '')
    end
    
end
