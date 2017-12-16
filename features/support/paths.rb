module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /the dashboard/
      "/admin"
    when /the new post page/
      "/admin/posts/new"
    when /the login page/
      "/admin/login"
    when /the first post custom status page/
      "/admin/posts/1/status"
    when /the last posts page/
      "/admin/last_posts"
    when /the admin password reset form with token "([^"]*)"/
      "/admin/password/edit?reset_password_token=#{$1}"

    # the index page for posts in the root namespace
    # the index page for posts in the user_admin namespace
    when /^the index page for (.*) in the (.*) namespace$/
      if $2 != 'root'
        send "#{$2}_#{$1}_path"
      else
        send "#{$1}_path"
      end

    # same as above, except defaults to admin namespace
    when /^the index page for (.*)$/
      send "admin_#{$1}_path"

    when /^the (.*) index page for (.*)$/
      send "admin_#{$2}_path", format: $1

    when /^the last author's posts$/
      admin_user_posts_path(User.last)

    when /^the last author's last post page$/
      admin_user_post_path(User.last, Post.where(author_id: User.last.id).last)

    when /^the last post's show page$/
      admin_post_path(Post.last)

    when /^the last post's edit page$/
      edit_admin_post_path(Post.last)

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send path_components.push('path').join('_')
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
