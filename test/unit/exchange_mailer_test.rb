require File.dirname(__FILE__) + '/../test_helper'

class ExchangeMailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
  end

  def test_notify
    @expected.subject = 'ExchangeMailer#notify'
    @expected.body    = read_fixture('notify')
    @expected.date    = Time.now

    assert_equal @expected.encoded, ExchangeMailer.create_notify(@expected.date).encoded
  end

  def test_complete
    @expected.subject = 'ExchangeMailer#complete'
    @expected.body    = read_fixture('complete')
    @expected.date    = Time.now

    assert_equal @expected.encoded, ExchangeMailer.create_complete(@expected.date).encoded
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/exchange_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
