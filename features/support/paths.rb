module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #

  def signed_request_for(user)
    FacebookAuthenticationFaker.authed_facebook_signed_request('user_id' => user.facebook_user_id)
  end

  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /the login page/
      new_admin_session_path

    when /the "(.*)" page/
      movie = Movie.find_by_title($1)
      raise "No Movie Found" unless movie
      studio_movie_path(movie.studio, movie)

    when /the "(.*)" gallery$/
      studio = Studio.find_by_name!($1)
      studio_movies_path(studio)

    when /the "(.*)" gallery as "(.*)"/
      studio = Studio.find_by_name!($1)
      user = User.find_by_name!($2)
      studio_movies_path(studio, :signed_request => signed_request_for(user))

    when /the admin movies page for "(.*)"/
      studio = Studio.find_by_name($1)
      raise %{No Studio found for "#{$1}"} unless studio
      admin_studio_movies_url(studio, :protocol => 'https://')

    when /the admin orders page for "(.*)"/
      movie = Movie.find_by_title($1)
      raise %{No Movie found for "#{$1}"} unless movie
      admin_studio_movie_orders_url(movie.studio, movie, :protocol => 'https://')

    when /the admin movie report page for "(.*)"/
      movie = Movie.find_by_title($1)
      raise %{No Movie found for "#{$1}"} unless movie
      admin_studio_movie_report_path(movie.studio, movie)

    when /the admin studio movies report page for "(.*)"/
      studio = Studio.find_by_name($1)
      raise %{No studio found for "#{$1}"} unless studio
      admin_studio_reports_movies_path(studio)

    when /the (\w+|)\s?(admin|)\s?studio (\w+|)\s?page for "(.*)"/
      action, admin, resource, name = $1, $2, $3, $4
      studio = Studio.find_by_name(name)
      raise %{No Studio found for "#{name}"} unless studio

      path = [action, admin, "studio", resource, "url"].select(&:present?).map(&:split).flatten.join("_")
      self.send(path, studio, {:protocol => 'https://'})

      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #   when /^(.*)'s profile page$/i
      #     user_profile_path(User.find_by_login($1))

    when /the link in the invitation email to "([^\"]*)"/
      invitation = Invitation.find_by_email($1)
      self.extend(InvitationHelper)
      redeem_invitation_url(invitation)

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        if path_components.include? "admin"
          self.send(path_components.push('url').join('_').to_sym, :protocol => "https://")
        else
          self.send(path_components.push('path').join('_').to_sym)
        end

      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
                  "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
