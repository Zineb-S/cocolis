class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index

    if current_user.client?
      client_package_ids = current_user.packages.pluck(:id)
      @deliveries = Delivery.joins(:packages).where(packages: {id: client_package_ids}).distinct
    else
      @deliveries = Delivery.where(driver_id: current_user.id)
    end

    Rails.logger.debug "@deliveries: #{@deliveries.inspect}"
    @messages = Message.includes(:delivery).where(delivery: @deliveries).order(created_at: :desc)
  end



  def show
    @message = Message.find(params[:id])
    delivery = @message.delivery
    unless [delivery.client_email, delivery.driver_email].include?(current_user.email)
      redirect_to root_path, alert: 'You do not have access to this message.'
    end
  end

  def create
    delivery_package_id = params.dig(:message, :delivery_package_id) || params[:delivery_package_id]
    content = params.dig(:message, :content) || params[:content]

    delivery_package = DeliveryPackage.find_by(id: delivery_package_id)

    if delivery_package.blank?
      redirect_back(fallback_location: root_path, alert: "Delivery package not found.")
      return
    end

    package = Package.find_by(id: delivery_package.package_id)

    if package.blank?
      redirect_back(fallback_location: root_path, alert: "Package associated with the delivery package not found.")
      return
    end

    # Determine the receiver based on the sender's role
    receiver_id = nil
    if current_user.driver?
      # If the sender is the driver, the receiver is the client who owns the package
      receiver_id = package.user_id
    elsif current_user.client?
      # If the sender is the client, the receiver is the driver of the delivery
      receiver_id = delivery_package.delivery.driver_id
    end

    unless receiver_id
      redirect_back(fallback_location: root_path, alert: "Message receiver could not be determined.")
      return
    end

    @message = Message.new(
      delivery_id: delivery_package.delivery_id,
      sender_id: current_user.id,
      receiver_id: receiver_id,
      content: content,
      delivery_package_id: delivery_package_id
    )

    if @message.save
      redirect_path = current_user.driver? ? driver_message_details_path(delivery_package_id) : client_message_details_path(delivery_package_id)
      redirect_to redirect_path, notice: "Message sent successfully."
    else
      redirect_back(fallback_location: root_path, alert: "Message could not be sent. " + @message.errors.full_messages.join(", "))
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :delivery_id)
  end

  def redirect_to_appropriate_path_for(user, delivery)
    path = user.client? ? client_message_details_path(delivery) : driver_message_details_path(delivery)
    redirect_to path, notice: 'Message sent successfully.'
  end
end
