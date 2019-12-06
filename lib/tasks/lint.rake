desc "Run govuk-lint with similar params to CI"
task lint: :environment do
  sh "rubocop --parallel Gemfile app lib test"
  sh "scss-lint app"
end
