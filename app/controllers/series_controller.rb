class SeriesController < ApplicationController

  def show
    @series = Series.find(params[:id])
    @titles = @series.titles.sort{|a,b| a.position.nil? ? 1 : (b.position.nil? ? -1 : a.position <=> b.position)}

    respond_to do |format|
      format.js
    end
  end


end
