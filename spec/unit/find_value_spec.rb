require 'rails_helper'
require 'active_admin/view_helpers/display_helper'

RSpec.describe "#find_value" do
  let(:view_klass) do
    Class.new(ActionView::Base) do
      include ActiveAdmin::ViewHelpers
    end
  end
  let(:view) { mock_action_view(view_klass) }
  let(:found_value) { view.find_value(resource, attr) }

  context "when given a proc" do
    let(:resource) { "bar" }
    let(:attr) { ->(resource) { "foo#{resource}" } }

    it "calls the proc" do
      expect(attr).to receive(:call).with(resource).and_call_original
      expect(found_value).to eq("foobar")
    end
  end

  shared_examples_for "an object that can have values found" do
    shared_examples_for "a time-ish attribute" do
      let(:attr) { "#{attr_base}_during_dst".to_sym }
      let(:expected_value) { resource_value.utc }

      it "converts it to the default display_timezone" do
        expect(found_value).to eq(resource_value.utc)
        expect(found_value.zone).to eq("UTC")
      end

      context "with a custom display_timezone" do
        around do |example|
          previous_display_timezone = ActiveAdmin.application.display_timezone
          ActiveAdmin.application.display_timezone = "America/New_York"
          example.call
          ActiveAdmin.application.display_timezone = previous_display_timezone
        end

        context "when the date is during Daylight Savings Time" do
          let(:attr) { "#{attr_base}_during_dst".to_sym }

          it "converts it to the custom timezone" do
            expect(found_value.year).to eq(2019)
            expect(found_value.month).to eq(5)
            expect(found_value.mday).to eq(1)
            expect(found_value.hour).to eq(14)
            expect(found_value.min).to eq(30)
            expect(found_value.sec).to eq(0)
            expect(found_value.zone).to eq("EDT")
          end
        end

        context "when the date is not during Daylight Savings Time" do
          let(:attr) { "#{attr_base}_not_during_dst".to_sym }

          it "converts it to the custom timezone" do
            expect(found_value.year).to eq(2019)
            expect(found_value.month).to eq(12)
            expect(found_value.mday).to eq(1)
            expect(found_value.hour).to eq(14)
            expect(found_value.min).to eq(30)
            expect(found_value.sec).to eq(0)
            expect(found_value.zone).to eq("EST")
          end
        end
      end
    end

    context "when the attribute's value is a Time" do
      let(:attr_base) { :time }

      it_behaves_like "a time-ish attribute"
    end

    context "when the value is a DateTime" do
      let(:attr_base) { :datetime }

      it_behaves_like "a time-ish attribute"
    end

    context "when the value is a string" do
      let(:attr) { :string }

      it "returns that value, unmodified" do
        expect(found_value).to eq("foobar")
      end
    end
  end

  context "when given an object that responds to the attribute" do
    let(:resource_class) do
      Class.new do
        def time_during_dst
          Time.new(2019, 5, 1, 11, 30, 0, "-07:00")
        end

        def time_not_during_dst
          Time.new(2019, 12, 1, 11, 30, 0, "-08:00")
        end

        def datetime_during_dst
          DateTime.new(2019, 5, 1, 11, 30, 0, "-07:00")
        end

        def datetime_not_during_dst
          DateTime.new(2019, 12, 1, 11, 30, 0, "-08:00")
        end

        def string
          "foobar"
        end
      end
    end
    let(:resource) { resource_class.new }
    let(:resource_value) { resource.send(attr) }

    it_behaves_like "an object that can have values found"
  end

  context "when given an object that responds to :[]" do
    let(:resource) do
      {
        time_during_dst: Time.new(2019, 5, 1, 11, 30, 0, "-07:00"),
        time_not_during_dst: Time.new(2019, 12, 1, 11, 30, 0, "-08:00"),
        datetime_during_dst: DateTime.new(2019, 5, 1, 11, 30, 0, "-07:00"),
        datetime_not_during_dst: DateTime.new(2019, 12, 1, 11, 30, 0, "-08:00"),
        string: "foobar"
      }
    end
    let(:resource_value) { resource[attr] }

    it_behaves_like "an object that can have values found"
  end
end
