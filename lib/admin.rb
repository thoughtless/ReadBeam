module Admin
  def self.load_recipe_xml
    require 'rexml/document'
    file = File.open("recipes/public/builtin_recipes.xml")
    doc = REXML::Document.new(file)
    file.close

    doc.elements.each('recipe_collection/recipe') do |element|
    #element = doc.elements['recipe_collection/recipe']
      calibre_id = element.attributes['id']

      source = Source.new

      source.title = element.attributes['title']
      source.language = element.attributes['language']
      source.timezone = 'Berlin'
      source.description = element.attributes['description']
      source.requires_login = true if element.attributes['needs_subscription'] == 'yes'
      source.recipe_name = calibre_id.partition('builtin:')[2]
      source.schedule = 'morning'
      source.language = element.attributes['language'][0..1]

      source.save
    end
  end

  def self.refresh_resque
    # First remove all existing schedules
    Resque.get_schedules.each {|s| Resque.remove_schedule(s[0])} if Resque.get_schedules

    # Then re-schedule all edocs from db
    edocs = Edoc.all

    edocs.each do |edoc|
      PrintJob.schedule(edoc)
    end
  end
end
