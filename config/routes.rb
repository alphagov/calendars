Calendars::Application.routes.draw do
  match '/warmup', controller: "GdsWarmupController::Warmup", action: :index

  # Redirect for old 'ni' division slug in bank-holidays
  constraints(:format => /(json|ics)/) do
    match '/bank-holidays/ni', :to => redirect("/bank-holidays/northern-ireland.%{format}")
  end

  match '/:scope', :to => 'calendar#calendar', :as => :calendar
  match '/:scope/:division', :to => 'calendar#division', :as => :division
end
