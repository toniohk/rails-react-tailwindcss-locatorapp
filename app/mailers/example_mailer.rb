ActionMailer::Base.smtp_settings =
  { 
  	address:              'mail.rediscovermylife.org',
    port:                 465,
    domain:               'locator.rediscovermylife.org',
    user_name:            'locator@rediscovermylife.org',
    password:             'VBcent900!',
    authentication:       'login',
    :ssl                  => true,
    :openssl_verify_mode  => 'none'
  }
class ExampleMailer < ApplicationMailer
end

