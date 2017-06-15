class DashboardController < ApplicationController
  def index
    @devices_count = Device.all.count
    @devices_present_count = Device.where(active: true).count
  end
end
