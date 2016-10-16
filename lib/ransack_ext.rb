# This sets up aliases for old Metasearch query methods so they behave
# identically to the versions given in Ransack.
#
Ransack.configure do |config|
  [nil, "not_"].each do |negator|
    { "#{negator}contains" => "#{negator}cont", "#{negator}starts_with" => "#{negator}start", "#{negator}ends_with" => "#{negator}end" }.each do |old, current|
      config.add_predicate old, Ransack::Constants::DERIVED_PREDICATES.detect{ |q, _| q == current }[1]
    end
    config.add_predicate "#{negator}equals", arel_predicate: "#{negator}eq"
  end

  { "greater_than" => "gt", "less_than" => "lt" }.each do |old, current|
    config.add_predicate old, arel_predicate: current
  end

  config.add_predicate 'gteq_date',
    arel_predicate: 'gteq',
    formatter: ->(v) { v.beginning_of_day }

  config.add_predicate 'lteq_date',
  	arel_predicate: 'lt',
  	formatter: ->(v) { v + 1.day }
end
