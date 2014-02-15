class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_all_ratings
    if params.has_key? :sort_by and ["title", "release_date"].include?(params[:sort_by])
      @sort_by = params[:sort_by]
      session[:sort_by] = @sort_by
    else
      if session.has_key? :sort_by
        @sort_by = session[:sort_by]
      else
        @sort_by = nil
      end
    end
    if params.has_key? :ratings and (@all_ratings & params[:ratings].keys).length > 0
      @selected_ratings = @all_ratings & params[:ratings].keys
      session[:selected_ratings] = @selected_ratings
    else
      if session.has_key? :selected_ratings
        @selected_ratings = session[:selected_ratings]
      else
        @selected_ratings = @all_ratings
        session[:selected_ratings] = @selected_ratings
      end
    end      
    if not @sort_by.nil?
      @movies = Movie.where(:rating => @selected_ratings).find(:all, :order => "#{@sort_by} ASC")
    else
      @movies = Movie.where(:rating => @selected_ratings)
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
