module ActiveAdmin
  class ResourceController < BaseController

    # Override the InheritedResources actions to use the
    # Active Admin templates.
    #
    # We ensure that the functionality provided by Inherited
    # Resources is still available within any ResourceController

    def index(options={}, &block)
      super(options) do |format|
        block.call(format) if block
        format.html { render active_admin_template('index') }
        format.csv do
          headers['Content-Type'] = 'text/csv; charset=utf-8'
          headers['Content-Disposition'] = %{attachment; filename="#{csv_filename}"}
          render active_admin_template('index')
        end
      end
    end
    alias :index! :index

    def show(options={}, &block)
      super do |format|
        block.call(format) if block
        format.html { render active_admin_template('show') }
      end
    end
    alias :show! :show

    def new(options={}, &block)
      super do |format|
        block.call(format) if block
        format.html { render active_admin_template('new') }
      end
    end
    alias :new! :new

    def edit(options={}, &block)
      super do |format|
        block.call(format) if block
        format.html { render active_admin_template('edit') }
      end
    end
    alias :edit! :edit

    def create(options={}, &block)
      super(options) do |success, failure|
        block.call(success, failure) if block
        failure.html { render active_admin_template('new') }
      end
    end
    alias :create! :create

    def update(options={}, &block)
      super do |success, failure|
        block.call(success, failure) if block
        failure.html { render active_admin_template('edit') }
      end
    end
    alias :update! :update

    def batch_action
      if selected_batch_action
        selected_ids = params[:collection_selection]
        selected_ids ||= []
        instance_exec selected_ids, &selected_batch_action.block
      else
        raise "Couldn't find batch action \"#{params[:batch_action]}\""
      end
    end

    # Make aliases protected
    protected :index!, :show!, :new!, :create!, :edit!, :update!

    protected

    # Returns the full location to the Active Admin template path
    def active_admin_template(template)
      "active_admin/resource/#{template}"
    end

    # Returns a filename for the csv file using the collection_name
    # and current date such as 'my-articles-2011-06-24.csv'.
    def csv_filename
      "#{resource_collection_name.to_s.gsub('_', '-')}-#{Time.now.strftime("%Y-%m-%d")}.csv"
    end

    def selected_batch_action
      return unless params[:batch_action].present?
      active_admin_config.batch_actions.select { |action| action.sym == params[:batch_action].to_sym }.first
    end
  end
end
