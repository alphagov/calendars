Calendars::Application.routes.draw do
  # Redirect for old 'ni' division slug in bank-holidays
  constraints(:format => /(json|ics)/) do
    match '/bank-holidays/ni', :to => redirect("/bank-holidays/northern-ireland.%{format}")
  end

  match '/gwyliau-banc', :to => 'calendar#calendar', :defaults => { :scope => "gwyliau-banc", :locale => :cy }
  match '/gwyliau-banc/:division', :to => 'calendar#division', :defaults => { :scope => "gwyliau-banc", :locale => :cy }

  match '/:scope', :to => 'calendar#calendar', :as => :calendar
  match '/:scope/:division', :to => 'calendar#division', :as => :division
end
