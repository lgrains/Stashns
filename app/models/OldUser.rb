require 'digest/sha1'

class OldUser < ActiveRecord::Base

	validates_presence_of :email
	validates_uniqueness_of :email
	
	
	
	has_many :listings
	has_many :exchanges
	
	def to_s
	    s = email
	    if (first_name || last_name)
	      s = "#{first_name} #{last_name}".strip + ' <' + s + '>'
	    end
	    s
	end
	  
	def member_since
		created_at.strftime("Member Since %B, %Y")
	end
	
	def validate
		errors.add_to_base("Missing password") if hashed_password.blank?
	end
	
	def self.authenticate(email, password)
		user = self.find_by_email(email)
		if user
			expected_password = encrypted_password(password, user.salt)
			if user.hashed_password != expected_password
				user=nil
			end
		end
		user
	end
	
	def password
		@password
	end
	
	def password-(pwd)
		@password = pwd
		return if pwd.blank?
		create_new_salt
		self.hashed_password = User.encrypted_password(self.password, self.salt)
	end
	
	private
	
	def self.encrypted_password(password, salt)
		string_to_hash = password + "joebob" + salt
		Digest::SHA1.hexdigest(string_to_hash)
	end
	
	def create_new_salt
		self.salt = self.object_id.to_s + rand.to_s
	end
  
  
end
