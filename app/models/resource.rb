class Resource < ActiveRecord::Base
  class << self
    def was_analyzed?(url)
      #FIXME если будет тербоваться считать localhost:3000/index.html и localhost:3000 как одну страницу то нужно переделать этот метод
      exists?(source: get_correct_url(url)) 
    end
    
    def get_correct_url(url)
      return url if url[/\Ahttp:\/\//]
      "http://#{url}"
    end
  end

  attr_accessor :tag_list

  has_and_belongs_to_many :tags
  
  after_initialize :fix_source
  after_create  do
    append_tags!
    true
  end

  def get_root_path
    @get_root_path = "#{source}".gsub(/\Ahttp:\/\//, '')
    @get_root_path.split("/").first
  end

  private

    def append_tags!
      #Пример списка тегов TAG1, TAG2,TAG3 TAG4 - я так понял это не опечатка, а так задуманно, поэтому ниже будет ужасное преобразование...
      return true if self.tag_list.blank?
      self.tag_ids =  self.tag_list.to_s.split(" ").join(",").gsub(/\,+/, ',').split(',').inject([]) do |ids, tag_name|
                        tag = Tag.find_or_create_by title: tag_name
                        ids.push(tag.id)
                      end
    end

    def fix_source
      self.source = Resource.get_correct_url(self.source)
      true
    end
end
