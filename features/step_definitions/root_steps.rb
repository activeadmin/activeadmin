Around '@root' do |scenario, block|
  previous_root = ActiveAdmin.application.root_to

  begin
    block.call
  ensure
    ActiveAdmin.application.root_to = previous_root
  end
end
