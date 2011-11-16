shared_examples_for "ActiveAdmin::Config" do
  describe "namespace" do
    it "should return the namespace" do
      config.namespace.should == namespace
    end
  end

  it { respond_to :belongs_to? }

  it { respond_to :controller_name }
  it { respond_to :controller }
  it { respond_to :route_prefix }
  it { respond_to :route_collection_path }

end
