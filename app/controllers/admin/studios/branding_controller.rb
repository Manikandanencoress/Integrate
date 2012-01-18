class Admin::Studios::BrandingController < AdminController
  inherit_resources
  actions :show, :update, :edit
  belongs_to :studio, :singleton => true
  load_and_authorize_resource :studio
end