Calendars::Application.routes.draw do
  # Redirect for old 'ni' division slug in bank-holidays
  constraints(format: /(json|ics)/) do
    get '/bank-holidays/ni', to: redirect("/bank-holidays/northern-ireland.%{format}")
  end

  get '/gwyliau-banc', to: 'calendar#calendar', defaults: { scope: "gwyliau-banc", locale: :cy }
  get '/gwyliau-banc/:division', to: 'calendar#division', defaults: { scope: "gwyliau-banc", locale: :cy }

  get '/:scope', to: 'calendar#calendar', as: :calendar
  get '/:scope/:division', to: 'calendar#division', as: :division
end
