
# Build the website from a fresh copy of a package directory or ZIP archive.
# The input package is never modified.

script_root <- local({
  source_files <- unlist(lapply(sys.frames(), function(x) x$ofile))
  cli_file <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  
  path <- if (length(source_files)) {
    tail(source_files, 1)
  } else if (length(cli_file)) {
    sub("^--file=", "", cli_file[1])
  } else {
    "build.R"
  }
  
  dirname(normalizePath(path, mustWork = TRUE))
})

local_library <- file.path(script_root, ".build", "library")
if (dir.exists(local_library)) .libPaths(c(local_library, .libPaths()))

args <- commandArgs(trailingOnly = TRUE)
full <- "--full" %in% args
inputs <- args[!startsWith(args, "--")]

input <- if (length(inputs)) {
  inputs[1]
} else {
  Sys.getenv(
    "MICROFUN_SOURCE",
    file.path(script_root, "source", "MicroFun_0.1.0.zip")
  )
}

input <- normalizePath(input, mustWork = TRUE)

# ------------------------------------------------------------
# 1. Configure cache and dependencies
# ------------------------------------------------------------

cache_root <- file.path(script_root, ".build", "cache")
dir.create(cache_root, recursive = TRUE, showWarnings = FALSE)
Sys.setenv(R_USER_CACHE_DIR = cache_root)

for (dependency in c("pkgdown", "rmarkdown", "knitr")) {
  if (!requireNamespace(dependency, quietly = TRUE)) {
    stop("Install required package: install.packages('",
         dependency, "')")
  }
}

# Reuse RStudio's bundled Pandoc when running outside the IDE.

if (!rmarkdown::pandoc_available()) {
  candidates <- c(
    "/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/aarch64",
    "/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/x86_64"
  )
  
  candidates <- candidates[
    file.exists(file.path(candidates, "pandoc"))
  ]
  
  if (length(candidates)) {
    Sys.setenv(RSTUDIO_PANDOC = candidates[1])
  }
}

if (!rmarkdown::pandoc_available()) {
  stop("Pandoc is required. Run in RStudio or install Pandoc and retry.")
}

# ------------------------------------------------------------
# 2. Prepare temporary build directory
# ------------------------------------------------------------

build_root <- file.path(script_root, ".build")
dir.create(build_root, showWarnings = FALSE)

run_root <- tempfile("run-", tmpdir = build_root)
dir.create(run_root)

# Extract package source if using a ZIP archive.

if (dir.exists(input)) {
  
  package_root <- input
  
} else {
  
  archive_files <- utils::unzip(input, list = TRUE)$Name
  
  if (any(grepl("(^/|^[A-Za-z]:|(^|/)\\.\\.(/|$)|\\\\)",
                archive_files))) {
    stop("Archive contains unsafe paths.")
  }
  
  extracted <- file.path(run_root, "extracted")
  utils::unzip(input, exdir = extracted)
  
  descriptions <- list.files(
    extracted,
    pattern = "^DESCRIPTION$",
    recursive = TRUE,
    full.names = TRUE
  )
  
  if (length(descriptions) != 1L) {
    stop("Expected one R package in the archive.")
  }
  
  package_root <- dirname(descriptions)
}

if (!file.exists(file.path(package_root, "DESCRIPTION"))) {
  stop("The source directory must contain DESCRIPTION.")
}

metadata <- read.dcf(file.path(package_root, "DESCRIPTION"))

if (metadata[1, "Package"] != "MicroFun") {
  stop("Expected the MicroFun package.")
}

# ------------------------------------------------------------
# 3. Stage a fresh copy of MicroFun
# ------------------------------------------------------------

staged <- file.path(run_root, "MicroFun")
dir.create(staged)

# Omit old websites, vignettes, and environment-specific files.

skip <- c(
  "docs", "pkgdown", "vignettes", "renv", "renv.lock",
  ".git", ".github", ".Rproj.user", ".Rprofile",
  ".Renviron", ".Rhistory", ".RData", ".DS_Store",
  ".build", "outputs", "work",
  "MIGRATION_EXPORTS.md", "VALIDATION.md"
)

entries <- list.files(
  package_root,
  all.files = TRUE,
  no.. = TRUE,
  full.names = TRUE
)

entries <- entries[!basename(entries) %in% skip]

if (!all(file.copy(entries, staged, recursive = TRUE))) {
  stop("Could not copy package source.")
}

# ------------------------------------------------------------
# 4. Copy website source files
# ------------------------------------------------------------

dir.create(file.path(staged, "pkgdown"))

stopifnot(
  file.copy(
    file.path(script_root, "_pkgdown.yml"),
    staged,
    overwrite = TRUE
  )
)

# Copy website changelog.

news_override <- file.path(script_root, "NEWS.md")

if (file.exists(news_override)) {
  stopifnot(
    file.copy(news_override, staged, overwrite = TRUE)
  )
}

# Copy homepage.

stopifnot(
  file.copy(
    file.path(script_root, "index.md"),
    file.path(staged, "pkgdown"),
    overwrite = TRUE
  )
)

# Copy website assets.

assets_dir <- file.path(script_root, "assets")

dir.create(file.path(staged, "pkgdown", "assets"))

assets <- list.files(
  assets_dir,
  all.files = TRUE,
  no.. = TRUE,
  full.names = TRUE
)

if (length(assets)) {
  stopifnot(
    all(
      file.copy(
        assets,
        file.path(staged, "pkgdown", "assets"),
        recursive = TRUE,
        overwrite = TRUE
      )
    )
  )
}

# pkgdown loads extra.css from pkgdown/extra.css.

extra_css <- file.path(assets_dir, "extra.css")

if (file.exists(extra_css)) {
  stopifnot(
    file.copy(
      extra_css,
      file.path(staged, "pkgdown"),
      overwrite = TRUE
    )
  )
}

# ------------------------------------------------------------
# 5. Copy tutorial articles
# ------------------------------------------------------------

dir.create(file.path(staged, "vignettes"))

articles <- list.files(
  file.path(script_root, "articles"),
  all.files = TRUE,
  no.. = TRUE,
  full.names = TRUE
)

if (length(articles)) {
  stopifnot(
    all(
      file.copy(
        articles,
        file.path(staged, "vignettes"),
        recursive = TRUE,
        overwrite = TRUE
      )
    )
  )
}

# ------------------------------------------------------------
# 6. Configure MicroFun homepage logo
# ------------------------------------------------------------

# The logo is already copied from assets/logo.png
# to pkgdown/assets/logo.png in Section 4.
#
# pkgdown copies this asset to the website root,
# where index.md references it using src="logo.png".
#
# Avoid adding the logo to man/figures because
# pkgdown may call the external favicon API.

logo_source <- file.path(script_root, "assets", "logo.png")

if (!file.exists(logo_source)) {
  warning("Homepage logo not found: assets/logo.png")
} else {
  message("Homepage logo found: ", logo_source)
}

# Remove package-level logos from the temporary build only.
# This prevents automatic favicon generation.
# The original MicroFun source is not modified.

for (logo_name in c("logo.png", "logo.svg")) {
  staged_logo <- file.path(staged, "man", "figures", logo_name)
  
  if (file.exists(staged_logo)) {
    file.remove(staged_logo)
  }
}
# ------------------------------------------------------------
# 7. Build website using pkgdown
# ------------------------------------------------------------

message("Source: ", input)
message("MicroFun version: ", metadata[1, "Version"])

message(
  if (full) {
    "Full build: installing package and running reference examples."
  } else {
    "Preview build: reference examples are displayed without execution."
  }
)

pkgdown::build_site(
  pkg = staged,
  override = list(
    destination = file.path(run_root, "site")
  ),
  examples = full,
  install = full,
  new_process = full,
  devel = FALSE,
  preview = FALSE,
  quiet = FALSE
)

# ------------------------------------------------------------
# 8. Copy generated website to docs/
# ------------------------------------------------------------

destination <- file.path(script_root, "docs")

# Keep the preview directory stable.
# Moving a synced directory can interfere with running previews.

dir.create(
  destination,
  recursive = TRUE,
  showWarnings = FALSE
)

# Remove generated pages whose topics/articles were retired from the current source.
# Keep other assets and the stable preview directory intact.
for (section in c("reference", "articles")) {
  fresh_pages <- list.files(file.path(run_root, "site", section),
                            pattern = "[.]html$", full.names = FALSE)
  old_pages <- list.files(file.path(destination, section),
                          pattern = "[.]html$", full.names = FALSE)
  retired_pages <- setdiff(old_pages, fresh_pages)
  if (length(retired_pages)) {
    unlink(file.path(destination, section, retired_pages))
    message("Removed retired ", section, " pages: ", paste(retired_pages, collapse = ", "))
  }
}

site_entries <- list.files(
  file.path(run_root, "site"),
  all.files = TRUE,
  no.. = TRUE,
  full.names = TRUE
)

stopifnot(
  all(
    file.copy(
      site_entries,
      destination,
      recursive = TRUE,
      overwrite = TRUE,
      copy.mode = FALSE
    )
  )
)

# Disable Jekyll processing for GitHub Pages.

stopifnot(
  file.create(
    file.path(destination, ".nojekyll")
  )
)

# ------------------------------------------------------------
# 9. Verify logo and generated homepage
# ------------------------------------------------------------

generated_logo <- file.path(destination, "logo.png")
generated_homepage <- file.path(destination, "index.html")

if (file.exists(generated_logo)) {
  message("Logo available: ", generated_logo)
} else {
  warning("Logo was not found at the website root.")
}

if (file.exists(generated_homepage)) {
  
  homepage_html <- readLines(
    generated_homepage,
    warn = FALSE
  )
  
  if (any(grepl("microfun-home-logo", homepage_html, fixed = TRUE))) {
    message("Homepage logo reference found.")
  } else {
    warning("Homepage does not contain microfun-home-logo.")
  }
  
}

message("Website ready: ", generated_homepage)
