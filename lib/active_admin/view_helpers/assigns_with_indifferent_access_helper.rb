module AssignsWithIndifferentAccessHelper

  def assigns
    @assigns_with_indifferent_access_helper ||= HashWithIndifferentAccess.new(super)
  end

end
