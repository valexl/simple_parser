class Workers::PageParser
  @queue = :page_parser

  def self.perform(url)
    sleep(1) #для наглядности
    resource = Resource.new(source: url)
    VAlexL::Analyzer.new(resource).analyze! unless resource.was_analyzed?
  end
end
