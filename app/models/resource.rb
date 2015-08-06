class Resource < ActiveRecord::Base
  serialize :links, JSON

  class << self
    def get_correct_url(url)
      return url if url[/\Ahttp:\/\//]
      "http://#{url}"
    end

    def get_full_url(root_path, subpath)
      File.join(root_path, subpath)
    end
  end

  attr_accessor :tag_list

  has_and_belongs_to_many :tags
  
  after_initialize :fix_source
  after_create  do
    analyzed_inner_resources!
    append_tags!
    true
  end

  def was_analyzed?
    #FIXME если будет тербоваться считать localhost:3000/index.html и localhost:3000 как одну страницу то нужно переделать этот метод
    Resource.exists?(source: source) 
  end

  def get_original
    Resource.find_by(source: self.source)
  end

  def get_root_path
    @get_root_path = "#{source}".gsub(/\Ahttp:\/\//, '')
    @get_root_path.split("/").first
  end

  private

    def analyzed_inner_resources!
      links.values.each do |inner_path|
        full_url = Resource.get_full_url(get_root_path, inner_path)
        VAlexL::Parser.new(full_url).analyze!
      end
    end

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
