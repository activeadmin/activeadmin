apply File.expand_path('rails_template.rb', __dir__)

inject_into_file 'config/initializers/active_admin.rb', <<-RUBY, after: "ActiveAdmin.setup do |config|"

  config.comments_menu = { parent: 'Administrative' }
RUBY

inject_into_file 'app/admin/admin_users.rb', <<-RUBY, after: "ActiveAdmin.register AdminUser do"

  menu parent: "Administrative", priority: 1
RUBY

copy_file File.expand_path('templates_with_data/admin/kitchen_sink.rb', __dir__), 'app/admin/kitchen_sink.rb'

%w{posts users categories tags}.each do |resource|
  copy_file File.expand_path("templates_with_data/admin/#{resource}.rb", __dir__), "app/admin/#{resource}.rb"
end

append_file "db/seeds.rb", "\n\n" + <<-RUBY.strip_heredoc
  users = ["Jimi Hendrix", "Jimmy Page", "Yngwie Malmsteen", "Eric Clapton", "Kirk Hammett"].collect do |name|
    first, last = name.split(" ")
    User.create!  first_name: first,
                  last_name: last,
                  username: [first,last].join('-').downcase,
                  age: rand(80),
                  encrypted_password: SecureRandom.hex
  end

  categories = ["Rock", "Pop Rock", "Alt-Country", "Blues", "Dub-Step"].collect do |name|
    Category.create! name: name
  end

  published_at_values = [Time.now.utc - 5.days, Time.now.utc - 1.day, nil, Time.now.utc + 3.days]

  1_000.times do |i|
    user = users[i % users.size]
    cat = categories[i % categories.size]
    published = published_at_values[i % published_at_values.size]
    Post.create title: "Blog Post \#{i}",
                body: "Blog post \#{i} is written by \#{user.username} about \#{cat.name}",
                category: cat,
                published_date: published,
                author: user,
                starred: true
  end

  800.times do |i|
    ActiveAdmin::Comment.create!(
      namespace: :admin,
      author: AdminUser.first,
      body: "Test comment \#{i}",
      resource: categories.sample
    )
  end
RUBY

rake 'db:seed'

git add: '.'
git commit: "-m 'Bare application with data'"
