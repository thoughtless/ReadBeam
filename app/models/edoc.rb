class Edoc < ActiveRecord::Base
  require 'source_mixin'
  include SourceMixin

  belongs_to :owner, :class_name => 'User', :inverse_of => :edocs, :foreign_key => :owner_id
  belongs_to :source

  attr_accessible :title, :description, :schedule, :tmp_recipe, :timezone, :language, :source_id,
    :conversion, :website, :format, :device, :recipe_name, :is_mailed, :computime, :requires_login

  attr_accessible :title, :description, :schedule, :tmp_recipe, :timezone, :username, :requires_login,
    :conversion, :website, :format, :device, :recipe_name, :language, :has_private_recipe,
    :is_approved, :file_name, :comment, :source_id, :is_mailed, :has_error, :owner_id,
    :as => :admin

  before_create :derive_format
  before_create :init_edoc_with_private_recipe, :if => :has_private_recipe?
  before_create :init_edoc_with_public_recipe, :unless => :has_private_recipe?

  validates :title, :length => { :in => 3..60 }
  validates :timezone, :schedule, :device, :presence => true
  validates :conversion, :length => { :in => 5..125 }, :presence => true, :if => :requires_login?

  # Either have a tmp_recipe or a recipe_name
  #validates :tmp_recipe, :presence => true, :unless => :recipe_name
  #validates :recipe_name, :presence => true, :unless => :tmp_recipe

  def init_timestamps
    self.next_run = Time.now.utc.to_i
  end

  def init_edoc_with_private_recipe
    init_timestamps
    # A lot of initialization is handled in tmp_recipe
  end
  
  def init_edoc_with_public_recipe
    init_timestamps
    
    self.is_approved = true
    self.has_private_recipe = false

    self.file_name = Digest::MD5.hexdigest(self.recipe + self.conversion).force_encoding('UTF-8')
  end

  def set_next_run_to_now
    self.update_attribute(:next_run, Time.now.utc.to_i)
  end

  def set_next_run_to_schedule
    self.update_attribute(:next_run, self.next_run_timestamp)
  end

  # This setter is fed an ActionDispatch::Http::UploadedFile object
  # List of attributes that may not be used in _form when empty:
  # recipe_name
  # file_name
  # Also check edoc controller, mass_assignment method which is called
  # to avoid this problem on :create and :update
  def tmp_recipe=(uploaded_file)
    Rails.logger.debug("Edoc#tmp_recipe: File #{uploaded_file.path} with size #{uploaded_file.size} has been uploaded.")
    if (256..262144) === uploaded_file.size
      tmp_recipe = uploaded_file.read.force_encoding('UTF-8')

      self.is_approved = false
      self.has_private_recipe = true

      self.recipe_name = Digest::MD5.hexdigest(tmp_recipe + self.conversion).force_encoding('UTF-8')
      self.file_name = self.recipe_name

      File.open(self.recipe_url, 'w') { |f| f.write tmp_recipe }
      Rails.logger.info("Edoc#tmp_recipe: Recipe '#{uploaded_file.original_filename}' has been saved as '#{self.recipe_url}'")      
    end
  end

  def file_url
    EDOC_PATH + self.file_name + '.' + self.format
  end

  def recipe_url
    RECIPE_PATH + (self.has_private_recipe? ? 'private/' : 'public/') + self.recipe_name + '.recipe'
  end

  def log_url
    EDOC_PATH + self.file_name + '.' + self.format + '.log'
  end

  def content_type
    MIME_TYPE[self.format]
  end

  def file_handle
    self.file_name + '.' + self.format
  end

  def is_downloadable
    File.exists?(self.file_url)
  end

  def file_is_fresh
    # If either file does not exist or when too old -> nil/false
    if File.exists?(self.file_url)
      (Time.now.to_i - File.mtime(self.file_url).to_i) < 6.hours
      #File.mtime(self.file_url).to_i > self.next_run
    end
  end

  def log=(log)
    File.open(self.log_url, 'w') { |f| f.write log }
    Rails.logger.info("Edoc#log: Log has been saved as '#{self.log_url}'")      
  end

  def last_run
    File.mtime(self.file_url).utc if File.exists?(self.file_url)
  end

  def log
    File.open(log_url, 'r') { |f| f.read } if File.exists?(self.log_url)
  end

  def convert
    if self.file_is_fresh
      Rails.logger.info("Edoc#convert: Skipped conversion, file '#{self.file_url}' is less than 6h old.")
      self.update_attribute(:computime, 0)
    else
      edoc_params = "#{self.recipe_url} #{self.file_url} --title \"#{self.title}\" --output-profile #{self.device} --dont-download-recipe --book-producer \"ReadBeam.com\" --authors \"ReadBeam\"  #{self.conversion}"

      Rails.logger.info("Edoc#convert: ebook-convert #{edoc_params}")

      start_time = Time.now.to_i
      %x{ebook-convert #{edoc_params} > #{self.log_url} 2>&1}
      finish_time = Time.now.to_i

      computime = finish_time - start_time
      self.owner.update_attribute(:computime, (self.owner.computime + computime))
      self.update_attribute(:computime, computime)

      if self.log && self.log.length < 50
        handle_conversion_error("Edoc#convert: Error - log is too short.")
      elsif !File.exists?(self.file_url)
        handle_conversion_error("Edoc#convert: Error - eDoc does not exist after conversion.")
      elsif File.size(self.file_url) > 16.megabytes #(20 MB)
        handle_conversion_error("Edoc#convert: Error - eDoc ist bigger than 20MB.")
      elsif self.computime < 1.second
        handle_conversion_error("Edoc#convert: Error - eDoc conversion took way too short.")
      elsif self.computime > 30.minutes
        handle_conversion_error("Edoc#convert: Error - eDoc conversion took way too long.") 
      end
    end
  end
  
  private
  
  def handle_conversion_error(error_msg)
    Rails.logger.error(error_msg)
    self.log = self.log + error_msg
    self.update_attribute(:has_error, true)
  end
  
  def derive_format
    case self.device
    when 'kindle', 'kindle_dx' then self.format = 'mobi'
    else self.format = 'epub'
    end
  end
end