class DeviseMailer < Devise::Mailer
  def headers_for(action)
    headers = {
     :subject       => translate(devise_mapping, action),
     :from          => 'tom@readbeam.com', 'X-SMTPAPI' => '{"category":"read_beam"}',
     :to            => resource.account_email,
     :template_path => template_paths
  }
  end
end