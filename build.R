# Build the website from a fresh copy of a package directory or ZIP archive.
# The input package is never modified.
script_root <- local({
  source_files <- unlist(lapply(sys.frames(), function(x) x$ofile))
  cli_file <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  path <- if (length(source_files)) tail(source_files, 1) else if (length(cli_file)) {
    sub("^--file=", "", cli_file[1])
  } else "build.R"
  dirname(normalizePath(path, mustWork = TRUE))
})

args <- commandArgs(trailingOnly = TRUE)
full <- "--full" %in% args
inputs <- args[!startsWith(args, "--")]
input <- if (length(inputs)) inputs[1] else Sys.getenv(
  "MICROFUN_SOURCE", file.path(script_root, "source", "MicroFun_0.1.0.zip")
)
input <- normalizePath(input, mustWork = TRUE)

# Keep generated caches alongside the website, including in restricted sessions.
cache_root <- file.path(script_root, ".build", "cache")
dir.create(cache_root, recursive = TRUE, showWarnings = FALSE)
Sys.setenv(R_USER_CACHE_DIR = cache_root)

for (dependency in c("pkgdown", "rmarkdown", "knitr")) {
  if (!requireNamespace(dependency, quietly = TRUE)) {
    stop("Install required package: install.packages('", dependency, "')")
  }
}

# Reuse RStudio's bundled Pandoc when running outside the IDE.
if (!rmarkdown::pandoc_available()) {
  candidates <- c(
    "/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/aarch64",
    "/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/x86_64"
  )
  candidates <- candidates[file.exists(file.path(candidates, "pandoc"))]
  if (length(candidates)) Sys.setenv(RSTUDIO_PANDOC = candidates[1])
}
if (!rmarkdown::pandoc_available()) {
  stop("Pandoc is required. Run in RStudio or install Pandoc and retry.")
}

build_root <- file.path(script_root, ".build")
dir.create(build_root, showWarnings = FALSE)
run_root <- tempfile("run-", tmpdir = build_root)
dir.create(run_root)

if (dir.exists(input)) {
  package_root <- input
} else {
  archive_files <- utils::unzip(input, list = TRUE)$Name
  if (any(grepl("(^/|^[A-Za-z]:|(^|/)\\.\\.(/|$)|\\\\)", archive_files))) {
    stop("Archive contains unsafe paths.")
  }
  extracted <- file.path(run_root, "extracted")
  utils::unzip(input, exdir = extracted)
  descriptions <- list.files(extracted, pattern = "^DESCRIPTION$", recursive = TRUE,
                             full.names = TRUE)
  if (length(descriptions) != 1L) stop("Expected one R package in the archive.")
  package_root <- dirname(descriptions)
}
if (!file.exists(file.path(package_root, "DESCRIPTION"))) {
  stop("The source directory must contain DESCRIPTION.")
}
metadata <- read.dcf(file.path(package_root, "DESCRIPTION"))
if (metadata[1, "Package"] != "MicroFun") stop("Expected the MicroFun package.")

staged <- file.path(run_root, "MicroFun")
dir.create(staged)
# Omit old websites, package vignettes, and environment-specific files.
skip <- c("docs", "pkgdown", "vignettes", "renv", "renv.lock", ".git", ".github",
          ".Rproj.user", ".Rprofile", ".Renviron", ".Rhistory", ".RData", ".DS_Store",
          ".build", "outputs", "work", "MIGRATION_EXPORTS.md", "VALIDATION.md")
entries <- list.files(package_root, all.files = TRUE, no.. = TRUE, full.names = TRUE)
entries <- entries[!basename(entries) %in% skip]
if (!all(file.copy(entries, staged, recursive = TRUE))) stop("Could not copy package source.")

dir.create(file.path(staged, "pkgdown"))
stopifnot(file.copy(file.path(script_root, "_pkgdown.yml"), staged, overwrite = TRUE))
news_override <- file.path(script_root, "NEWS.md")
if (file.exists(news_override)) {
  stopifnot(file.copy(news_override, staged, overwrite = TRUE))
}
stopifnot(file.copy(file.path(script_root, "index.md"), file.path(staged, "pkgdown")))
assets <- list.files(file.path(script_root, "assets"), all.files = TRUE,
                     no.. = TRUE, full.names = TRUE)
dir.create(file.path(staged, "pkgdown", "assets"))
if (length(assets)) {
  stopifnot(all(file.copy(assets, file.path(staged, "pkgdown", "assets"), recursive = TRUE)))
}
# pkgdown loads extra.css automatically from pkgdown/extra.css.
extra_css <- file.path(script_root, "assets", "extra.css")
if (file.exists(extra_css)) {
  stopifnot(file.copy(extra_css, file.path(staged, "pkgdown"), overwrite = TRUE))
}
dir.create(file.path(staged, "vignettes"))
articles <- list.files(file.path(script_root, "articles"), all.files = TRUE,
                       no.. = TRUE, full.names = TRUE)
if (length(articles)) stopifnot(all(file.copy(articles, file.path(staged, "vignettes"), recursive = TRUE)))

message("Source: ", input)
message("MicroFun version: ", metadata[1, "Version"])
message(if (full) "Full build: installing package and running reference examples."
        else "Preview build: reference examples are displayed without execution.")
logo_source <- file.path(script_root, "assets", "logo.png")
logo_target <- file.path(staged, "man", "figures", "logo.png")

if (file.exists(logo_source)) {
  dir.create(dirname(logo_target),
             recursive = TRUE,
             showWarnings = FALSE)

  stopifnot(file.copy(logo_source, logo_target,
                      overwrite = TRUE))
pkgdown::build_site(
  pkg = staged,
  override = list(destination = file.path(run_root, "site")),
  examples = full,
  install = full,
  new_process = full,
  devel = FALSE,
  preview = FALSE,
  quiet = FALSE
)
destination <- file.path(script_root, "docs")
# Keep the preview directory stable. Moving a synced directory can race with
# background file coordination and leave a running preview without its files.
dir.create(destination, recursive = TRUE, showWarnings = FALSE)
site_entries <- list.files(file.path(run_root, "site"), all.files = TRUE,
                           no.. = TRUE, full.names = TRUE)
stopifnot(all(file.copy(site_entries, destination, recursive = TRUE,
                        overwrite = TRUE)))
stopifnot(file.create(file.path(destination, ".nojekyll")))
message("Website ready: ", file.path(script_root, "docs", "index.html"))
