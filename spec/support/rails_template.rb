# Rails template to build the sample app for specs
generate :model, "post title:string body:text published_at:datetime author_id:integer"
inject_into_file 'app/models/post.rb', "  belongs_to :author, :class_name => 'User'\n  accepts_nested_attributes_for :author\n", :after => "class Post < ActiveRecord::Base\n"
generate :model, "user first_name:string last_name:string username:string"
inject_into_file 'app/models/user.rb', "  has_many :posts, :foreign_key => 'author_id'\n", :after => "class User < ActiveRecord::Base\n"
generate :model, 'category name:string'

run "rm Gemfile"
run "rm -r test"
run "rm -r spec"

rake "db:migrate"
rake "db:test:prepare"

# Install ActiveAdmin
# This should happen last so that we don't have to worry about the
# rake's blowing up due to not having active admin in their load paths
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
generate :'active_admin:install'
