class Skin < ActiveRecord::Base
  belongs_to :movie

  PICTURES = {
      :tax_popup_logo => "275x170",
      :splash_image => "520x470",
      :purchase_background => "740x1120",
      :watch_background => "740x1120",
      :player_background => "703x375",
      :tax_popup_icon => "170x150",
      :facebook_dialog_icon => "75x75",
      :gallery_poster => "94x136"
  }

  @@paperclip_defaults = {
      :storage => Sumuru::Application.config.paperclip_storage_type,
      :s3_credentials => "#{Rails.root}/config/s3.yml",
      :default_style => :fullsize,
      :s3_protocol => :https
  }


  PICTURES.each do |attachment, dimensions|
    styles = {:styles => {:thumb => "150x150>", :fullsize => "#{dimensions}>" }}
    has_attached_file attachment, @@paperclip_defaults.merge(styles)
  end

  def as_json(options={})
    {
        :poster => player_background.url,
        :thumb_popup_image => tax_popup_icon.url,
        :logo_popup_image => tax_popup_logo.url,
        :feed_dialog_image => facebook_dialog_icon.url
    }
  end

  def complete?
    # testing existence of attachments using *_file_name,
    # as #exists? and such do blocking s3 callouts
    [
        tax_popup_icon_file_name,
        tax_popup_logo_file_name,
        splash_image_file_name,
        purchase_background_file_name,
        watch_background_file_name,
        player_background_file_name,
        facebook_dialog_icon_file_name,
        gallery_poster_file_name
    ].all?
  end
end