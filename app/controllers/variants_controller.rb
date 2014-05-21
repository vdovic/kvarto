class VariantsController < ApplicationController
  before_action :set_variant, only: [:show, :edit, :update, :destroy]

  def index
    @variants = Variant.all
  end

  def show
  end

  def new
    @variant = Variant.new
  end

  def edit
  end

  def create
    @variant = Variant.new(variant_params)
      if @variant.save
        redirect_to @variant, notice: 'Variant was successfully created.'
      else
        render action: 'new'
      end
    end
  
  def update
     if @variant.update(variant_params)
        redirect_to @variant, notice: 'Variant was successfully updated.'
      else
        render action: 'edit'
      end
    end
  
def destroy
    @variant.destroy
      redirect_to variants_url
    end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variant
      @variant = Variant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def variant_params
      params.require(:variant).permit(:kimnatYa, :typYa, :mistoYa, :kimnatVin, :typVin, :mistoVin, :description)
    end
end
