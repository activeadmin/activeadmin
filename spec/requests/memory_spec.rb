require 'rails_helper'

RSpec.describe "Memory Leak", type: :request, if: RUBY_ENGINE == 'ruby' do
  before do
    load_defaults!
  end

  def count_instances_of(klass)
    ObjectSpace.each_object(klass) { }
  end

  [ActiveAdmin::Namespace, ActiveAdmin::Resource].each do |klass|
    it "should not leak #{klass}" do
      previously_disabled = GC.enable
      GC.start
      count = count_instances_of(klass)

      load_defaults!

      GC.start
      GC.disable if previously_disabled
      expect(count_instances_of klass).to be <= count
    end
  end
end
