class TestController < ApplicationController
	before_filter :login_required
	
    def create_exchange
        exchange = Exchange.find(9)
        email = ExchangeMailer.create_notify(exchange)
        render(:text => "<pre>" + email.encoded + "</pre>")
    end
    
    def complete_exchange
        exchange = Exchange.find(9)
        email = ExchangeMailer.create_complete(exchange)
        render (:text => "<pre>" + email.encoded + "</pre>")
    end
end