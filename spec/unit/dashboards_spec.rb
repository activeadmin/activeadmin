require 'spec_helper' 

describe ActiveAdmin::Dashboards do

  after(:each) do
    ActiveAdmin::Dashboards.clear_all_sections!
  end

  describe "adding sections" do
    before do
      ActiveAdmin::Dashboards.clear_all_sections!
      ActiveAdmin::Dashboards.add_section('Recent Posts')
    end
    it "should add a new section namespaced" do
      ActiveAdmin::Dashboards.sections[:admin].first.should be_an_instance_of(ActiveAdmin::Dashboards::Section)
    end
  end

  describe "adding sections using the build syntax" do
    before do
      ActiveAdmin::Dashboards.clear_all_sections!
      ActiveAdmin::Dashboards.build do
        section "Recent Posts" do
        end
      end
    end

    it "should add a new section" do
      ActiveAdmin::Dashboards.sections[:admin].first.should be_an_instance_of(ActiveAdmin::Dashboards::Section)
    end
  end

  describe "clearing all sections" do
    before do
      ActiveAdmin::Dashboards.add_section('Recent Posts')
    end
    it "should clear all sections" do
      ActiveAdmin::Dashboards.clear_all_sections!
      ActiveAdmin::Dashboards.sections.keys.should be_empty
    end
  end

  describe "finding namespaced sections" do
    context "when the namespace exists" do
      before do
        ActiveAdmin::Dashboards.add_section('Recent Posts')
      end
      it "should return an array of sections" do
        ActiveAdmin::Dashboards.sections_for_namespace(:admin).should_not be_empty
      end
    end

    context "when the namespace does not exists" do
      it "should return an empty array" do
        ActiveAdmin::Dashboards.sections_for_namespace(:not_a_namespace).should be_empty
      end
    end
  end
end
