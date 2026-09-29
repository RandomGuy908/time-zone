# Time Zone Converter 0.1.0

Small self-hosted time zone converter. Destination defaults to `America/Denver` and browser timezone APIs automatically account for DST.

## Run with Docker Compose

```bash
docker compose up -d --build
```

Open `http://SERVER-IP:6030`.

## Update / rebuild

```bash
docker compose down
docker compose up -d --build
```

## Features
- Date and time input
- Source timezone selector
- Destination timezone selector defaulting to Denver/Mountain
- DST-aware conversions using IANA time zones
- Use current time
- Swap zones
- Copy result
- Mobile-friendly dark UI
- No database or external API required
