desc "Run govuk-lint with similar params to CI"
task "lint" do
  sh "govuk-lint-ruby --parallel Gemfile app lib test"
  sh "govuk-lint-sass app"
end
