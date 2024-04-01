class Admin::DeliveriesController < AdminController
  before_action :set_admin_delivery, only: %i[ show edit update destroy ]

  # GET /admin/deliveries or /admin/deliveries.json
  def index
    @not_fulfilled_pagy , @not_fulfilled_deliveries = pagy(Delivery.where(fulfilled: false).order(created_at: :asc))
    @fulfilled_pagy , @fulfilled_deliveries = pagy(Delivery.where(fulfilled: true).order(created_at: :asc) , page_param: :page_fulfilled)
  end

  # GET /admin/deliveries/1 or /admin/deliveries/1.json
  def show
  end

  # GET /admin/deliveries/new
  def new
    @admin_delivery = Delivery.new
  end

  # GET /admin/deliveries/1/edit
  def edit
  end

  # POST /admin/deliveries or /admin/deliveries.json
  def create
    @admin_delivery = Delivery.new(admin_delivery_params)

    respond_to do |format|
      if @admin_delivery.save
        format.html { redirect_to admin_delivery_url(@admin_delivery), notice: "Delivery was successfully created." }
        format.json { render :show, status: :created, location: @admin_delivery }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/deliveries/1 or /admin/deliveries/1.json
  def update
    respond_to do |format|
      if @admin_delivery.update(admin_delivery_params)
        format.html { redirect_to admin_delivery_url(@admin_delivery), notice: "Delivery was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_delivery }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_delivery.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @admin_delivery.destroy!

    respond_to do |format|
      format.html { redirect_to admin_deliveries_url, notice: "Delivery was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_admin_delivery
      @admin_delivery = Delivery.find(params[:id])
    end

    def admin_delivery_params
      params.require(:delivery).permit(:client_email, :driver_email, :fulfilled, :total, :address)
    end
end
