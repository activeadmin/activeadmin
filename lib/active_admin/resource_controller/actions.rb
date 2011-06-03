module ActiveAdmin
  class ResourceController < ::InheritedResources::Base

    # Override the InheritedResources actions to use the
    # Active Admin templates.
    #
    # We ensure that the functionality provided by Inherited
    # Resources is still available within any ResourceController

    def index(options={}, &block)
      super(options) do |format|
        block.call(format) if block
        format.html { render active_admin_template('index.html.arb') }
        format.csv  { render active_admin_template('index.csv.erb') }
      end
    end
    alias :index! :index

    def show(options={}, &block)
      super do |format|
        block.call(format) if block
        format.html { render active_admin_template('show.html.arb') }
      end
    end
    alias :show! :show

    def new(options={}, &block)
      super do |format|
        block.call(format) if block
        format.html { render active_admin_template('new.html.arb') }
      end
    end
    alias :new! :new

    def edit(options={}, &block)
      super do |format|
        block.call(format) if block
        format.html { render active_admin_template('edit.html.arb') }
      end
    end
    alias :edit! :edit

    def create(options={}, &block)
      super(options) do |success, failure|
        block.call(success, failure) if block
        failure.html { render active_admin_template('new.html.arb') }
      end
    end
    alias :create! :create

    def update(options={}, &block)
      super do |success, failure|
        block.call(success, failure) if block
        failure.html { render active_admin_template('edit.html.arb') }
      end
    end
    alias :update! :update

    # Make aliases protected
    protected :index!, :show!, :new!, :create!, :edit!, :update!

    protected

    # Returns the full location to the Active Admin template path
    def active_admin_template(template)
      "active_admin/resource/#{template}"
    end

  end
end
