class VAlexL::Analyzer
  ###############################
  ##### анализатор страницы #####
  ###############################
  def initialize(resource)
    @resource = resource
    @agent = Mechanize.new
    @agent.max_history = 0
    @agent.user_agent_alias = "Mac Safari"
    begin
      @stage = @agent.get(@resource.source) 
    rescue ::Mechanize::ResponseCodeError
      Rails.logger.error "Can't open resource #{@resource.source}" 
      @stage = nil
    end
  end

  def analyze!
    return @resource if @stage.nil?
    @resource.title       = get_title
    @resource.tag_list    = get_tags
    @resource.description = get_description
    @resource.save! and analyzed_inner_resources!
  end

  private
    def analyzed_inner_resources!
      get_links.each do |inner_path|
        full_url = get_full_url(@resource.get_root_path, inner_path)
        VAlexL::Parser.new(full_url).analyze!
      end
    end

    def get_links
      @stage.search('a').map{|a| a['href']}
    end
    
    def get_title
      title = @stage.search("h1").first
      title.text unless title.nil?
    end

    def get_tags
      @stage.search("p.tags").text.sub("Tags:", '')
    end

    def get_description
      description = @stage.search("p.descr").first
      description.text unless description.nil?
    end

    def get_full_url(root_path, subpath)
      File.join(root_path, subpath)
    end
end
