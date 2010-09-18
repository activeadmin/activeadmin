require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActiveAdmin, "Routing" do
  
  subject { Admin::PostsController.new }

  it { should respond_to(:admin_posts_path) }
  it { should respond_to(:admin_post_path) }
  it { should respond_to(:new_admin_post_path) }
  it { should respond_to(:edit_admin_post_path) }
  it { should respond_to(:admin_admin_comments_path) }

end
