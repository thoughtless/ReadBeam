class PagesController < ApplicationController
  def index    
    @featured_edocs = Edoc.where(:is_featured => true)
    @all_sources = Source.all
  end

  def calibre_hosting
    @page_title = 'Calibre Hosting | ReadBeam'
  end

  def download_ebook_ipad
    @page_title = 'Free eBooks iPad | ReadBeam'
  end

  def download_ebook_kindle
    @page_title = 'Free eBooks Kindle | ReadBeam'
  end

  def calibre_ebook_conversion
    @page_title = 'Convert eBooks with Calibre recipes | ReadBeam'
  end

  def kindle_blog_subscribe
    @page_title = 'Kindle Subcriptions | ReadBeam'
  end
  
  def source
    if @source = Source.find_by_recipe_name(params[:recipe])
      @page_title = @source.title + ' Free Ebooks'
      @related_edocs = Edoc.where(:source_id => @source.id)
    else
      not_found
    end
  end
end