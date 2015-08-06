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
    @resource.links       = get_links
    @resource.title       = get_title
    @resource.tag_list    = get_tags
    @resource.description = get_description
    @resource.save!
  end

  private
    def get_links
      @stage.search('a').inject({}) do |res, a|
        res[a.text] = a['href']
        res
      end
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

end
