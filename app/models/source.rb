class Source < ActiveRecord::Base
  require 'source_mixin'
  include SourceMixin

  has_many :edocs

  def recipe_url
    RECIPE_PATH + 'public/' + self.recipe_name + '.recipe'
  end
end