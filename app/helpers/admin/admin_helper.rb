module Admin::AdminHelper

  def breadcrumbs(*parts)
    separator = "&#8250;"
    crumbs = parts.map do |part|
      crumb_for(part)
    end.join(' ' + separator + ' ')

    "#{separator} #{crumbs}"
  end

  def tab_active?(controller_action, kind)
    active = controller_action =~ /#{kind}/i ? 'tabOn' : ''
    active = '' if kind == 'movie' && (controller_action =~ /promotion|skin|comments|preview/i)
    active = 'tabOn' if kind == 'promotion' && controller_action =~ /coupon/i
    active
  end

  private

  def crumb_for(part)
    part.is_a?(String) ? part : link_to(part[0], part[1])
  end
end