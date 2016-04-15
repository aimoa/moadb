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
    @image = Image.new(params.require(:image).permit(:url, :tweet, :ghash))

    @image.save
    redirect_to @image
  end

  def update
  end

  def destroy
  end

end
