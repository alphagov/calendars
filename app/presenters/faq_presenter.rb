class FaqPresenter
  def initialize(scope, calendar, content_item)
    @scope = scope
    @calendar = calendar
    @content_item = content_item.symbolize_keys
  end

  def metadata
    # http://schema.org/FAQPage
    {
      "@context" => "http://schema.org",
      "@type" => "FAQPage",
      "headline" => content_item[:title],
      "description" => content_item[:description],
      "publisher" => {
        "@type" => "Organization",
        "name" => "GOV.UK",
        "url" => "https://www.gov.uk",
        "logo" => {
          "@type" => "ImageObject",
          "url" => logo_url,
        },
      },
      "mainEntity" => questions_and_answers,
    }
  end

private

  attr_reader :scope, :calendar, :content_item

  def questions_and_answers
    calendar.divisions.map { |division| answer_for(division) }.compact
  end

  def answer_for(division)
    return nil unless division.upcoming_event

    case scope
    when "bank-holidays"
      is_in = I18n.t("common.next_holiday_in_is").sub("%{in_nation}", I18n.t("#{division.title}_in"))
      day = division.upcoming_event.date == Date.today ? I18n.t("common.today") : I18n.l(division.upcoming_event.date, format: "%e %B")
      title = I18n.t(division.title)
      body = "#{is_in} #{day}: #{division.upcoming_event.title}"
    when "when-do-the-clocks-change"
      title = content_item[:title]
      body = "The #{division.upcoming_event.notes.gsub(' one hour', '').downcase} #{division.upcoming_event.date.strftime('%e %B')}"
    else
      raise "Unknown scope"
    end

    {
      "@type" => "Question",
      "name" => title,
      "acceptedAnswer" => {
        "@type" => "Answer",
        "text" => body,
      },
    }
  end

  def logo_url
    Plek.current.asset_root + ActionController::Base.helpers.asset_url("govuk_publishing_components/govuk-logo.png", type: :image)
  end
end
