class Filter::Genre < Filter
  attr_accessor :genre

  def initialize(params)
    super
    self.genre= @params[:genre]
  end

  def genre= genre
    @genre = genre.present? ? ActsAsTaggableOn::Tag.find_by_name(genre).try(:name) : nil
  end

  def filter_movie_scope(movies)
    @genre ? movies.tagged_with(genre) : movies
  end
end
