require 'spec_helper' 

module ActiveAdmin
  describe Resource, "Menu" do

    before { load_defaults! }

    let(:application){ ActiveAdmin::Application.new }
    let(:namespace){ Namespace.new(application, :admin) }

    def config(options = {})
      @config ||= Resource.new(namespace, Category, options)
    end

    describe "#include_in_menu?" do
      let(:namespace){ ActiveAdmin::Namespace.new(application, :admin) }
      subject{ resource }

      context "when belongs to" do
        let(:resource){ namespace.register(Post){ belongs_to :author } }
        it { should_not be_include_in_menu }
      end

      context "when belongs to optional" do
        let(:resource){ namespace.register(Post){ belongs_to :author, :optional => true} }
        it { should be_include_in_menu }
      end
    end
  end
end
