# frozen_string_literal: true
ActiveAdmin.register_page "KitchenSink" do
  content do
    panel "About ActiveAdmin" do
      para class: "mb-4" do
        a "Active Admin", href: "https://github.com/activeadmin/activeadmin"
        text_node "is a"
        span "Ruby on Rails", class: "text-red-500"
        text_node "framework for"
        em "creating elegant backends"
        text_node "for"
        strong "website administration."
      end
      para do
        abbr "HTML", title: "HyperText Markup Language"
        text_node "is the basic building block of the Web."
      end
    end
    div class: "grid grid-cols-1 md:grid-cols-2 gap-5" do
      div do
        h3 "TableFor Example", class: "mb-4 text-base/7 font-semibold text-gray-900"
        div class: "border border-gray-200 dark:border-gray-800 rounded-md shadow-sm overflow-hidden" do
          div class: "overflow-x-auto" do
            table_for User.first(5) do
              column :id
              column :display_name, class: "min-w-40" do |user|
                auto_link user
              end
              column :username
              column :age
              column :created_at, class: "min-w-40"
              column :updated_at, class: "min-w-40"
            end
          end
        end
      end
      div do
        h3 "Attributes Table Example", class: "mb-4 text-base/7 font-semibold text-gray-900"
        attributes_table_for(Post.first) do
          row :title
          row :published_date
          row :author
          row :category
          row :starred
          row :position
        end
      end
    end
  end

  sidebar "Sample Sidebar" do
    div class: "pb-6" do
      h3 "Applicant Information", class: "text-base/7 font-semibold text-gray-900 dark:text-white"
      para "A sidebar can also be used on a custom page.", class: "mt-1 text-sm/6 text-gray-500 dark:text-gray-400"
    end
    dl do
      div class: "border-t border-gray-100 dark:border-white/10 py-4" do
        dt "Full name", class: "text-sm/6 font-medium text-gray-900 dark:text-gray-100"
        dd "Margot Foster", class: "mt-1 text-sm/6 text-gray-700 dark:text-gray-400"
      end
      div class: "border-t border-gray-100 dark:border-white/10 py-4" do
        dt "Application for", class: "text-sm/6 font-medium text-gray-900 dark:text-gray-100"
        dd "Backend Developer", class: "mt-1 text-sm/6 text-gray-700 dark:text-gray-400"
      end
      div class: "border-t border-gray-100 dark:border-white/10 py-4" do
        dt "Email address", class: "text-sm/6 font-medium text-gray-900 dark:text-gray-100"
        dd "margotfoster@example.com", class: "mt-1 text-sm/6 text-gray-700 dark:text-gray-400"
      end
      div class: "border-t border-gray-100 dark:border-white/10 py-4" do
        dt "Attachments", class: "text-sm/6 font-medium text-gray-900 dark:text-gray-100"
        dd class: "mt-1 text-sm/6 text-gray-700 dark:text-gray-400" do
          ul class: "divide-y divide-gray-100 rounded-md border border-gray-200 dark:divide-white/5 dark:border-white/10", role: "list" do
            li class: "flex items-center justify-between py-3 pl-3 pr-4 text-sm/6" do
              div class: "flex w-0 flex-1 items-center" do
                text_node '<svg viewBox="0 0 20 20" fill="currentColor" data-slot="icon" aria-hidden="true" class="size-5 shrink-0 text-gray-400 dark:text-gray-500"><path d="M15.621 4.379a3 3 0 0 0-4.242 0l-7 7a3 3 0 0 0 4.241 4.243h.001l.497-.5a.75.75 0 0 1 1.064 1.057l-.498.501-.002.002a4.5 4.5 0 0 1-6.364-6.364l7-7a4.5 4.5 0 0 1 6.368 6.36l-3.455 3.553A2.625 2.625 0 1 1 9.52 9.52l3.45-3.451a.75.75 0 1 1 1.061 1.06l-3.45 3.451a1.125 1.125 0 0 0 1.587 1.595l3.454-3.553a3 3 0 0 0 0-4.242Z" clip-rule="evenodd" fill-rule="evenodd" /></svg>'.html_safe
                div class: "ms-2 flex min-w-0 flex-1 gap-2" do
                  span class: "truncate font-medium text-gray-900 dark:text-white" do
                    "resume_back_end_developer.pdf"
                  end
                  span class: "shrink-0 text-gray-400 dark:text-gray-500" do
                    "2.4mb"
                  end
                end
              end
            end
            li class: "flex items-center justify-between py-3 pl-3 pr-4 text-sm/6" do
              div class: "flex w-0 flex-1 items-center" do
                text_node '<svg viewBox="0 0 20 20" fill="currentColor" data-slot="icon" aria-hidden="true" class="size-5 shrink-0 text-gray-400 dark:text-gray-500"><path d="M15.621 4.379a3 3 0 0 0-4.242 0l-7 7a3 3 0 0 0 4.241 4.243h.001l.497-.5a.75.75 0 0 1 1.064 1.057l-.498.501-.002.002a4.5 4.5 0 0 1-6.364-6.364l7-7a4.5 4.5 0 0 1 6.368 6.36l-3.455 3.553A2.625 2.625 0 1 1 9.52 9.52l3.45-3.451a.75.75 0 1 1 1.061 1.06l-3.45 3.451a1.125 1.125 0 0 0 1.587 1.595l3.454-3.553a3 3 0 0 0 0-4.242Z" clip-rule="evenodd" fill-rule="evenodd" /></svg>'.html_safe
                div class: "ms-2 flex min-w-0 flex-1 gap-2" do
                  span class: "truncate font-medium text-gray-900 dark:text-white" do
                    "coverletter_back_end_developer.pdf"
                  end
                  span class: "shrink-0 text-gray-400 dark:text-gray-500" do
                    "4.5mb"
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
