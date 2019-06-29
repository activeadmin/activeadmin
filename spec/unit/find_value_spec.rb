require 'rails_helper'
require 'active_admin/view_helpers/display_helper'

RSpec.describe "#find_value" do
  include ActiveSupport::Testing::TimeHelpers
  let(:view_klass) do
    Class.new(ActionView::Base) do
      include ActiveAdmin::ViewHelpers
    end
  end
  let(:view) { mock_action_view(view_klass) }
  let(:attr) { :datetime }
  subject { view.find_value(resource, attr) }

  context "when given an object that responds to the attr" do
    let(:resource_class) do
      Class.new do
        def time
          Time.new(2019, 5, 1, 11, 30, 0, "-07:00")
        end

        def datetime
          DateTime.new(2019, 5, 1, 11, 30, 0, "-07:00")
        end
      end
    end
    let(:resource) { resource_class.new }
    let(:resource_value) { resource.send(attr) }

    context "when the value is a Time" do
      let(:attr) { :time }
      let(:expected_value) { resource_value.utc }

      it "converts it to the default display_timezone" do
        is_expected.to eq(resource_value.utc)
      end

      context "with a custom display_timezone" do
        around do |example|
          previous_display_timezone = ActiveAdmin.application.display_timezone
          ActiveAdmin.application.display_timezone = "America/New_York"
          example.call
          ActiveAdmin.application.display_timezone = previous_display_timezone
        end

        context "when the date is during Daylight Savings Time" do
          let(:resource_class) do
            Class.new do
              def time
                Time.new(2019, 5, 1, 11, 30, 0, "-07:00")
              end

              def datetime
                DateTime.new(2019, 5, 1, 11, 30, 0, "-07:00")
              end
            end
          end
          let(:expected_value) { Time.new(2019, 5, 1, 14, 30, 0, "-04:00") }

          it "converts it to the custom timezone" do
            is_expected.to eq(expected_value)
            expect(subject.zone).to eq("EDT")
          end
        end

        context "when the date is not during Daylight Savings Time" do
          let(:resource_class) do
            Class.new do
              def time
                Time.new(2019, 12, 1, 11, 30, 0, "-08:00")
              end

              def datetime
                DateTime.new(2019, 12, 1, 11, 30, 0, "-08:00")
              end
            end
          end
          let(:expected_value) { Time.new(2019, 12, 1, 14, 30, 0, "-05:00") }

          it "converts it to the custom timezone" do
            is_expected.to eq(expected_value)
            expect(subject.zone).to eq("EST")
          end
        end
      end
    end

    # context "when the value is a DateTime" do
    #   let(:attr) { :datetime }

    #   it_behaves_like "a time-ish object"
    # end

    # TODO: When the value is something else
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
