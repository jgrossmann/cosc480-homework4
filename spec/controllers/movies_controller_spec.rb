require 'spec_helper'

describe MoviesController do
	describe 'searching for movies with same director' do
		before :each do
			@fake_results = [mock('movie1'), mock('movie2')]
		end
		it 'should call the model method that performs same director search' do
			Movie.should_receive(:same_director).with("1").and_return(@fake_results)
			post :search_same_director, {:id => "1"}
		end
		describe 'after valid search' do
			before :each do
				Movie.stub(:same_director).and_return(@fake_results)
				post :search_same_director, {:id => "1"}
			end
			it 'should go to the same director movie page' do
				response.should render_template('search_same_director')
			end
			it 'should make the movies with the same directors available to the page' do
				assigns(:movies).should == @fake_results
			end
		end
		describe 'the movie had no director info' do
			before :each do
				Movie.stub(:same_director).and_return("Aladdin")
				post :search_same_director, {:id => "1"}
			end
			it 'should go to the home page' do
				response.should redirect_to('/movies')
			end
			it 'should flash a message about no director info to the home page' do
				flash[:notice].should == "\'Aladdin\' has no director info"
			end
		end
	end
	describe 'listing movies on the home page' do
		it 'should grab all ratings from movie database' do
			Movie.should_receive(:all_ratings).and_return(["G", "PG", "PG-13", "NC-17", "R"])
			post :index
		end
		describe 'session disagrees with parameters' do
			it 'should change sort settings and redirect' do
				session.stub(:sort).with("")
				post :index, {:sort => "title"}
			end
		end
		describe 'release date sort was clicked on' do
			it 'should hilite release date by setting the date header to hilite' do
				post :index, {:sort => 'release_date'}
			end
		end
	end
	describe 'going to a movies info page' do
		it 'should return the movies information' do
			fake_movie = mock("movie1")
			Movie.should_receive(:find).with("1").and_return(fake_movie)
			post :show, {:id => 1}
		end
	end
	describe 'creating a new movie' do
		it 'should save a movie to database' do
			fake_movie = mock("movie1")
			Movie.stub(:create).and_return(fake_movie)
			post :create, {:title => 'stupid movie', :id => 1}
		end
	end
	describe 'updating a movie' do
		it 'should update a movie in the database' do
			fake_movie = FactoryGirl.build(:movie)
			Movie.should_receive(:find).with("#{fake_movie.id}").and_return(fake_movie)
			post :update, {:id => fake_movie.id}
		end
	end
	describe 'editing a movie info' do
		it 'should edit the movies info in the database' do
			fake_movie = FactoryGirl.build(:movie)
			Movie.should_receive(:find).with("#{fake_movie.id}").and_return(fake_movie)
			post :edit, {:id => fake_movie.id}
		end
	end
end
