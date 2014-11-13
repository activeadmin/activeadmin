ActiveAdmin.register_page "Icons", namespace: ActiveAdmin.application.infopage_namespace do
  content do
    ul do
      ActiveAdmin::Iconic::ICONS.keys.each do |key|
        li do
          span do
            ActiveAdmin::Iconic.icon key, width: 50, height: 50
          end
          span do
            key
          end
        end
      end
    end
  end
end if ActiveAdmin.application.use_infopage?
