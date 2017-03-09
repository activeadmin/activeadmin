apply File.expand_path("../rails_template.rb", __FILE__)

%w{Post User Category}.each do |type|
  generate :'active_admin:resource', type
end

inject_into_file 'app/admin/category.rb', <<-RUBY, after: "ActiveAdmin.register Category do\n"

  permit_params [:name, :description]
RUBY

inject_into_file 'app/admin/user.rb', <<-RUBY, after: "ActiveAdmin.register User do\n"

  permit_params [:first_name, :last_name, :username, :age]
RUBY

inject_into_file 'app/admin/post.rb', <<-RUBY, after: "ActiveAdmin.register Post do\n"

  permit_params [:custom_category_id, :author_id, :title, :body, :published_date, :position, :starred]

  scope :all, default: true

  scope :drafts do |posts|
    posts.where(["published_date IS NULL"])
  end

  scope :scheduled do |posts|
    posts.where(["posts.published_date IS NOT NULL AND posts.published_date > ?", Time.now.utc])
  end

  scope :published do |posts|
    posts.where(["posts.published_date IS NOT NULL AND posts.published_date < ?", Time.now.utc])
  end

  scope :my_posts do |posts|
    posts.where(author_id: current_admin_user.id)
  end
RUBY

append_file "db/seeds.rb", "\n\n" + <<-RUBY.strip_heredoc
  users = ["Jimi Hendrix", "Jimmy Page", "Yngwie Malmsteen", "Eric Clapton", "Kirk Hammett"].collect do |name|
    first, last = name.split(" ")
    User.create!  first_name: first,
                  last_name: last,
                  username: [first,last].join('-').downcase,
                  age: rand(80)
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
RUBY

rake 'db:seed'
