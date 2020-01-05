class PetController < ApplicationController
  def new
    @pet = Pet.new
    @pet.birthday = Time.parse("2019-10-12")
  end

  def create
    @pet = Pet.new(pet_params)
    if @pet.validate
      @pet.save!
      redirect_to pet_path(@pet.id)
      return
    end

    render :new, status: 400
  end

  def show
    @pet = Pet.find_by(id: params[:id])
  end

  def index
    @pets = Pet.all
  end

  def events
    @pet = Pet.find_by(id: params[:id])
    @events = @pet.events
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :kind, :breed, :birthday)
  end
end
