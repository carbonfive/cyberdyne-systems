class Target < ActiveRecord::Base
  attr_accessible :email, :name, :phone_number, :priority, :image_url
end
