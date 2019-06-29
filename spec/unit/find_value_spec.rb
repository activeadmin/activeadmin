require 'rails_helper'
require 'active_admin/view_helpers/display_helper'

RSpec.describe "#find_value" do
  let(:view_klass) do
    Class.new(ActionView::Base) do
      include ActiveAdmin::ViewHelpers
    end
  end
  let(:view) { mock_action_view(view_klass) }
  let(:resource) { resource_class.new }
  let(:found_value) { view.find_value(resource, attr) }

  context "when given an object that responds to the attr" do
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
    let(:resource_value) { resource.send(attr) }

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

  # TODO:
  # context "When given an object that responds to :[]" do
  #   it "when the value is a Time" do
  #     it_behaves_like "a time-ish object"
  #   end
  #   it "when the value is a DateTime" do
  #     it_behaves_like "a time-ish object"
  #   end
  # end
end
