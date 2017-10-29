class DashboardController < ApplicationController
  def index
    @devices_count = Device.all.count
    @devices_present_count = Device.where(active: true).count

    @complete_flow_count = Flow.where(state: :complete).count
    @reset_flow_count = Flow.where(state: :reset).count
    @incomplete_flow_count = Flow.where(state: :incomplete).count

    @matched_partial_flow_count = PartialFlow.where(state: :matched).count
    @unmatched_partial_flow_count = PartialFlow.where(state: :unmatched).count
    @ignored_partial_flow_count = PartialFlow.where(state: :ignored).count

    @most_recent_flow = Flow.order(timestamp: :desc).first
    @most_recent_partial_flow = PartialFlow.order(timestamp: :desc).first
  end
end
