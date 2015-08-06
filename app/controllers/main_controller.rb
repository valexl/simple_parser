class MainController < ApplicationController
  def index
    
  end

  def parse
    VAlexL::Parser.new(params[:url]).analyze!
    redirect_to root_url, notice: 'Parsing was begun....'
  end
end
