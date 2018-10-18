require 'rails_helper'

RSpec.describe ActiveAdmin::Views::StatusTag do

  describe "#status_tag" do

    # Helper method to build StatusTag objects in an Arbre context
    def status_tag(*args)
      render_arbre_component(status_tag_args: args) do
        status_tag(*assigns[:status_tag_args])
      end
    end

    subject { status_tag(nil) }

    describe '#tag_name' do
      subject { super().tag_name }
      it      { is_expected.to eq 'span' }
    end

    describe '#class_list' do
      subject { super().class_list }
      it      { is_expected.to include('status_tag') }
    end

    context "when status is 'completed'" do
      subject { status_tag('completed') }

      describe '#tag_name' do
        subject { super().tag_name }
        it      { is_expected.to eq 'span' }
      end

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('status_tag') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('completed') }
      end

      describe '#content' do
        subject { super().content }
        it      { is_expected.to eq 'Completed' }
      end
    end

    context "when status is 'in_progress'" do
      subject { status_tag('in_progress') }

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('in_progress') }
      end

      describe '#content' do
        subject { super().content }
        it      { is_expected.to eq 'In Progress' }
      end
    end

    context "when status is 'In progress'" do
      subject { status_tag('In progress') }

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('in_progress') }
      end

      describe '#content' do
        subject { super().content }
        it      { is_expected.to eq 'In Progress' }
      end
    end

    context "when status is an empty string" do
      subject { status_tag('') }

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('status_tag') }
      end

      describe '#content' do
        subject { super().content }
        it      { is_expected.to eq '' }
      end
    end

    context "when status is 'false'" do
      subject { status_tag('false') }

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('status_tag') }
      end

      describe '#content' do
        subject { super().content }
        it      { is_expected.to eq('No') }
      end
    end

    context "when status is false" do
      subject { status_tag(false) }

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('status_tag') }
      end

      describe '#content' do
        subject { super().content }
        it      { is_expected.to eq('No') }
      end
    end

    context "when status is nil" do
      subject { status_tag(nil) }

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('status_tag') }
      end

      describe '#content' do
        subject { super().content }
        it      { is_expected.to eq('No') }
      end
    end

    context "when status is 'Active' and type is :ok" do
      subject { status_tag('Active', :ok) }

      describe 'is deprecated' do
        subject { super().class_list }
        it do
          expect(ActiveAdmin::Deprecation)
            .to receive(:warn)
            .with(<<-MSG.strip_heredoc
              The `type` parameter has been deprecated. Provide the "ok" type as
              a class instead. For example, `status_tag(status, :ok, class: "abc")`
              would change to `status_tag(status, class: "ok abc")`. Also note that
              the "ok" CSS rule will be removed too, so you'll have to provide
              the styles yourself. See https://github.com/activeadmin/activeadmin/blob/master/CHANGELOG.md#110-
              for more information.
            MSG
            )
          is_expected.to include('ok')
        end
      end

      describe '#class_list' do
        before  { expect(ActiveAdmin::Deprecation).to receive(:warn).once }
        subject { super().class_list }
        it      { is_expected.to include('status_tag') }
      end

      describe '#class_list' do
        before  { expect(ActiveAdmin::Deprecation).to receive(:warn).once }
        subject { super().class_list }
        it      { is_expected.to include('active') }
      end

      describe '#class_list' do
        before  { expect(ActiveAdmin::Deprecation).to receive(:warn).once }
        subject { super().class_list }
        it      { is_expected.to include('ok') }
      end
    end

    context "when status is 'Active' and class is 'ok'" do
      subject { status_tag('Active', class: 'ok') }

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('status_tag') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('active') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('ok') }
      end
    end

    context "when status is 'Active' and label is 'on'" do
      subject { status_tag('Active', label: 'on') }

      describe '#content' do
        subject { super().content }
        it      { is_expected.to eq 'on' }
      end

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('status_tag') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('active') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.not_to include('on') }
      end
    end

    context "when status is 'So useless', class is 'woot awesome' and id is 'useless'" do
      subject { status_tag('So useless', class: 'woot awesome', id: 'useless') }

      describe '#content' do
        subject { super().content }
        it      { is_expected.to eq 'So Useless' }
      end

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('status_tag') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('so_useless') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('woot') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.to include('awesome') }
      end

      describe '#id' do
        subject { super().id }
        it      { is_expected.to eq 'useless' }
      end
    end

    context "when status is set to a Fixnum" do
      subject { status_tag(42) }

      describe '#content' do
        subject { super().content }
        it      { is_expected.to eq '42' }
      end

      describe '#class_list' do
        subject { super().class_list }
        it      { is_expected.not_to include('42') }
      end
    end
  end
end
