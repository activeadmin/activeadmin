module ActionPolicy
  class PostPolicy < ActionPolicy::ApplicationPolicy
    def new? = true
  
    def create? = record.category.nil? || record.category.name != "Announcements" || user.is_a?(User::VIP)
  
    def update? = author?
  end
end
