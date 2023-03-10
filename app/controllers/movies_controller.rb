class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :default_user, only: %i[ create edit destroy update ]

  # GET /movies or /movies.json
  def index
    @movies = Movie.page(params[:page])
  end

  # GET /movies/1 or /movies/1.json
  def show
    @reviews = Review.where(movie_id: @movie.id).order("created_at DESC")

    if @reviews.blank?
      @average_rating = 0
    else
      @average_rating = @reviews.average(:rating).round(2)
    end
  end

  # GET /movies/new
  def new
    @movie = current_user.movies.build
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = current_user.movies.build(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @reviews = Review.where(movie_id: @movie.id)
    @reviews.destroy_all
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_movie
    @movie = Movie.find(params[:id])
  end

  def default_user
    redirect_to movies_path, alert: "Not admin" if current_user.user?
  end

  # Only allow a list of trusted parameters through.
  def movie_params
    params.require(:movie).permit(:title, :description, :director, :movie_length, :rating, :user_id, :image)
  end
end
