class Admin::SkinsController < AdminController
  inherit_resources
  actions :show, :update, :edit
  belongs_to :studio
  belongs_to :movie, :singleton => true
end