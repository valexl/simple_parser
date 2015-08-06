class VAlexL::Parser
  #################################################
  ####### Incoming point for analyzing page #######
  #################################################

  attr_reader :results

  def initialize(url)
    @base_path = File.dirname(url)
    @path      = File.basename(url)
  end

  def analyze!
    url = File.join(@base_path, @path).sub('./', '')
    Resque.enqueue(Workers::PageParser, url)
  end
end
