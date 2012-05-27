module SourceMixin
  MORNING = '3.hours'

  SCHEDULE = {
    'morning' => {:nice => 'Every morning', :anchor => "beginning_of_day + #{MORNING}", :repeat => '1.day'},
    'noon' => {:nice => 'Every noon', :anchor => 'beginning_of_day + 12.hours', :repeat => '1.day'},
    'evening' => {:nice => 'Every evening', :anchor => 'beginning_of_day + 18.hours', :repeat => '1.day'},
    
    'monday_morning' => {:nice => 'Monday morning', :anchor => "beginning_of_week + #{MORNING}", :repeat => '1.week'},
    'tuesday_morning' => {:nice => 'Tuesday morning', :anchor => "beginning_of_week + 1.day + #{MORNING}", :repeat => '1.week'},
    'wednesday morning' => {:nice => 'Wednesday morning', :anchor => "beginning_of_week + 2.days + #{MORNING}", :repeat => '1.week'},
    'thursday_morning' => {:nice => 'Thursday morning', :anchor => "beginning_of_week + 3.days + #{MORNING}", :repeat => '1.week'},
    'friday_morning' => {:nice => 'Friday morning', :anchor => "beginning_of_week + 4.days + #{MORNING}", :repeat => '1.week'},
    'saturday_morning' => {:nice => 'Saturday morning', :anchor => "beginning_of_week + 5.days + #{MORNING}", :repeat => '1.week'},
    'sunday_morning' => {:nice => 'Sunday morning', :anchor => "beginning_of_week + 6.days + #{MORNING}", :repeat => '1.week'},
    
    'start_month' => {:nice => 'Beginning of month', :anchor => "beginning_of_month + #{MORNING}", :repeat => '1.month'},
    'end_month' => {:nice => 'End of month', :anchor => "end_of_month + #{MORNING}", :repeat => '1.month'}
  }

  TIMEZONE = {
    'Tijuana' => {:nice => 'America West'},
    'La Paz' => {:nice => 'America East'},
    'Berlin' => {:nice => 'Europe'},
    'Cairo' => {:nice => 'Africa'},
    'Kabul' => {:nice => 'Asia West'},
    'Hong Kong' => {:nice => 'Asia East'},
    'Sydney' => {:nice => 'Australia'},
  }

  DEVICE = {
    'default' => 'Other',
    'kindle' => 'Kindle',
    'kindle_dx' => 'Kindle DX',
    'ipad' => 'iPad',
    'nook' => 'Nook',
    'nook_color' => 'Nook Color',
    'sony300' => 'Sony Reader 3xx',
    'sony900' => 'Sony Reader 9xx',
    'kobo' => 'Kobo'
  }

  FORMAT = {
    'epub' => 'ePub',
    'mobi' => 'mobi'
  }

  MIME_TYPE = {
    'mobi' => 'application/x-mobipocket-ebook',
    'epub' => 'application/epub+zip '
  }

  EDOC_PATH = 'edocs/'
  RECIPE_PATH = 'recipes/'

  def recipe
    File.open(recipe_url, 'r') { |f| f.read }.force_encoding('UTF-8') if File.exists?(recipe_url)
  end

  # Next_run timestamp is based on a combination of REPEAT and ANCHOR. On a give time REPEAT is added to ANCHOR if
  # the ANCHOR timestamp is in the past at this moment
  def next_run_timestamp
    Time.use_zone(self.timezone) do
      if instance_eval('Time.now.utc.' + SCHEDULE[self.schedule][:anchor]).past?
        instance_eval('Time.now.utc.' + SCHEDULE[self.schedule][:anchor] + '+' + SCHEDULE[self.schedule][:repeat]).to_i
      else
        instance_eval('Time.now.utc.' + SCHEDULE[self.schedule][:anchor]).to_i
      end
    end
  end
end