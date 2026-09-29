# Time Zone Converter

A small, fast, self-hosted time zone conversion utility designed for quick everyday conversions without accounts, a database, or external APIs.

**Current release: v1.0.0**

Time Zone Converter accepts natural date and time input, understands both 12-hour and 24-hour formats, handles daylight-saving transitions, provides searchable IANA time zones with country flags, compares multiple zones at once, remembers useful preferences locally, and can be installed as a Progressive Web App (PWA).

The default destination is **Mountain Time — Denver (`America/Denver`)**, so Denver automatically changes between MST and MDT when daylight-saving rules require it.

---

## Features

### Fast time conversion

Enter a date, a time, a source time zone, and a destination time zone. The result immediately shows:

- Converted local time
- Full converted date
- Time-zone abbreviation such as MDT, EST, CEST, or JST
- UTC offset
- Whether the result is the same day, yesterday, tomorrow, or multiple days away
- Relative difference between the source and destination zones
- Country/region flag for supported IANA zones

There is no Convert button required for normal use; valid input is converted as it changes.

### Automatic 12-hour and 24-hour input

The time field accepts common formats without requiring the user to select an input format first. Examples include:

```text
7pm
7:30pm
7:30p
19:30
1930
noon
midnight
now
```

The interface displays how the entered value was interpreted.

The **display format** can independently be set to Auto, 12-hour, or 24-hour in Settings.

### Natural date input

Dates can be entered using the calendar control or natural text such as:

```text
today
tomorrow
yesterday
Friday
Oct 4
10/4/26
```

Weekday names resolve to the next occurrence of that weekday.

### Searchable time-zone picker

Time zones use the browser's IANA time-zone database and can be searched using several kinds of terms. Depending on the zone, searches can include:

- City: `Denver`, `Berlin`, `Tokyo`
- IANA identifier: `America/Denver`, `Europe/Berlin`
- Common abbreviation: `MST`, `MDT`, `EST`, `EDT`, `CET`, `CEST`
- Country name or country code where mapped
- UTC offset such as `UTC+02:00`
- Friendly names such as `Mountain Time` or `Central European Time`

The picker prioritizes saved favorites and recently selected zones when opened without a search query.

> Time-zone abbreviations can be ambiguous. The application ultimately stores and converts using IANA identifiers rather than treating an abbreviation such as `CST` as a fixed universal zone.

### Country flags

Time zones with a country mapping display the associated country's flag throughout the interface. UTC uses a globe icon. Flags are a visual aid only; the city and IANA identifier remain available so the interface does not depend on flags alone.

### Daylight-saving time handling

Conversions are based on IANA time-zone rules rather than hard-coded UTC offsets. This means zones such as `America/Denver` automatically move between MST and MDT.

The converter also handles the two difficult DST cases:

**Nonexistent local time** — During a spring-forward transition, some local times never occur. The app detects this and asks the user to choose another time rather than silently producing an incorrect conversion.

**Ambiguous local time** — During a fall-back transition, the same wall-clock time can occur twice. When that happens, the app displays both valid occurrences with their abbreviation and UTC offset and lets the user select the intended one.

### Quick timeline controls

The result card includes quick adjustments for exploring nearby times without retyping the input:

- −1 hour
- −30 minutes
- +30 minutes
- +1 hour

### Swap and current-time controls

**Swap** reverses the source and destination zones.

**Use current time** fills the converter with the current date/time and, when supported by the browser, the browser's local IANA time zone.

### Favorites

Frequently used destination zones can be saved as favorites. Favorites appear as quick-access buttons and are prioritized in the time-zone picker.

Favorites are stored only in the current browser using `localStorage`.

### Recent zones

The app remembers recently selected zones and surfaces them near the top of an empty time-zone search. This makes repeated conversions faster without requiring an account.

### Multi-zone comparison

The **Quick Comparison** section shows the same instant in multiple time zones at once. Each row includes:

- Country flag
- City
- Current abbreviation for that instant
- UTC offset
- Local time
- Local date

Comparison zones can be added, removed, and reordered with drag-and-drop. The chosen list and order are stored locally.

### Conversion history

When enabled, the app stores up to 20 recent conversions in the browser. Selecting a history entry restores its date, time, source zone, and destination zone.

History can be disabled in Settings or cleared at any time. No history is sent to the server.

### Shareable conversions

The current conversion is encoded into the page URL. **Copy share link** copies that URL so another user can open the same date, source time, source zone, and destination zone.

**Copy time** creates a human-readable conversion suitable for chat, email, or notes.

### Time-zone information

Selecting the destination label in the result opens an information dialog showing details such as:

- IANA zone identifier
- Abbreviation for the selected instant
- UTC offset
- Country code when known
- Whether the zone uses seasonal offset changes

### Themes

Three theme modes are available:

- System
- Dark
- Light

The selected preference is stored in the browser.

### Keyboard shortcuts

The interface supports keyboard-oriented use, including shortcuts for common actions such as focusing search, converting, swapping zones, using the current time, copying a result, and closing menus/dialogs.

### Mobile and accessibility support

The interface is responsive and designed to work on desktop and mobile. Accessibility work includes semantic labels, dialog controls, keyboard operation, focusable actions, live result/status regions, a skip link, and text labels alongside visual flag information.

### PWA and offline support

Time Zone Converter includes a web app manifest and service worker. After the application has been loaded, supported browsers can cache the application shell for offline use and may offer installation to the desktop or home screen.

Because conversion is performed in the browser and does not depend on an external conversion service, the core application remains useful without Internet access.

---

## Privacy and data model

Time Zone Converter is intentionally local-first.

It has:

- No user accounts
- No database
- No analytics included by default
- No external time-zone API
- No external conversion API
- No server-side conversion history

Preferences, favorites, recent zones, comparison zones, theme choice, and optional conversion history are stored in the browser's `localStorage`.

A shared conversion URL contains the conversion parameters in the URL itself, so treat a copied share URL as information you are intentionally sharing.

---

# Installation

## Recommended: Docker Compose

### Requirements

You need a host with:

- Docker Engine
- Docker Compose v2 (`docker compose`)
- Git if cloning from GitHub
- An available TCP port (6030 by default)

The included container uses Node.js 22 Alpine and is small enough to run comfortably on a lightweight VM, LXC, home server, or NAS capable of running Docker.

### 1. Clone the repository

Using SSH:

```bash
git clone git@github.com:RandomGuy908/time-zone.git
cd time-zone
```

Or use the repository's HTTPS clone method if SSH authentication is not configured.

### 2. Start the application

```bash
docker compose up -d --build
```

The included Compose configuration maps:

```text
Host port:      6030
Container port: 3000
```

Open:

```text
http://SERVER-IP:6030
```

### 3. Verify the container

```bash
docker compose ps
```

View application logs with:

```bash
docker compose logs --tail=100
```

Follow logs live with:

```bash
docker compose logs -f
```

### 4. Stop the application

```bash
docker compose down
```

Your browser preferences/history are unaffected because they are stored in each user's browser, not in the container.

### Updating an existing installation

From the repository directory:

```bash
git pull
docker compose up -d --build
```

Optionally remove unused Docker image layers afterward:

```bash
docker image prune -f
```

---

## Docker Compose configuration

The included `docker-compose.yml` is intentionally minimal:

```yaml
services:
  timezone-converter:
    build: .
    container_name: timezone-converter
    restart: unless-stopped
    ports:
      - "6030:3000"
    environment:
      TZ: America/Denver
      PORT: 3000
```

### Changing the exposed port

To expose the application on port 8080 instead of 6030, change:

```yaml
ports:
  - "8080:3000"
```

Then recreate the service:

```bash
docker compose up -d
```

### About the `TZ` environment variable

The container is configured with `TZ=America/Denver`, but browser-side conversions are not implemented by changing the server's system clock. The conversion engine explicitly uses IANA time-zone identifiers with JavaScript's `Intl` APIs.

The application's default destination is also Denver unless the user changes their browser preference.

---

## Running without Docker

Node.js 20 or newer is required; Node.js 22 is recommended to match the container image.

Clone the repository and run:

```bash
git clone git@github.com:RandomGuy908/time-zone.git
cd time-zone
npm start
```

By default the server listens on port 3000.

To choose another port on Linux/macOS:

```bash
PORT=6030 npm start
```

Then open the corresponding server address in your browser.

No `npm install` step is currently required because v1.0.0 has no third-party Node dependencies.

---

# Reverse proxy

The application works well behind Nginx Proxy Manager, Nginx, Caddy, Traefik, or another HTTP reverse proxy.

Point the proxy to:

```text
http://TIME-ZONE-SERVER-IP:6030
```

For a public deployment, HTTPS is recommended. HTTPS also improves compatibility with browser features that require a secure context, including some PWA and clipboard behavior.

The application does not require WebSockets or a special API route.

---

# Code deep dive

## Architecture

Time Zone Converter deliberately uses a very small architecture:

```text
Browser
   │
   │ HTTP
   ▼
Node static-file server
   │
   └── src/public/
       ├── index.html
       ├── style.css
       ├── app.js
       ├── tzmap.js
       ├── manifest.webmanifest
       └── sw.js
```

There is no application database and no server-side conversion API. The Node process serves the static frontend; the browser performs the actual time-zone calculations.

This keeps deployment simple and removes the need to synchronize server-side user state.

## Project layout

```text
time-zone/
├── .dockerignore
├── Dockerfile
├── docker-compose.yml
├── package.json
├── README.md
└── src/
    ├── server.js
    └── public/
        ├── app.js
        ├── index.html
        ├── manifest.webmanifest
        ├── style.css
        ├── sw.js
        └── tzmap.js
```

### `src/server.js`

The backend is a dependency-free Node HTTP server. Its responsibilities are intentionally limited to:

1. Listening on `PORT` (3000 by default)
2. Mapping `/` to `index.html`
3. Serving files from `src/public`
4. Returning appropriate MIME types
5. Rejecting path traversal outside the public directory
6. Returning 404 for missing assets

It binds to `0.0.0.0`, allowing Docker to expose it through the configured port mapping.

The server sends `Cache-Control: no-cache`; offline/PWA behavior is handled separately by the service worker.

### `src/public/index.html`

`index.html` defines the application's UI and semantic structure. Major sections include:

- Header and global actions
- Date/time/source/destination converter
- Favorites
- Result card
- DST warning/ambiguity controls
- Timeline adjustment controls
- Multi-zone comparison
- Conversion history
- Settings dialog
- Time-zone information dialog
- Add-comparison-zone dialog

The page loads `tzmap.js` before `app.js` so the country mapping is available when the application initializes.

### `src/public/app.js`

`app.js` contains the core application logic. It is responsible for:

- Discovering supported IANA zones with `Intl.supportedValuesOf('timeZone')` when available
- Searching and rendering time-zone choices
- Friendly aliases for commonly used zones
- Natural time parsing
- Natural date parsing
- UTC-offset calculations
- Converting a local wall-clock time into a real instant
- Detecting DST gaps and overlaps
- Formatting destination times and dates
- Favorites and recent zones
- Comparison zones and drag ordering
- Conversion history
- URL/share state
- Theme and settings state
- Clipboard actions
- Dialogs and keyboard interactions

### How conversion works

A time-zone conversion has two separate concepts:

1. A **wall-clock value**, such as `2026-11-01 01:30` in Denver
2. An **instant**, a unique moment on the global timeline

Simply attaching a fixed `-07:00` or `-06:00` offset to Denver would be incorrect because Denver's offset changes seasonally and some wall-clock values can be missing or duplicated.

The app therefore uses IANA zone rules exposed through `Intl.DateTimeFormat`.

For a source wall-clock date/time, the application samples possible UTC offsets around that date, builds candidate instants, and then formats each candidate back into the source zone. A candidate is valid only if the resulting year, month, day, hour, and minute exactly match the user's requested wall-clock value.

This produces three important outcomes:

- **One candidate:** normal local time; conversion proceeds.
- **Zero candidates:** DST gap/nonexistent local time; the app warns instead of guessing.
- **Two candidates:** DST overlap/ambiguous local time; the user chooses the intended occurrence.

Once a unique instant is selected, formatting that same `Date` in any destination IANA zone produces the converted local time.

### UTC offsets

The app derives the effective UTC offset for a specific instant and zone by formatting that instant into local date/time parts and comparing those parts with UTC. This means the displayed offset reflects the selected date, not merely the zone's current offset today.

### Abbreviations

Abbreviations are obtained from `Intl.DateTimeFormat` using `timeZoneName: 'short'`. The exact abbreviation formatting therefore follows the JavaScript runtime/browser's internationalization data.

### `src/public/tzmap.js`

`tzmap.js` maps IANA time-zone identifiers to country codes. The frontend converts two-letter country codes into Unicode regional-indicator flag emoji.

This mapping supplements the browser's IANA zone list; the IANA identifier remains the authoritative value used for conversion.

### Browser storage

Persistent UI state is stored in `localStorage` under the application's storage key. This includes values such as:

- Favorites
- Recent time zones
- Comparison zones/order
- Theme
- Time display preference
- Default destination
- Optional conversion history

This architecture means two people opening the same server can maintain completely independent preferences without user accounts.

### Share links

The current conversion state is written into URL query parameters. Sharing the URL therefore does not require a server-side share table, identifier, or database record.

On load, the application can restore the conversion from those parameters.

### `src/public/sw.js`

The service worker provides the PWA's offline cache behavior. Static application assets can be served from the browser cache after the initial successful load.

When changing cached frontend assets in future releases, the service-worker cache/version strategy should also be reviewed so existing installations receive the new files cleanly.

### `src/public/manifest.webmanifest`

The web app manifest supplies installable-app metadata used by supported browsers and operating systems.

### `src/public/style.css`

The stylesheet contains the responsive layout, themes, cards, dialogs, search results, comparison rows, mobile behavior, and accessibility-oriented presentation states.

### `Dockerfile`

The production image uses:

```dockerfile
FROM node:22-alpine
```

Only `package.json` and `src` are copied into the image. There is no build pipeline or dependency installation stage because the current application uses native browser APIs and Node's built-in HTTP/filesystem modules.

The container exposes port 3000 and launches:

```text
npm start
```

which runs `node src/server.js`.

### `docker-compose.yml`

Compose provides the normal self-hosted deployment configuration, including:

- Image build
- Stable container name
- Automatic restart unless manually stopped
- Port 6030 → 3000 mapping
- Denver server timezone environment setting

---

# Browser/API dependencies

Although the project has no third-party JavaScript packages, it relies on modern browser functionality, particularly:

- `Intl.DateTimeFormat`
- IANA time-zone data supplied by the browser/runtime
- `Intl.supportedValuesOf()` where available
- `localStorage`
- `<dialog>`
- Clipboard API for copy actions
- Service Workers
- Web App Manifest support for PWA installation

A current version of Chrome, Edge, Firefox, or another modern browser is recommended.

---

# Defaults

The v1.0.0 defaults are intentionally useful for a Mountain Time deployment:

```text
Default destination: America/Denver
Docker host port:    6030
Container port:      3000
Container TZ:        America/Denver
History:             Browser-local
Database:            None
External APIs:       None
```

Users can change their own default destination from Settings without changing the server configuration.

---

# Development

For simple local development:

```bash
npm start
```

Then open:

```text
http://localhost:3000
```

Because there is no compilation or bundling step, changes to files under `src/public` are available after refreshing the browser.

When developing PWA/service-worker changes, browser caching can make an old asset appear to remain active. Use the browser's developer tools to inspect/unregister the service worker or clear site data when testing cache changes.

---

# Troubleshooting

## Port 6030 is already in use

Change the host side of the Compose mapping:

```yaml
ports:
  - "6031:3000"
```

Then run:

```bash
docker compose up -d
```

## The container is not running

Check:

```bash
docker compose ps
docker compose logs --tail=100
```

## Git asks for a username/password

If the repository is configured to use SSH, confirm the remote:

```bash
git remote -v
```

An SSH remote should look like:

```text
git@github.com:RandomGuy908/time-zone.git
```

Test GitHub SSH authentication with:

```bash
ssh -T git@github.com
```

## An old version still appears after an update

First rebuild/recreate the container:

```bash
git pull
docker compose up -d --build
```

If the server is current but the browser still displays old frontend assets, refresh the site and clear the site's service-worker/cache data. PWA caching can preserve previously cached assets.

## Clipboard or PWA installation does not work

Use HTTPS when accessing the app through a hostname. Some browser capabilities are restricted outside secure contexts, with `localhost` generally treated as a development exception.

---

# Release

## v1.0.0

v1.0.0 marks the first stable release of Time Zone Converter. It includes the full converter workflow, natural date/time input, DST-aware IANA conversion, favorites and recent zones, multi-zone comparison, history, share links, PWA/offline support, themes, settings, country flags, and responsive/accessibility improvements.

---

## License

No license file is included in this release. If the repository is intended for public reuse or contribution, add an explicit open-source license before describing the project as open source.

---

## One-command installation from GitHub Releases

GitHub Releases are the recommended installation path for normal users. Every tagged release publishes a stable `time-zone-app.zip`, Linux installer, Windows installer, and SHA-256 checksum file.

### Debian / Ubuntu

```bash
curl -fsSL https://github.com/RandomGuy908/time-zone/releases/latest/download/install.sh | sudo bash
```

The installer installs Docker Engine when needed, downloads the latest application archive, verifies its SHA-256 checksum, installs to `/opt/time-zone`, builds the container, and starts the site on port `6030`.

Update later with:

```bash
sudo /opt/time-zone/scripts/update.sh
```

Uninstall with:

```bash
sudo /opt/time-zone/scripts/uninstall.sh
```

### Windows

Windows uses Docker Desktop. Install and start Docker Desktop first, then open PowerShell and run:

```powershell
irm https://github.com/RandomGuy908/time-zone/releases/latest/download/install.ps1 | iex
```

The application is installed by default under `%LOCALAPPDATA%\TimeZoneConverter` and becomes available at `http://localhost:6030`.

Update later with:

```powershell
& "$env:LOCALAPPDATA\TimeZoneConverter\scripts\update.ps1"
```

Uninstall with:

```powershell
& "$env:LOCALAPPDATA\TimeZoneConverter\scripts\uninstall.ps1"
```

The uninstall scripts remove the Time Zone Converter application and container but intentionally leave Docker/Docker Desktop installed.

## Automated release workflow

The repository contains `.github/workflows/release.yml`. Pushing a semantic version tag such as `v1.0.0` automatically:

1. Checks that the tag matches the version in `package.json`.
2. Packages the deployable application as `time-zone-app.zip`.
3. Generates SHA-256 checksums.
4. Creates the GitHub Release with generated release notes.
5. Uploads `time-zone-app.zip`, `install.sh`, `install.ps1`, and `checksums.txt` as release assets.

Example release:

```bash
git add .
git commit -m "Release v1.0.0"
git push origin main
git tag v1.0.0
git push origin v1.0.0
```

For a future `v1.1.0`, update `package.json` and the displayed application version first, commit and push those changes, then create and push the `v1.1.0` tag.
