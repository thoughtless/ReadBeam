# first try and show proper usage if arguments aren't well-formed:
def usage
  abort "usage: rails runner -e production scripts/#{__FILE__} -- [options]"
end

# not using rails runner worker.rb?
usage unless Object.const_defined?(:Rails)

due_edocs = Edoc.where("next_run < ? AND has_error IS NOT ? AND is_approved IS ?", Time.now.utc.to_i, true, true).limit(5)

Rails.logger.info( "Worker: Found #{due_edocs.count} edocs to check.")

# First run to mark found eDocs as worked on
due_edocs.each do |edoc|
  edoc.set_next_run_to_schedule
end

# Second run to convert eDocs
due_edocs.each do |edoc|
  Rails.logger.info( "Worker: About to convert #{edoc.id}.")
  puts "Worker: About to convert #{edoc.id}."
  edoc.convert
  if edoc.has_error?
    Rails.logger.error( "Worker: #{edoc.title} for #{edoc.owner.account_email} has error. Please check manually.")
    puts "Worker: #{edoc.title} for #{edoc.owner.account_email} has error. Please check manually."
  else
    UserMailer.send_edoc(edoc).deliver if edoc.is_mailed?
    Rails.logger.debug( "Worker: #{edoc.title} for #{edoc.owner.account_email} converted without error.")
  end
end

puts "Worker: #{due_edocs.size} edocs have been checked."