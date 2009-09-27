module ActionMailer
  class Base
    
    default_url_options[:host] = Rails.env.development? ? 'dev.757studio.com' : '757studio.com'
    
    
  end
end
