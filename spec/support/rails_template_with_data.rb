# Use the default
apply File.expand_path("../rails_template.rb", __FILE__)

# Register Active Admin controllers
%w{ Post User Category }.each do |type|
  generate :'active_admin:resource', type
end

# Setup some default data
append_file "db/seeds.rb", <<-EOF
  users = ["Jimi Hendrix", "Jimmy Page", "Yngwie Malmsteen", "Eric Clapton", "Kirk Hammett"].collect do |name|
    first, last = name.split(" ")
    User.create!  :first_name => first,
                  :last_name => last,
                  :username => [first,last].join('-').downcase,
                  :age => rand(80)
  end

  categories = ["Rock", "Pop Rock", "Alt-Country", "Blues", "Dub-Step"].collect do |name|
    Category.create! :name => name
  end

  1_000.times do |i|
    user = users[i % users.size]
    cat = categories[i % categories.size]
    Post.create :title => "Blog Post \#{i}",
                :body => "Blog post \#{i} is written by \#{user.username} about \#{cat.name}",
                :category => cat,
                :author => user
  end
EOF

rake 'db:seed'
