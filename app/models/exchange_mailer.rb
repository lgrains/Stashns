class ExchangeMailer < ActionMailer::Base

  def notify(exchange)
    listing = Listing.find(exchange.listing_id)
    listing_type = listing.listing_type
    if listing_type.eql?('request')
        filler = User.find(exchange.provider_id)
        owner = User.find(exchange.recipient_id)
    else
        owner = User.find(exchange.provider_id)
        filler = User.find(exchange.recipient_id)
    end
    @subject    = 'Stash-n-Share Exchange Notification'
    @body["exchange"] = exchange
    @body["filler"] = filler
    @body["owner"] = owner
    @body["listing_type"] = listing_type
    @body["exchange_id"] = exchange.id
    @recipients = ["#{owner.email}", "#{filler.email}"]
    @from       = 'exchanges@Stash-n-Share.com'
    @sent_on    = Time.now
    @headers    = {}
  end

  def complete(exchange)
    listing = Listing.find(exchange.listing_id)
    listing_type = listing.listing_type
    if listing_type.eql?('request')
        filler = User.find(exchange.provider_id)
        owner = User.find(exchange.recipient_id)
    else
        owner = User.find(exchange.provider_id)
        filler = User.find(exchange.recipient_id)
    end
    @subject    = 'Stash-n-Share - Your Exchange is Complete!'
    @body["exchange"] = exchange
    @body["filler"] = filler
    @body["owner"] = owner
    @body["listing_type"] = listing_type
    @body["exchange_id"] = exchange.id
    @recipients = ["#{owner.email}", "#{filler.email}"]
    @from       = 'exchanges@Stash-n-Share.com'
    @sent_on    = Time.now
    @headers    = {}
  end
end
