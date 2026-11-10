# MicroFun website and tutorials

Website repository for MicroFun. The R package is maintained separately at
[bioscinema/MicroFun](https://github.com/bioscinema/MicroFun).

The configured website address is
<https://bioscinema.github.io/MicroFun_website_tutorials/>.
This address becomes available after GitHub Pages has been enabled and a deployment succeeds.

## Files to edit

| Content | Source |
|---|---|
| Homepage | `index.md` |
| Tutorial pages | `articles/*.Rmd` |
| Navigation and website settings | `_pkgdown.yml` |
| Styles | `assets/extra.css` |
| Images and interactive figures | `assets/examples/` |
| Changelog | `NEWS.md` |
| Package snapshot for rebuilding reference pages | `source/MicroFun_0.1.0.zip` |
| Built website | `docs/` |

Edit the source pages, then rebuild. Direct edits in `docs/` are overwritten by a build.
The package snapshot supplies functions and reference documentation; website edits do not alter it.

## Build and preview locally

Open `pkgdown.Rproj` in RStudio. Install the website tools once and then build.

```r
install.packages(c("pkgdown", "rmarkdown", "knitr"))
source("build.R")
```

The default preview build displays tutorial and function example code without executing it.
RStudio provides Pandoc. Command-line users also need Pandoc available.
The build may contact external package-information services.

```sh
python3 -m http.server 8765 --bind 127.0.0.1 --directory docs
```

Open <http://127.0.0.1:8765/> and refresh after each build.

To build from an updated package source, pass a directory or ZIP archive.

```sh
Rscript build.R /absolute/path/to/MicroFun
```

Or replace `source/MicroFun_0.1.0.zip` with the updated snapshot and update the default
source filename in `build.R` if its name changes. Update the exception in `.gitignore`
when changing the snapshot filename. Keep the original package development in its own repository.

## First upload and publication

Copy the contents of this website project into the repository root, including
`.github/`, `.gitignore`, source files and `docs/`. Do not add an extra enclosing folder.
The repository's default branch should be `main` for the supplied workflow.

In the repository, open **Settings → Pages → Build and deployment**, and choose
**GitHub Actions** as the source. If organization permissions restrict Pages or Actions,
a repository administrator needs to enable them.

The **Publish website** workflow publishes the already generated `docs/` folder.
It does not rebuild R Markdown on GitHub. After enabling Pages, open **Actions →
Publish website → Run workflow** for the first deployment if needed. Publication
makes the site accessible at the configured website address.

## Subsequent changes

1. Edit the homepage, tutorial or stylesheet sources.
2. Run `source("build.R")` and review the local preview.
3. Commit and push both the changed sources and the regenerated `docs/` files.
4. The workflow publishes changes to `docs/` pushed to `main`.

A source-only change does not update the published pages until `docs/` is rebuilt.

Local build caches, backups, old `docs 2` folders and RStudio session files are
excluded by `.gitignore`. Keep generated `docs/` files in this website repository.

## Data and figures

The tutorial sources describe which examples use bundled package data, synthetic
plotting inputs or supplied study figures. The study figures' original raw-data
provenance has not been independently verified during website preparation.
