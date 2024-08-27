# frozen_string_literal: true
apply File.expand_path("rails_template.rb", __dir__)

inject_into_file "config/initializers/active_admin.rb", <<-RUBY, after: "ActiveAdmin.setup do |config|"

  config.comments_menu = { parent: 'Administrative' }
RUBY

inject_into_file "app/admin/admin_users.rb", <<-RUBY, after: "ActiveAdmin.register AdminUser do"

  menu parent: "Administrative", priority: 1
RUBY

directory File.expand_path("templates_with_data/admin", __dir__), "app/admin"

append_file "db/seeds.rb", "\n\n" + <<~RUBY
  texts = [
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    "Sed metus lacus, sagittis et feugiat a, vestibulum non risus.",
    "Vestibulum eu eleifend orci, eget ornare velit.",
    "Proin rhoncus velit imperdiet sapien iaculis tempor.",
    "Morbi a semper justo.",
    "Donec at sagittis nunc.",
    "Proin vitae accumsan elit, ut tincidunt tellus.",
    "Interdum et malesuada fames ac ante ipsum primis in faucibus.",
    "Morbi suscipit ex quis est tincidunt ultrices. Integer blandit scelerisque nisi.",
    "Aenean lacinia molestie maximus.",
    "Mauris blandit sem nec nisl sollicitudin scelerisque.",
    "Praesent ac nisi eu dui consectetur aliquet vitae ac ante.",
    "Vivamus vel arcu eget lacus luctus tempus."
  ]

  user_data = ["Jimi Hendrix", "Jimmy Page", "Yngwie Malmsteen", "Eric Clapton", "Kirk Hammett"].map do |name|
    first, last = name.split(" ")
    {
      first_name: first,
      last_name: last,
      username: name.downcase.gsub(" ", ""),
      age: rand(80),
      encrypted_password: SecureRandom.hex
    }
  end
  User.insert_all(user_data)
  user_ids = User.pluck(:id)

  category_data = ["Rock", "Pop Rock", "Alt-Country", "Blues", "Dub-Step"].map { |i| { name: i } }
  Category.insert_all(category_data)
  category_ids = Category.pluck(:id)

  tag_data = ["Amy Winehouse", "Guitar", "Genius Oddities", "Music Culture"].map { |i| { name: i } }
  Tag.insert_all(tag_data)
  tag_ids = Tag.pluck(:id)

  published_at_values = [5.days.ago, 1.day.ago, nil, 3.days.from_now]

  post_data = Array.new(800) do |i|
    user_id = user_ids[i % user_ids.size]
    category_id = category_ids[i % category_ids.size]
    published = published_at_values[i % published_at_values.size]
    {
      title: "Blog Post \#{i}",
      body: texts.shuffle.slice(0, rand(1..texts.size)).join(" "),
      custom_category_id: category_id,
      published_date: published,
      author_id: user_id,
      starred: true
    }
  end
  Post.insert_all(post_data)
  post_ids = Post.pluck(:id)

  tagging_data = post_ids.select { rand > 0.4 }.map do |id|
    {
      tag_id: tag_ids.sample,
      post_id: id
    }
  end
  Tagging.insert_all(tagging_data)

  admin_user_id = AdminUser.first.id
  comment_data = Array.new(800) do |i|
    {
      namespace: :admin,
      author_type: "AdminUser",
      author_id: admin_user_id,
      body: texts.shuffle.slice(0, rand(1..texts.size)).join(" "),
      resource_type: "Category",
      resource_id: category_ids.sample
    }
  end
  ActiveAdmin::Comment.insert_all(comment_data)
RUBY

rails_command "db:seed"
