module Admin::SkinsHelper

  def really_humanize the_attribute
    case the_attribute
      when 'tax_popup_logo' ; 'Logo'
      when 'purchase_background' ; 'Purchase Page'
      when 'watch_background' ; 'Player Page'
      when 'player_background' ; 'Pre-Roll Image'
      when 'tax_popup_icon' ; '150x Icon'
      when 'facebook_dialog_icon' ; '75x Icon'
      else
        the_attribute.humanize.titlecase
    end
  end
end
