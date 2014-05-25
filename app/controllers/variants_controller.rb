class VariantsController < ApplicationController
  before_action :set_variant, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
   @variants = Variant.all.order("created_at DESC").paginate(:page => params[:page], :per_page =>5)
 end


  def show
  end

  def new
    @variant = current_user.variants.build
  end

  def edit
  end

  def create
    @variant = current_user.variants.build(variant_params)
      if @variant.save
        redirect_to @variant, notice: 'Варіант був успішно доданий.'
      else
        render action: 'new'
      end
    end
  
  def update
     if @variant.update(variant_params)
        redirect_to @variant, notice: 'Варіант був успішно доданий.'
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

    def correct_user
      @variant = current_user.variants.find_by(id: params[:id])
      redirect_to variants_path, notice: "Ви не є автором цього варіанту і не можете вносити зміни до нього" if @variant.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def variant_params
      params.require(:variant).permit(:kimnatYa, :typYa, :mistoYa, :kimnatVin, :typVin, :mistoVin, :description, :image)
    end
end
