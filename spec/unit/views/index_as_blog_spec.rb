require 'rails_helper'

include ActiveAdmin
RSpec.describe ActiveAdmin::Views::IndexAsBlog do
  subject { described_class.new }

  describe '#build' do
    let(:page_presenter) { double('page_presenter', block: nil) }
    let(:collection) { double('collection') }

    before do
      expect(subject).to receive('build_posts')
      expect(subject).to receive('add_class').with('index')
    end

    context 'when page_presenter has no block' do
      before do
        subject.build(page_presenter, collection)
      end

      it do
        expect(subject.instance_variable_get(:@page_presenter))
          .to eq(page_presenter)
        expect(subject.instance_variable_get(:@collection)).to eq(collection)
      end
    end

    context 'when page_presenter has block' do
      let(:block) { Proc.new { double('proc_method') } }

      before do
        allow(page_presenter).to receive(:block).and_return(block)
        allow(subject).to receive('instance_exec')
        subject.build(page_presenter, collection)
      end

      it do
        expect(subject).to have_received('instance_exec')
      end
    end
  end

  %w(title body).each do |method|
    describe "#{method}" do
      context 'when block given' do
        let(:block_result) { double('block_result') }

        it "should use the block to set the #{method}" do
          expect(
            subject.public_send("#{method}") do
              block_result
            end.yield
          ).to eq(block_result)
        end
      end

      context 'when no block and method given' do
        let(:method) { double('method') }

        it "should use method to set the #{method}" do
          expect(subject.public_send("#{method}", method)).to eq(method)
        end
      end

      context 'when no block and no method given' do
        it 'should be nil' do
          expect(subject.public_send("#{method}")).to eq(nil)
        end
      end
    end
  end

  describe '.index_name' do
    it { expect(described_class.index_name).to eq('blog') }
  end
end
