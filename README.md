# Time Zone Converter v0.3.0

Small self-hosted timezone converter with no database or external API.

## v0.3 highlights
- Searchable autocomplete timezone pickers with favorites and recent zones
- Country flags and friendly timezone metadata
- Natural time input (`7pm`, `19:30`, `1930`, `noon`, `midnight`, `now`)
- Natural date input (`today`, `tomorrow`, weekday names, `Oct 4`, `10/4/26`)
- Exact DST gap/overlap detection with choice when a local time occurs twice
- Timezone information panel
- Keyboard shortcuts: `/` search, Enter convert, S swap, N now, C copy, Esc close
- Drag/reorder comparison zones
- ±30m / ±1h timeline controls
- Conversion history stored locally
- Shareable URL conversions
- Installable/offline PWA
- Light, dark, and system themes
- Accessibility and mobile polish

## Run
```bash
docker compose up -d --build
```
Open `http://SERVER-IP:6030`.
