class AddAttachmentPurchaseBackgroundWatchBackgroundSplashImageTaxPopupLogoTaxPopupIconPlayerBackgroundFacebookDialogIconToSkin < ActiveRecord::Migration
  def self.up
    add_column :skins, :purchase_background_file_name, :string
    add_column :skins, :purchase_background_content_type, :string
    add_column :skins, :purchase_background_file_size, :integer
    add_column :skins, :purchase_background_updated_at, :datetime
    add_column :skins, :watch_background_file_name, :string
    add_column :skins, :watch_background_content_type, :string
    add_column :skins, :watch_background_file_size, :integer
    add_column :skins, :watch_background_updated_at, :datetime
    add_column :skins, :splash_image_file_name, :string
    add_column :skins, :splash_image_content_type, :string
    add_column :skins, :splash_image_file_size, :integer
    add_column :skins, :splash_image_updated_at, :datetime
    add_column :skins, :tax_popup_logo_file_name, :string
    add_column :skins, :tax_popup_logo_content_type, :string
    add_column :skins, :tax_popup_logo_file_size, :integer
    add_column :skins, :tax_popup_logo_updated_at, :datetime
    add_column :skins, :tax_popup_icon_file_name, :string
    add_column :skins, :tax_popup_icon_content_type, :string
    add_column :skins, :tax_popup_icon_file_size, :integer
    add_column :skins, :tax_popup_icon_updated_at, :datetime
    add_column :skins, :player_background_file_name, :string
    add_column :skins, :player_background_content_type, :string
    add_column :skins, :player_background_file_size, :integer
    add_column :skins, :player_background_updated_at, :datetime
    add_column :skins, :facebook_dialog_icon_file_name, :string
    add_column :skins, :facebook_dialog_icon_content_type, :string
    add_column :skins, :facebook_dialog_icon_file_size, :integer
    add_column :skins, :facebook_dialog_icon_updated_at, :datetime
  end

  def self.down
    remove_column :skins, :purchase_background_file_name
    remove_column :skins, :purchase_background_content_type
    remove_column :skins, :purchase_background_file_size
    remove_column :skins, :purchase_background_updated_at
    remove_column :skins, :watch_background_file_name
    remove_column :skins, :watch_background_content_type
    remove_column :skins, :watch_background_file_size
    remove_column :skins, :watch_background_updated_at
    remove_column :skins, :splash_image_file_name
    remove_column :skins, :splash_image_content_type
    remove_column :skins, :splash_image_file_size
    remove_column :skins, :splash_image_updated_at
    remove_column :skins, :tax_popup_logo_file_name
    remove_column :skins, :tax_popup_logo_content_type
    remove_column :skins, :tax_popup_logo_file_size
    remove_column :skins, :tax_popup_logo_updated_at
    remove_column :skins, :tax_popup_icon_file_name
    remove_column :skins, :tax_popup_icon_content_type
    remove_column :skins, :tax_popup_icon_file_size
    remove_column :skins, :tax_popup_icon_updated_at
    remove_column :skins, :player_background_file_name
    remove_column :skins, :player_background_content_type
    remove_column :skins, :player_background_file_size
    remove_column :skins, :player_background_updated_at
    remove_column :skins, :facebook_dialog_icon_file_name
    remove_column :skins, :facebook_dialog_icon_content_type
    remove_column :skins, :facebook_dialog_icon_file_size
    remove_column :skins, :facebook_dialog_icon_updated_at
  end
end
