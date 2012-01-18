class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :validate_geo_restriction


  def paypal_tax_format_for(tax)
    (tax.to_f * 100).to_i
  end

  def change_to_https(url)
    url.sub('http', 'https')
  end

  def browser_ie_less_than_9
    request.env['HTTP_USER_AGENT'] =~ /MSIE 8/ || request.env['HTTP_USER_AGENT'] =~ /MSIE 7/ ? "true" : "false"
  end

  protected

  def validate_geo_restriction
    @studio_id = params[:studio_id].nil? ? params[:id] : params[:studio_id]
    studio = Studio.find(@studio_id)
    remote_country_code = country_code_for_ip
    unless studio.white_listed_country_codes.blank?
      white_list = studio.white_listed_country_codes.split(",")
      unless white_list.include? remote_country_code
        redirect_to('/geo_restricted_content.html')
      end
    else
      unless studio.black_listed_country_codes.blank?
        black_list = studio.black_listed_country_codes.split(",")
        if black_list.include? remote_country_code
          redirect_to('/geo_restricted_content.html')
        end
      end
    end
  end

  def country_code_for_ip
    return "US" if ["0.0.0.0", "127.0.0.1"].include?(request.remote_ip)
    GeoIP.new(File.expand_path("db/GeoIP.dat", Rails.root)).country(request.remote_ip).try(:country_code2)
  end

  def load_facebook_user
    if using_fake_facebook_user?
      @facebook_user = User.find_or_create_by_facebook_user_id(params['fb_user'])
    else
      @facebook_user = User.find_or_create_from_fb_graph(facebook)
    end
  end

  def facebook
    raise "trying to access real facebook with fake user" if using_fake_facebook_user?
    @studio ||= Studio.find(params[:studio_id])

    @facebook ||= FbGraph::Auth.new(@studio.facebook_app_id,
                                    @studio.facebook_app_secret,
                                    :signed_request => params['signed_request'])
  end

  def using_fake_facebook_user?
    params['fb_user'].present? && (Rails.env.development? || Rails.env.test?)
  end

  def render_csv csv_string, the_type = "Orders"
    # send it to the browsah
    send_data csv_string,
              :type => 'text/csv; charset=iso-8859-1; header=present',
              :disposition => "attachment, :filename => '#{the_type + "_" + Time.now.strftime("%m-%d-%y")}.csv'"
  end

end

