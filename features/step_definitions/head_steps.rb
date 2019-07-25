Around '@head' do |scenario, block|
  previous_head = ActiveAdmin.application.head

  begin
    block.call
  ensure
    ActiveAdmin.application.head = previous_head
  end
end
