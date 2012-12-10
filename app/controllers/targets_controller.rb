class TargetsController < ApplicationController
  before_filter :require_login

  load_and_authorize_resource

  def index
  end
end
