class HomeController < ApplicationController

  def index
    render inline: 'api'
  end
end
