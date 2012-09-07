module AssignsWithIndifferentAccessHelper

  def assigns
    @assigns_with_indifferent_access_helper ||= HashWithIndifferentAccess.new(super)
  end

  # directly accessing assigns in view
  def method_missing(name, *args, &block)
    if assigns && assigns.has_key?(name)
      assigns[name]
    else
      super
    end
  end

end
