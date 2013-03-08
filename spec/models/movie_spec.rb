require 'spec_helper'

describe Movie do
	describe 'searching database for movies with same director' do
		before :each do
			@fake_movie1 = FactoryGirl.build(:movie)
			@fake_movie2 = FactoryGirl.build(:movie, :title => 'No director', :id => 2, :director => "")
		end
		it 'should call a search for the correct movie to find the director' do
			Movie.should_receive(:find).with(@fake_movie1.id).and_return(@fake_movie1)
			Movie.same_director(@fake_movie1.id)
		end
		describe 'the movie had no director info' do
			it 'should return the title of the movie' do
				Movie.stub(:find).and_return(@fake_movie2)
				Movie.same_director(@fake_movie2.id).should == 'No director'
			end
		end
	end
	describe 'getting all ratings from database' do
		Movie.all_ratings.should == ["G", "PG", "PG-13", "NC-17", "R"]
	end
end

