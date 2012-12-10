class HomeController < ApplicationController
  skip_before_filter :require_login
  skip_authorization_check

  def index
  end
end
