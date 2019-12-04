require 'net/http'
require 'uri'
require 'rss'

class PodcastsController < ApplicationController
  before_action :set_podcast, only: [:show, :edit, :update, :destroy, :import]

  # GET /podcasts
  # GET /podcasts.json
  def index
    @podcasts = Podcast.all
  end

  # GET /podcasts/1
  # GET /podcasts/1.json
  def show
  end

  # GET /podcasts/new
  def new
    @podcast = Podcast.new
  end

  # GET /podcasts/1/edit
  def edit
  end

  # POST /podcasts
  # POST /podcasts.json
  def create
    @podcast = Podcast.new(podcast_params)

    respond_to do |format|
      if @podcast.save
        format.html { redirect_to @podcast, notice: 'Podcast was successfully created.' }
        format.json { render :show, status: :created, location: @podcast }
      else
        format.html { render :new }
        format.json { render json: @podcast.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /podcasts/1
  # PATCH/PUT /podcasts/1.json
  def update
    respond_to do |format|
      if @podcast.update(podcast_params)
        format.html { redirect_to @podcast, notice: 'Podcast was successfully updated.' }
        format.json { render :show, status: :ok, location: @podcast }
      else
        format.html { render :edit }
        format.json { render json: @podcast.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /podcasts/1
  # DELETE /podcasts/1.json
  def destroy
    @podcast.destroy
    respond_to do |format|
      format.html { redirect_to podcasts_url, notice: 'Podcast was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    uri = URI.parse(@podcast.rss_url)
    response = Net::HTTP.get_response(uri)
    @rss = RSS::Parser.parse(response.body)

    @rss.items.each do |item|
      @podcast.episodes.find_or_create_by(guid: item.guid.content) do |ep|
        ep.title = item.title
        ep.enclosure_url = item.enclosure.url
      end
    end

    respond_to do |format|
      format.html { redirect_to podcast_url(@podcast), notice: 'Podcast was successfully imported.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_podcast
      @podcast = Podcast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def podcast_params
      params.require(:podcast).permit(:name, :rss_url)
    end
end
