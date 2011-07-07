# Add collection and member actions

## Add Custom Collection Action

To add a collection action, use the collection_action method:

  collection_action :import_csv do
    # do csv import
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end

## Add Custom Member Action

To add a member action, use the member_action method:

  member_action :lock, :method => :post do
    resource.lock!
    redirect_to :action => :show, :notice => "Locked!"
  end
