## Calendars

A Rails application to format and display calendar data, starting with [Bank Holidays](https://www.gov.uk/bank-holidays) and [Daylight Savings Time](https://www.gov.uk/when-do-the-clocks-change), in a clearer and more accessible format, along with JSON and iCal exports of the data.

### Usage

Each type of calendar (eg daylight saving, bank holidays) is known as a _scope_. A scope has its own view templates, JSON data source and primary route.

JSON data files are stored in `lib/data/<scope>.json`, with a `divisions` hash for separate data per region (`united-kingdom`, `england-and-wales`, `scotland` or `northern-ireland`).
      
### Data Format

Each scope's data file contains a list of divisions, containing a list of years, each with a list of events:

    {
      "title": "UK bank holidays",
      "description": "UK bank holidays calendar - see UK bank holidays and public holidays for 2012 and 2013",
      "divisions": {
        "england-and-wales": {
          "title": "England and Wales",
          "2011": [{
            "title": "New Year's Day",
            "date": "02/01/2011",
            "notes": "Substitute day"
          }]
        }
      }
    }

The division `title` attribute is optional.  If this is not present the slug will be humanized and used instead.

### API

Each calendar has a series of formats and endpoints at which data can be accessed:

* `/<scope>/<division>-<year>.<format>` - calendar for events in a specific year for a division, available as `json` or `ics`
* `/<scope>/<division>.<format>` - calendar for all events in a division regardless of year, available as `json` or `ics`
* `/<scope>.<format>` - entire scope dataset, all divisions, their calendars and events, only available as `json` 

### Generate bank holidays

A rake task has been created to generate the bank holidays JSON for a given year. They need to be then inserted, and
modified to take into account any additions/modifications made by proclamation.
Run the rake task like this:

    bundle exec rake bank_holidays:generate_json[2016]

In order to make the difference between holidays determined by law or by proclamation, an additional rake task was created:

    bundle exec rake bank_holidays:generate_json_with_proclamation[2016]

This rake task adds an additional "proclamation" boolean flag on each bank holiday. If the "proclamation" flag is set
to true, that holiday is not specified by any legislation but has been proclaimed consistently every year: this is
the case for a number of bank holidays, as well for some substitute days. 

### Testing

Run unit tests like this:

    govuk_setenv calendars bundle exec rake

#### Canonical sources

For summer time, we can use the [Summer Time Act 1972](http://www.legislation.gov.uk/ukpga/1972/6).

Bank holidays are determined both by law and by proclamation.

We use the following legislation: the [Banking and Financial Dealings Act 1971](http://www.legislation.gov.uk/ukpga/1971/80/schedule/1)
and the [St Andrew's Day Bank Holiday Act](http://www.legislation.gov.uk/asp/2007/2/section/1).

The proclamations of holidays are published in [The Gazette](https://www.thegazette.co.uk/all-notices/notice?noticetypes=1101&sort-by=latest-date&text="Banking+and+Financial").
Holidays are announced there 6 months to one year in advance, usually between the months of May and July for the following year.
