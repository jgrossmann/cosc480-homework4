class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date, :director
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
	def self.same_director(id)
		movie = self.find(id)
		if(movie.director == nil || movie.director == "")
			return movie.title
		end
		self.find_all_by_director(movie.director)
	end
end
