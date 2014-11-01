require 'rails_helper'

<<<<<<< HEAD:spec/requests/memory_spec.rb
describe "Memory Leak", :type => :request do
=======
describe "Memory Leak" do
  JRuby.objectspace = true if RUBY_ENGINE =~ /jruby/
>>>>>>> test against JRuby and Rubinius:spec/integration/memory_spec.rb

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
