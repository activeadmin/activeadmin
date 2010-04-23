require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ActiveAdminIntegrationSpecHelper

describe Admin::PostsController, :type => :controller do

	integrate_views
	
	describe "GET #index" do
		before(:each) do
			include ActiveAdminIntegrationSpecHelper
			@post = Post.create(:title => "Hello World")
		end
		it "should render a table with default headers" do
			get :index
			response.should have_tag("th", "Title")
		end
	end

end

