class UserMailer < ActionMailer::Base
  default :from => 'out@readbeam.com', 'X-SMTPAPI' => '{"category":"read_beam"}'

  def send_edoc(edoc)
    if File.exist?(edoc.file_url)
      Rails.logger.info("UserMailer#send_edoc: File #{edoc.file_url} is available. Mailing now to '#{edoc.owner.distribution_email}' as #{edoc.title}.#{edoc.format}.")

      attachments["#{edoc.title}.#{edoc.format}"] = {
        :mime_type => Edoc::MIME_TYPE[edoc.format],
        :content => File.read(edoc.file_url)
      }

      mail(:to => edoc.owner.distribution_email,
        :subject => "ReadBeam: #{edoc.title} is here")
        #:from => mail_hash[:account_email])
    else
      Rails.logger.error("UserMailer#send_one_edoc: File #{edoc.file_url} for eDoc #{edoc.id} is missing. Refresh is scheduled.")
      edoc.set_next_run_to_now
    end
  end
end