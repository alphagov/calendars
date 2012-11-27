## Calendars

A Rails application to format and display calendar data, starting with [Bank Holidays](https://www.gov.uk/bank-holidays) and [Daylight Savings Time](https://www.gov.uk/when-do-the-clocks-change), in a clearer and more accessible format, along with JSON and iCal exports of the data.

### Usage

Each type of calendar (e.g. daylight saving, bank holidays) is known as a _scope_. A scope has its own view templates, JSON data source and primary route.

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
