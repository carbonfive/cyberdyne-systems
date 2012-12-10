class AddImageUrlToTargets < ActiveRecord::Migration
  def change
    add_column :targets, :image_url, :string
  end
end
