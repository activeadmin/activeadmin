#!/bin/bash --login

# Some rvm Ruby versions do not match the RUBY_VERSION global variable, so we have to convert.
# Left side rvm ruby version : Right side RUBY_VERSION global variable from within Ruby.
ARRAY=( "ruby-2.1.5:2.1.5"
        "ruby-2.2.3:2.2.3"
        "jruby-9.0.1.0:2.2.2" )

declare ruby_version

lookup_ruby_version() {
  for rvm_ruby_map_tuple in "${ARRAY[@]}" ; do
     rvm_ruby_version="${rvm_ruby_map_tuple%%:*}"
     ruby_version_global="${rvm_ruby_map_tuple##*:}"
     # printf "%s is equal to a RUBY_VERSION of %s.\n" "$rvm_ruby_version" "$ruby_version_global"
     if [[ "$rvm_ruby_version" == $1 ]]
     then
       ruby_version="$ruby_version_global"
     fi
  done
}

gem_installed() {
  num=$(gem list $1 | grep -e "^$1 " | wc -l)
  if [ $num -eq "1" ]; then
    echo "already installed $1"
  else
    echo "installing $1"
    gem install $1
  fi
  return 0
}

run_all_tests_for_rails_version() {
  gemfile_location="gemfiles/Gemfile.rails-$2"
  rm -rf $gemfile_location.lock
  echo "rvm use $1@activeadmin-$2"
  rvm use $1@activeadmin-$2 --create
  gem_installed "bundler"
  echo "BUNDLE_GEMFILE=$gemfile_location bundle update --quiet"
  BUNDLE_GEMFILE=$gemfile_location bundle update --quiet
  # The files created vary depending on version of Ruby (e.g. JRuby uses different database adapters)
  # TODO: Once we add specs to test against the various DB adapters we can namespace that as well
  lookup_ruby_version $1
  rails_dir="spec/rails/ruby-$ruby_version-rails-$2"
  if test -d $rails_dir; then
    echo "test app $rails_dir already exists; skipping"
  else
    echo "BUNDLE_GEMFILE=$gemfile_location bundle exec rake setup"
    BUNDLE_GEMFILE=$gemfile_location bundle exec rake setup
  fi
  echo "NOCOVER=true BUNDLE_GEMFILE=$gemfile_location bundle exec rspec spec --format progress"
  NOCOVER=true BUNDLE_GEMFILE=$gemfile_location bundle exec rspec spec --require support/concise_formatter.rb --format ConciseFormatter
  echo "NOCOVER=true BUNDLE_GEMFILE=$gemfile_location bundle exec cucumber features --format progress"
  NOCOVER=true BUNDLE_GEMFILE=$gemfile_location bundle exec cucumber features --format progress
  echo "NOCOVER=true BUNDLE_GEMFILE=$gemfile_location bundle exec cucumber -p class-reloading features --format progress"
  NOCOVER=true BUNDLE_GEMFILE=$gemfile_location bundle exec cucumber -p class-reloading features --format progress
  Count=$(( $Count + 1 ))
}

run_suite_for_interpreter() {
  Count=0
  while [ "x${COMPATIBLE_VERSIONS[Count]}" != "x" ]
  do
    rails_version=${COMPATIBLE_VERSIONS[Count]}
    run_all_tests_for_rails_version $1 $rails_version
  done
}

COMPATIBLE_VERSIONS=(3.2.x 4.1.x 4.2.x)
run_suite_for_interpreter ruby-2.1.5
run_suite_for_interpreter ruby-2.2.3
run_suite_for_interpreter jruby-9.0.1.0
