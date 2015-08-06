class Workers::PageParser
  @queue = :page_parser

  def self.perform(url)
    return if Resource.was_analyzed?(url)

    resource = Resource.new(source: url)
    VAlexL::Analyzer.new(resource).analyze!
  end
end
