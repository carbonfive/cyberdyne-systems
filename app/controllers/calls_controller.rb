class CallsController < ApplicationController
  before_filter :require_login

  load_and_authorize_resource

  def create
    @call = Call.new(params[:call])
    @call.user = current_user
    if @call.save!
      render json: @call
    else
      head :error
    end
  end

  def next
    current_user.pickup_from_queue!
    head :ok
  end
end
