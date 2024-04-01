class DriversController < ApplicationController
  before_action :authenticate_user!
  before_action :set_delivery, only: [:edit_delivery, :update_delivery, :destroy_delivery]
  before_action :set_package, only: [:show]

  def dashboard
    @packages = Package.where(active: true)

    if params[:category].present?
      @packages = @packages.where(category_id: params[:category])
    end

    if params[:min_price].present? && params[:max_price].present?
      @packages = @packages.where("price >= ? AND price <= ?", params[:min_price], params[:max_price])
    end

    if params[:min_weight].present?
      @packages = @packages.where("weight >= ?", params[:min_weight])
    end

    if params[:max_weight].present?
      @packages = @packages.where("weight <= ?", params[:max_weight])
    end

    if params[:dimensions].present?
      # Simple exact match for dimensions. Adjust as necessary for more complex matching.
      @packages = @packages.where(dimensions: params[:dimensions])
    end
  end

  def messages
    # Assuming a Delivery has many delivery_packages and each delivery_package has many messages
    @deliveries = Delivery.includes(delivery_packages: {messages: [:sender, :receiver]})
                          .where(driver_id: current_user.id)
                          .where.not(id: 1) # Excluding delivery with ID 1 as per your setup

    # This gathers all messages related to the driver's deliveries for display
  end



  def messages_details
    @delivery_package = DeliveryPackage.find_by(id: params[:id])

    if @delivery_package.blank? || @delivery_package.delivery.driver_id != current_user.id
      Rails.logger.error "Delivery package not found or you don't have access to it."
      redirect_to driver_messages_path, alert: "Delivery package not found or you don't have access to it."
      return
    end

    # Fetch the payment associated with the delivery package
    @payment = Payment.find_by(delivery_package_id: @delivery_package.id)

    if params[:mark_as_delivered].present?
      if @delivery_package.update(delivered: true)
        flash[:notice] = "Delivery package marked as delivered."
      else
        flash[:alert] = "Failed to mark delivery package as delivered."
      end
      redirect_to driver_message_details_path(id: @delivery_package.id) # Ensure the redirect includes the package ID
      return
    end

    @messages = @delivery_package.messages.includes(:sender, :receiver).order(created_at: :asc)
  end



  def show
    @deliveries = Delivery.where(driver_id: current_user.id).where.not(id: 1).where.not(fulfilled:true)

  end
  def profile
    @driver = current_user
  end

  def deliveries
    @deliveries = Delivery.includes(delivery_packages: {package: :user})
                          .where(driver_id: current_user.id).where.not(id: 1)
                          .order('deliveries.created_at DESC')
    end
  def new_delivery
    @delivery = Delivery.new
  end
  def assign_delivery_to_package
    delivery_package = DeliveryPackage.find_by(package_id: params[:package_id])
    if delivery_package.update(delivery_id: params[:delivery_id])
      redirect_to package_path(params[:package_id]), notice: 'Package successfully linked to delivery.'
    else
      redirect_to package_path(params[:package_id]), alert: 'Failed to link package to delivery.'
    end
  end

  def create_delivery
    @delivery = Delivery.new(delivery_params.except(:client_email))
    @delivery.driver = current_user

    if @delivery.save
      redirect_to driver_deliveries_path, notice: 'Delivery was successfully created.'
    else
      render :new_delivery
    end
  end

  def edit_delivery
    @delivery = Delivery.includes(:delivery_packages).find(params[:id])
    @delivery.delivery_packages.build if @delivery.delivery_packages.empty?
  end

  def update_delivery
    if @delivery.update(delivery_params)
      redirect_to driver_deliveries_path, notice: 'Delivery was successfully updated.'
    else
      render :edit_delivery
    end
  end

  def destroy_delivery
    @delivery.destroy
    redirect_to driver_deliveries_path, notice: 'Delivery was successfully deleted.'
  end

  private

  def set_delivery
    @delivery = Delivery.find(params[:id])
    if @delivery.id == 1
      redirect_to root_path, alert: 'Access to the specified delivery is restricted.'
      return
    end
  end

  def mark_as_delivered
    if @delivery_package.update(delivered: true)
      Rails.logger.info "Delivery package marked as delivered successfully."
      flash[:notice] = "Delivery package marked as delivered."
    else
      Rails.logger.error "Failed to mark delivery package as delivered: #{@delivery_package.errors.full_messages.join(', ')}"
      flash[:alert] = "Failed to mark delivery package as delivered."
    end
    redirect_to request.referrer || root_path # Fallback to root_path if referrer is not available
  end
  def delivery_params
    params.require(:delivery).permit( :total,  :package_received,:fulfilled,  :departure_city, :arrival_city, :departure_date, :arrival_date, :address, delivery_packages_attributes: [:id, :package_id, :departureCity, :destinationCity, :departureDate, :arrivalDate, :quantity, :weight, :_destroy])
  end
  def set_package
    @package = Package.find(params[:id])
  end
end
