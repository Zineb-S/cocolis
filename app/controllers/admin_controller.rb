  class AdminController < ApplicationController
    layout 'admin'

    before_action :authenticate_admin!
    def index
      @deliveries = Delivery.where(fulfilled: false).where.not(id:1).order(created_at: :desc).take(5)
      start_date = 1.week.ago.beginning_of_day
      end_date = Time.now

      @quick_stats = {
        sales: Delivery.where(created_at: start_date..end_date).count,
        revenue: Delivery.where(created_at: start_date..end_date).sum(:total).round(),
        avg_sale: Delivery.where(created_at: start_date..end_date).average(:total).to_f.round(),
        per_sale: DeliveryPackage.joins(:delivery).where(deliveries: {created_at: start_date..end_date}).average(:quantity).to_f.round(),
        total_weight: DeliveryPackage.joins(:delivery).where(deliveries: {created_at: start_date..end_date}).sum(:weight).to_f,
        total_quantity: DeliveryPackage.joins(:delivery).where(deliveries: {created_at: start_date..end_date}).sum(:quantity)
      }
      /@quick_stats = {
        sales: Delivery.where(created_at: Time.now.midnight..Time.now).count,
        revenue: Delivery.where(created_at: Time.now.midnight..Time.now).sum(:total).round(),
        avg_sale: Delivery.where(created_at: Time.now.midnight..Time.now).average(:total).to_f.round(),
        per_sale: DeliveryPackage.joins(:delivery).where(deliveries: {created_at: Time.now.midnight..Time.now}).average(:quantity).to_f.round(),
        total_weight: DeliveryPackage.joins(:delivery).where(deliveries: {created_at: Time.now.midnight..Time.now}).sum(:weight).to_f,
        total_quantity: DeliveryPackage.joins(:delivery).where(deliveries: {created_at: Time.now.midnight..Time.now}).sum(:quantity)
      }/

      @deliveries_by_day = Delivery.where('created_at > ?', Time.now - 7.days).order(:created_at)
      @deliveries_by_day = @deliveries_by_day.group_by { |delivery| delivery.created_at.to_date}
      @revenue_by_day = @deliveries_by_day.map{ |day,deliveries| [day.strftime("%A"),deliveries.sum(&:total)]}
      if @revenue_by_day.count < 7
        days_of_week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

        data_hash=@revenue_by_day.to_h
        current_day = Date.today.strftime("%A")
        current_day_index=days_of_week.index(current_day)
        next_day_index = (current_day_index+1) % days_of_week.length

        delivered_days_with_current_last = days_of_week[next_day_index..-1] + days_of_week[0...next_day_index]
        complete_delivered_array_with_current_last = delivered_days_with_current_last.map{ |day| [day,data_hash.fetch(day,0)]}
        @revenue_by_day = complete_delivered_array_with_current_last
      end
    end
  end