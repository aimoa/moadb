class ImagesController < ApplicationController

  def index
    @images = Image.order(:ghash)
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
    @image = Image.find(params[:id])
    @image.destroy

    redirect_to images_path
  end

  private
    def image_params
      params.require(:image).permit(:url, :tweet, :ghash)
    end

end
