class ClientsController < ApplicationController
  before_action :log_before_actions
  before_action :authenticate_user!, :set_package, only: [:edit_package, :update_package, :destroy_package]
  before_action :set_package, only: [:edit_package, :update_package, :destroy_package]

  # Adjust this line to exclude :messages_details from calling :set_delivery
  before_action :set_delivery, only: [ :show]


  # Ensure this is correctly setting the @delivery_package
  before_action :set_delivery_package, only: [:pay, :messages_details]
  before_action :set_delivery_packages, only: [:show]

  def log_before_actions
    Rails.logger.debug "Before action called for action: #{action_name} with params: #{params.inspect}"
    end

  def dashboard
    scope = Delivery.includes(:driver, :delivery_packages).where.not(id: 1).where(fulfilled: false)

    if params[:categories].present?
      scope = scope.joins(delivery_packages: {package: :category}).where(categories: {id: params[:categories]}).distinct
    end

    if params[:min_weight].present? && params[:max_weight].present?
      scope = scope.joins(:delivery_packages)
                   .where('delivery_packages.weight BETWEEN ? AND ?', params[:min_weight], params[:max_weight])
    end

    if params[:departure_city].present?
      scope = scope.where('departure_city = ?', params[:departure_city])
    end

    if params[:arrival_city].present?
      scope = scope.where('arrival_city = ?', params[:arrival_city])
    end

    if params[:departure_date].present?
      scope = scope.where('departure_date >= ?', Date.parse(params[:departure_date]))
    end

    if params[:arrival_date].present?
      scope = scope.where('arrival_date <= ?', Date.parse(params[:arrival_date]))
    end

    @pagy, @deliveries = pagy(scope.distinct, items: 5)
  end

  def pay
    # Ensure that @delivery and @delivery_package are set.
    # Assuming @delivery_package is now being set correctly in a before_action filter.
    Rails.logger.debug "Attempting payment for Delivery: #{@delivery}, DeliveryPackage: #{@delivery_package}"

    unless @delivery_package
      redirect_to client_dashboard_path, alert: "Invalid request. No package found for payment."
      return
    end

    total_price = @delivery_package.package.price * 100

    stripe_session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
                     price_data: {
                       currency: 'usd',
                       product_data: {
                         name: "Payment for Package ##{@delivery_package.package.id}",
                       },
                       unit_amount: total_price,
                     },
                     quantity: 1,
                   }],
      mode: 'payment',
      success_url: root_url + "client/messages/#{@delivery_package.id}/details?session_id={CHECKOUT_SESSION_ID}&payment_status=success",
      cancel_url: root_url + "client/messages/#{@delivery_package.id}/details?payment_status=cancel",
      )

    redirect_to stripe_session.url, allow_other_host: true

  end

  def link_package_to_delivery
    package = Package.find_by(id: params[:package_id], user_id: current_user.id)
    delivery = Delivery.find_by(id: params[:delivery_id])

    if package.nil? || delivery.nil?
      redirect_to some_path, alert: "Package or Delivery not found."
      return
    end

    # Example of how you might link the package to the delivery.
    # This assumes you have a method or way to do so.
    # For example, creating a DeliveryPackage record if that's how they are linked.
    DeliveryPackage.create(delivery: delivery, package: package)

    # Update the delivery's total to include the package's price.
    # Ensure to handle cases where package.price might be nil.
    delivery.total += package.price || 0
    if delivery.save
      redirect_to delivery_path(delivery), notice: 'Package linked to delivery successfully, and total updated.'
    else
      # Handle save failure, possibly showing validation errors.
      redirect_to delivery_path(delivery), alert: 'Failed to update delivery total.'
    end
  end

  def messages



    #@messages = Message.includes(:delivery).where(delivery: @deliveries).order(created_at: :desc)
    user_packages = Package.where(user_id: current_user.id)

    # Now, find all delivery packages that are associated with the user's packages.
    # This assumes you have a direct association between packages and delivery packages.
    # Adjust the query based on your actual associations.
    @delivery_packages = DeliveryPackage.includes(:package, :delivery).where(package_id: user_packages.select(:id)).where.not(delivery_id:1)

    # If you need to fetch deliveries instead, you can adjust the query accordingly.
    # For example, you might want to show deliveries related to the current user's packages.
    @deliveries = Delivery.joins(:delivery_packages).where(delivery_packages: { package_id: user_packages.select(:id) }).distinct


  end

  def messages_details
    unless @delivery_package
      redirect_to client_dashboard_path, alert: "Delivery package not found."
      return
    end

    @messages = Message.where(delivery_package_id: @delivery_package.id).order(created_at: :asc)
    @payment_status = Payment.exists?(delivery_package_id: @delivery_package.id, payment_done: true)
    @existing_review = Review.find_by(delivery_id: @delivery_package.delivery_id, client_id: current_user.id)

    if params[:mark_as_received].present? && @delivery_package.delivered? && !@delivery_package.received?
      @delivery_package.update(received: true)
      @delivery_package.package.update!(active: 0)
      flash[:notice] = "Package receipt confirmed."
      check_and_update_delivery_fulfillment(@delivery_package.delivery_id)
      redirect_to request.referrer
      return
    end

    if params[:payment_status] == 'success' && params[:session_id].present?
      confirm_payment_and_create_record(params[:session_id], @delivery_package.delivery_id, @delivery_package.id)
      flash[:notice] = "Payment successful."
    end
  end
  def show
    if params[:id] == '1'
      Rails.logger.debug "Attempt to access delivery with ID: 1"
      redirect_to root_path, alert: "Invalid delivery."
      return
    end
    @delivery = Delivery.includes(:driver, delivery_packages: { package: :user }).find_by(id: params[:id])

    unless @delivery
      Rails.logger.debug "Delivery not found in show method for ID: #{params[:id]}"
      redirect_to root_path, alert: "Delivery not found."
      return
    end

    Rails.logger.debug "Showing delivery for ID: #{params[:id]}"
    @available_packages = Package.where(active: true).where.not(id: @delivery.packages.pluck(:id)).where(user_id: current_user.id)
  end


  def profile

    @user = current_user
  end


  # Show details for a specific delivery, including messages


  def my_packages
    @packages = current_user.packages.all
  end

  # GET /packages/new
  def new_package
    @package = current_user.packages.build
    @package.delivery_packages.build if @package.delivery_packages.empty?
  end



  def create_package
    @package = current_user.packages.build(package_params)

    # Set weight and dimensions for the package based on delivery package's values
    @package.weight = @package.delivery_packages.first.weight

    default_delivery_id = 1

    @package.delivery_packages.each do |dp|
      dp.delivery_id = default_delivery_id
    end

    if @package.save
      redirect_to my_packages_path, notice: 'Package was successfully created.'
    else
      render :new_package, status: :unprocessable_entity
    end
  end


  def edit_package
    # The @package is set by the before_action
  end


  def check_payment_status_for(delivery_package)
    Payment.exists?(delivery_package_id: delivery_package.id, payment_done: true)
  end


  def update_package
    # Debug statement to inspect the incoming parameters
    Rails.logger.debug "Received params: #{params.inspect}"

    ActiveRecord::Base.transaction do
      if @package.update(package_params.except(:new_images, :image_ids))
        attach_new_images
        remove_selected_images
        redirect_to my_packages_path, notice: 'Package was successfully updated.'
      else
        render :edit_package, status: :unprocessable_entity
      end
    end

  end

  def destroy_package
    @package.destroy
    redirect_to my_packages_path, notice: 'Package was successfully deleted.'
  end

  private
  def message_belongs_to_current_user?(message)
    message.sender_id == current_user.id || message.receiver_id == current_user.id
  end

  def message_related_to_user_packages?(message, user_package_ids_in_delivery)
    message.delivery_package.present? && user_package_ids_in_delivery.include?(message.delivery_package.package_id)
  end
  def current_user_is_sender_or_receiver?(message)
    (message.sender_id == current_user.id && message.receiver_id == @delivery.driver_id) ||
      (message.sender_id == @delivery.driver_id && message.receiver_id == current_user.id)
  end

  def package_params
    params.require(:package).permit(
      :name, :description, :price, :category_id, :active, :dimensions, :weight, images: [],
      delivery_packages_attributes: [:quantity, :weight, :dimensions, :departureCity, :destinationCity, :departureDate, :arrivalDate]
    )
  end







  def attach_new_images
    return unless params.dig(:package, :new_images)

    params[:package][:new_images].each do |new_image|
      @package.images.attach(new_image)
    end
  end

  def remove_selected_images
    Rails.logger.debug "Starting image removal process"
    return unless params.dig(:package, :image_ids)

    image_ids = params[:package][:image_ids].reject(&:blank?).map(&:to_i)
    Rails.logger.debug "Image IDs to remove: #{image_ids.inspect}"

    # Assuming image_ids are the IDs of ActiveStorage::Blob objects
    @package.images.each do |attachment|
      if image_ids.include?(attachment.blob_id)
        Rails.logger.debug "Removing image: #{attachment.blob_id}"
        attachment.purge
      end
    end

    Rails.logger.debug "Finished image removal process"
  end



  def set_package
    @package = current_user.packages.find_by(id: params[:id])
    redirect_to client_dashboard_path, alert: "Package not found." unless @package
  end

  def set_delivery
    @delivery = Delivery.find_by(id: params[:id])
    unless @delivery
      redirect_to client_dashboard_path, alert: "Delivery not found."
    end
  end


  def set_delivery_packages
    # Assuming @delivery is already set by set_delivery method
    unless @delivery.nil?
      @delivery_package_ids = @delivery.delivery_packages.pluck(:id)
    else
      # Handle the case where @delivery is nil, if necessary
      redirect_to client_dashboard_path, alert: "Delivery not found."
    end
  end

  def set_delivery_package
    @delivery_package = DeliveryPackage.find_by(id: params[:delivery_package_id] || params[:id])
    unless @delivery_package
      redirect_back(fallback_location: client_dashboard_path, alert: "Delivery package not found.")
    end
  end




  def confirm_payment_and_create_record(session_id, delivery_id, delivery_package_id)
    # Log the incoming parameters for debugging
    Rails.logger.debug "Confirming payment and creating record for Session ID: #{session_id}, Delivery ID: #{delivery_id}, Delivery Package ID: #{delivery_package_id}"

    # Retrieve the Stripe session
    stripe_session = Stripe::Checkout::Session.retrieve(session_id)

    if stripe_session.payment_status == "paid"
      # Ensure a Payment record is created only if it doesn't already exist for this delivery and client
      payment = Payment.find_or_initialize_by(delivery_id: delivery_id, delivery_package_id: delivery_package_id, client_id: current_user.id)

      if payment.new_record? || !payment.payment_done
        # Assuming a delivery has many delivery_packages and packages through delivery_packages
        # And assuming one delivery_package per payment for simplicity
        delivery_package = DeliveryPackage.find(delivery_package_id)
        package_id = delivery_package.package.id

        # Set or update necessary attributes
        payment.attributes = {
          package_id: package_id,
          payment_done: true
        }

        if payment.save
          # Log success message
          Rails.logger.debug "Payment record created successfully for Delivery ID: #{delivery_id}, Delivery Package ID: #{delivery_package_id}"
          flash[:notice] = "Payment successful."
        else
          # Log error messages and inform the user
          logger.error "Payment record could not be saved: #{payment.errors.full_messages.to_sentence}"
          flash[:alert] = "Could not create or update payment record: #{payment.errors.full_messages.to_sentence}"
        end
      end
    else
      # Log payment failure
      logger.error "Payment failed."
      flash[:alert] = "Payment failed."
    end
  rescue Stripe::StripeError => e
    # Log Stripe error
    logger.error "Stripe error while confirming payment: #{e.message}"
    flash[:alert] = "There was a problem with the payment service."
  end


  def handle_package_receipt
    if @delivery_package.delivered? && !@delivery_package.received?
      @delivery_package.update(received: true)
      redirect_to request.referrer, notice: "Package receipt confirmed."
    end
  end
  def check_and_update_delivery_fulfillment(delivery_id)
    delivery = Delivery.find_by(id: delivery_id)
    return unless delivery

    all_received = delivery.delivery_packages.all? do |package|
      package.delivered? && package.received?
    end

    if all_received
      delivery.update(fulfilled: true, package_received: true)
      Rails.logger.info "Delivery ##{delivery_id} marked as fulfilled."
    else
      Rails.logger.info "Not all packages in Delivery ##{delivery_id} are marked as received."
    end
  end
end
