Calendars::Application.routes.draw do
  match '/warmup', controller: "GdsWarmupController::Warmup", action: :index

  # Redirects for old 'ni' division slug in bank-holidays
  constraints(:format => /(json|ics)/) do
    match '/bank-holidays/ni', :to => redirect("/bank-holidays/northern-ireland.%{format}")
    match '/bank-holidays/ni-:year', :constraints => {:year => /201[23]/}, :to => redirect("/bank-holidays/northern-ireland-%{year}.%{format}")
  end

  match '/:scope', :to => 'calendar#calendar', :as => :calendar
  match '/:scope/:division-:year', :to => 'calendar#show', :as => :division_year, :constraints => { :year => /[0-9]{4}/ }
  match '/:scope/:division', :to => 'calendar#index', :as => :division

end
