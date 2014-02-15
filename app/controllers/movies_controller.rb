class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_all_ratings
    @sort_by = (params.has_key? :sort_by and ["title", "release_date"].include?(params[:sort_by])) ? params[:sort_by] : nil
    @selected_ratings = (params.has_key? :ratings) ? params[:ratings].keys : @all_ratings
    @selected_ratings = @all_ratings & @selected_ratings
    debugger
    if not @sort_by.nil?
      @movies = Movie.find(:all, :order => "#{@sort_by} ASC")
    elsif not @selected_ratings.length > 0
      @movies = Movie.where("rating == ?", @selected_ratings)
    else
      @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
