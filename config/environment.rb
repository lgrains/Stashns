# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '1.2.3' unless defined? RAILS_GEM_VERSION
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION
# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

EMAIL_SMTP_HOST = 'smtp.gmail.com';
EMAIL_SMTP_PORT = 587;
EMAIL_IMAP_HOST = 'imap.gmail.com';
EMAIL_IMAP_PORT = 993;
EMAIL_USER      = 'stashns';
EMAIL_PASSWORD  = 'TopSecret';
EMAIL_FROM      = 'stashns@gmail.com';


Rails::Initializer.run do |config|

  config.action_mailer.smtp_settings = {
    :address        => EMAIL_SMTP_HOST,
    :port           => EMAIL_SMTP_PORT,
    :authentication => :plain,
    :user_name      => EMAIL_USER,
    :password       => EMAIL_PASSWORD
  }
  
  # Settings in config/environments/* take precedence over those specified here
 config.action_controller.session = { :key => "_qstash_session", :secret=> "i will go i will do the things the Lord commands"}
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.active_record.observers = :user_observer

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # Add new inflection rules using the following format
  # (all these examples are active by default):
  # Inflector.inflections do |inflect|
  #   inflect.plural /^(ox)$/i, '\1en'
  #   inflect.singular /^(ox)en/i, '\1'
  #   inflect.irregular 'person', 'people'
  #   inflect.uncountable %w( fish sheep )
  # end

  # See Rails::Configuration for more options
end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below




# The following adopts the technique from:
#     http://www.stephenchu.com/2006/06/how-to-use-gmail-smtp-server-to-send.html


require 'openssl'
require 'net/smtp'

Net::SMTP.class_eval do

private

def do_start(helodomain, user, secret, authtype)
 raise IOError, 'SMTP session already started' if @started
 check_auth_args user, secret, authtype if user or secret

 sock = timeout(@open_timeout) { TCPSocket.open(@address, @port) }
 @socket = Net::InternetMessageIO.new(sock)
 @socket.read_timeout = 60 #@read_timeout
 #@socket.debug_output = STDERR #@debug_output

 check_response(critical { recv_response() })
 do_helo(helodomain)

 if starttls
   raise 'openssl library not installed' unless defined?(OpenSSL)
   ssl = OpenSSL::SSL::SSLSocket.new(sock)
   ssl.sync_close = true
   ssl.connect
   @socket = Net::InternetMessageIO.new(ssl)
   @socket.read_timeout = 60 #@read_timeout
   #@socket.debug_output = STDERR #@debug_output
   do_helo(helodomain)
 end

 authenticate user, secret, authtype if user
 @started = true
ensure
 unless @started
   # authentication failed, cancel connection.
   @socket.close if not @started and @socket and not @socket.closed?
   @socket = nil
 end
end

def do_helo(helodomain)
  begin
   if @esmtp
     ehlo helodomain
   else
     helo helodomain
   end
 rescue Net::ProtocolError
   if @esmtp
     @esmtp = false
     @error_occured = false
     retry
   end
   raise
 end
end

def starttls
  getok('STARTTLS') rescue return false
  return true
end

def quit
  begin
    getok('QUIT')
    rescue EOFError, OpenSSL::SSL::SSLError
  end
end
end

