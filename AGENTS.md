# AGENTS.md

## Workflow
- Start by writing a short plan (bullets).
- Make minimal changes that satisfy the request.
- When editing code: return a patch-style response (what file, what changed).
- After code changes: list how to run locally + quick manual test steps.
- Provide complete, runnable code blocks (not fragments)
- Explain your reasoning BEFORE the code, not after
- If uncertain about requirements, ask ONE clarifying question before proceeding
- Match the existing code style in the file

## Coding Style and Structure
- Use R (>= 4.5.0)
- Use tidyverse packages where able
- Use `|>` over `%>%` for piping
- Dont undertake complex transformations in a single step.
- Use renv for package management
- Use `<-` for assignment not `=`
- Use snake_case for variable names
- Keep lines under 80 characters
- Use `here::here()` for file paths, never `setwd()`

## Repo Structure
```
project/
├── data/raw/       # Never modify files here
├── www             # images and css files used in the app saved in here
├── src/            # Contains the ui.R, server.R and any processing files
    ├── ui.R
    ├── server.R
    ├── utils.R     # for any utility functions  
└── tests/          # testthat tests if needed
```


- Use `here::here()` for all paths
- Scripts should be self-contained and runnable from project root


## Shiny conventions
- Create seperate `ui.R` and `server.R` scripts that are called in `app.R`
- Create a seperate script for the loading of packages.
- Prefere reactive dataframes and values over observers where possible

## Dependencies
- Don't add new packages unless necessary
- If you do, explain why and update renv.lock (if present).


