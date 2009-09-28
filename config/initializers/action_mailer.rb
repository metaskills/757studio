module ActionMailer
  class Base
    
    default_url_options[:host] = Rails.env.development? ? 'dev.757studio.org' : '757studio.org'
    
    
  end
end
