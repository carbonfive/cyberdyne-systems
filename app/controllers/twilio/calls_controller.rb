class Twilio::CallsController < ApplicationController
  skip_before_filter :require_login
  skip_authorization_check
  before_filter :load_call, except: [:create]

  def create
    @call = Call.create(phone_number: params[:From], call_sid: params[:CallSid])
    render_call_state
  end

  def hold
  end

  def pickup_from_queue
  end

  def dequeued
    @call.dequeued!(user_call_sid: params[:DequeingCallSid])
    render_call_state
  end

  def user_call
    @call.user_connected!(user_call_sid: params[:CallSid])
    render_call_state
  end

  def phone_number_call
    @call.phone_number_connected!(call_sid: params[:CallSid])
    render_call_state
  end

  def goodbye
    @call.call_disconnected!
  end

  private

  def render_call_state
    render @call.state
  end

  def load_call
    @call = if params[:id] 
              Call.find(params[:id])
            elsif params[:CallSid]
              Call.find_by_call_sid(params[:CallSid])
            end
  end
end
