class ImagesController < ApplicationController
  def spam
    @images = Image.where(:spam => true).order(:ghash).page(params[:page])
  end

  def index
    @images = Image.where(:spam => false).order(:ghash).page(params[:page])
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

    redirect_to images_path
  end

  def update
    @image = Image.find(params[:id])

    redirect_to @image
  end

  def destroy
    @image = Image.find(params[:id])
    @image.update(:spam => true)

    redirect_to images_path
  end

  private
    def image_params
      params.require(:image).permit(:url, :tweet, :ghash)
    end

end
