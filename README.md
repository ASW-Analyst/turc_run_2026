# TURC Run 2026

This is my first time developing with an AI agent. I used CODEX with
the `AGENTS.md` file to guide the workflow.

This repository contains a Shiny app that tracks TU Run Club's 2026
running progress from the King's Ransom in Sale to the Gothenburg
Opera House. It visualises cumulative club distance on a saved route
and shows individual contributions.

## Structure

- `app.R`: app entry point.
- `src/`: app logic.
  - `ui.R`: Shiny UI layout.
  - `server.R`: Shiny server logic.
  - `utils.R`: data helpers.
  - `load_packages.R`: dependency loader.
- `data/`: data used by the app.
  - `turc_2026.xlsx`: running data input.
  - `route/`: saved route files used by the map.
- `www/`: static assets (CSS, images).
- `tests/`: testthat tests (if added).

## Clone

```bash
git clone https://github.com/ASW-Analyst/turc_run_2026.git
cd turc_run_2026
```
