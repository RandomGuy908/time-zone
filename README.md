# Time Zone Converter v0.2.0

Small self-hosted, Dockerized time zone converter. No database or external API required.

## Features
- Natural 12-hour and 24-hour time input (`9am`, `9:15 PM`, `21:15`)
- Searchable IANA time zones with common abbreviations such as MST/MDT/CET/CEST
- Country/region flags for common zones
- America/Denver default destination
- Automatic DST handling and nearby DST warnings
- Day-boundary labels (Yesterday / Same day / Tomorrow)
- Relative time difference
- Browser-saved favorites and comparison zones
- Multi-zone comparison panel
- Copy conversion and shareable URL
- Responsive dark interface

## Run
```bash
docker compose up -d --build
```
Open `http://SERVER-IP:6030`.
