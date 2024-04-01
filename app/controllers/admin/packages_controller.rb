class Admin::PackagesController < AdminController
  before_action :set_admin_package, only: %i[ show edit update destroy ]

  # GET /admin/packages or /admin/packages.json
  def index
    if params[:query].present?
      @pagy, @admin_packages = pagy(Package.where("name LIKE ?","%#{params[:query]}%"))
    else
      @pagy, @admin_packages = pagy(Package.all)
    end

  end

  # GET /admin/packages/1 or /admin/packages/1.json
  def show
  end

  # GET /admin/packages/new
  def new
    @admin_package = Package.new
  end

  # GET /admin/packages/1/edit
  def edit
  end

  # POST /admin/packages or /admin/packages.json
  def create
    @admin_package = Package.new(admin_package_params)

    respond_to do |format|
      if @admin_package.save
        format.html { redirect_to admin_package_url(@admin_package), notice: "Package was successfully created." }
        format.json { render :show, status: :created, location: @admin_package }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_package.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @admin_package = Package.find(params[:id])
    if @admin_package.update(admin_package_params.reject { |k| k["images"]})
      if admin_package_params["images"]
        admin_package_params["images"].each do |image|
          @admin_package.images.attach(image)
        end
      end
      redirect_to admin_packages_path , notice: "Package was successfully updated."
    else
      render :edit , status: :unprocessable_entity
    end
    end
  # DELETE /admin/packages/1 or /admin/packages/1.json
  def destroy
    @admin_package.destroy!

    respond_to do |format|
      format.html { redirect_to admin_packages_url, notice: "Package was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_package
      @admin_package = Package.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_package_params
      params.require(:package).permit(:name, :description, :price, :category_id, :active,images:[])
    end
end
