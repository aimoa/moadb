class ImagesController < ApplicationController

  def index
    @images = Image.all
  end

  def show
    @image = Image.find(params[:id])
  end

  def new
  end

  def edit
  end

  def create
    @image = Image.create(image_params)
  end

  def update
  end

  def destroy
  end

  private
    def image_params
      params.require(:image).permit(:url, :tweet, :ghash)
    end

end
