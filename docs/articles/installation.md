# Installation, dependencies and software versions

## Install from GitHub

Install MicroFun directly from the GitHub repository.

``` r
install.packages("remotes")
remotes::install_github("bioscinema/MicroFun_0.1.0", dependencies = TRUE)
library(MicroFun)
```

### If dependency installation fails

If installation reports missing or unavailable Bioconductor
dependencies, install them with `BiocManager`, then retry installing
MicroFun. See the [Bioconductor installation
guide](https://www.bioconductor.org/install/) for repository and
installation help.

``` r
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install(
  c("ALDEx2", "DESeq2", "edgeR", "lefser", "limma", "Maaslin2", "metagenomeSeq"),
  update = FALSE, ask = FALSE
)
remotes::install_github(
  "bioscinema/MicroFun_0.1.0", dependencies = TRUE, upgrade = "never"
)
```

## Check and repair the vegan version

The workflows require **vegan 2.7.2**. Check the installed version
before starting an analysis.

``` r
packageVersion("vegan")
```

If vegan is missing or the result is not `2.7.2`, restart R and run the
following code before loading MicroFun. R reads the CRAN release name
`2.7-2` as package version `2.7.2`.

``` r
if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
remotes::install_version(
  "vegan", version = "2.7-2",
  repos = "https://cloud.r-project.org", upgrade = "never"
)
```

Restart R again after installation so a previously loaded version is not
retained in memory. Check both the installed and loaded versions in the
fresh session.

``` r
library(vegan)
stopifnot(
  packageVersion("vegan") == package_version("2.7.2"),
  getNamespaceVersion("vegan") == package_version("2.7.2")
)
library(MicroFun)
```

The archived release is available from the [CRAN vegan
archive](https://cran.r-project.org/src/contrib/Archive/vegan/).
Installing it from source requires a working compiler toolchain. On
macOS, use the matching Fortran compiler from the [R for macOS tools
page](https://mac.r-project.org/tools/); on Windows, use the Rtools
version for your R release.

## Install from a local source folder

You can also download the ZIP from the [MicroFun
repository](https://github.com/bioscinema/MicroFun_0.1.0) and extract
it. Replace `path/to/MicroFun` with the folder containing `DESCRIPTION`,
`NAMESPACE` and `R/`. Restart R before replacing a loaded package.

``` r
source_dir <- "path/to/MicroFun"
stopifnot(file.exists(file.path(source_dir, "DESCRIPTION")))
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
imports <- read.dcf(file.path(source_dir, "DESCRIPTION"), fields = "Imports")[1, 1]
dependencies <- trimws(strsplit(imports, ",", fixed = TRUE)[[1]])
dependencies <- sub("[[:space:]]*\\(.*$", "", dependencies)
dependencies <- unique(c(dependencies, "KEGGREST", "R.utils", "rsvg", "qpdf", "svglite"))
BiocManager::install(setdiff(dependencies, "vegan"), ask = FALSE, update = FALSE)
install.packages(source_dir, repos = NULL, type = "source")
```

Apply the vegan version check above after either installation route. The
version tables below document the environment used to validate the
tutorials. Only vegan has an exact-version requirement.

## R packages used by MicroFun

The table lists the installed versions of the current source imports and
vegan used in the validation environment.

Table 1. R packages used by MicroFun

| Package                | Version              |
|------------------------|----------------------|
| `ALDEx2`               | 1.42.0               |
| `aplot`                | 0.2.9                |
| `ape`                  | 5.8.1                |
| `DESeq2`               | 1.50.2               |
| `dplyr`                | 1.2.1                |
| `edgeR`                | 4.8.2                |
| `GGally`               | 2.4.0                |
| `ggplot2`              | 4.0.3                |
| `ggh4x`                | 0.3.1                |
| `lefser`               | 1.20.2               |
| `limma`                | 3.66.0               |
| `Maaslin2`             | 1.24.1               |
| `metagenomeSeq`        | 1.52.0               |
| `MicrobiomeStat`       | 1.4                  |
| `readr`                | 2.2.0                |
| `SummarizedExperiment` | 1.40.0               |
| `tibble`               | 3.3.1                |
| `tidyr`                | 1.3.2                |
| `ggprism`              | 1.0.7                |
| `patchwork`            | 1.3.2                |
| `circlize`             | 0.4.18               |
| `data.table`           | 1.18.4               |
| `ggplotify`            | 0.1.3                |
| `magrittr`             | 2.0.5                |
| `networkD3`            | 0.4.1                |
| `phyloseq`             | 1.54.2               |
| `reshape2`             | 1.4.5                |
| `stringr`              | 1.6.0                |
| `RColorBrewer`         | 1.1.3                |
| `ggraph`               | 2.2.2                |
| `igraph`               | 2.3.2                |
| `scales`               | 1.4.0                |
| `htmlwidgets`          | 1.6.4                |
| `jsonlite`             | 2.0.0                |
| `progress`             | 1.2.3                |
| `grid`                 | 4.5.3                |
| `vegan`                | **2.7.2** (required) |

## Optional and website dependencies

These installed versions support figure export, dependency installation
and website rendering.

Table 2. Optional and documentation packages

| Package       | Version |
|---------------|---------|
| `rsvg`        | 2.7.0   |
| `svglite`     | 2.2.2   |
| `qpdf`        | 1.4.1   |
| `KEGGREST`    | 1.50.0  |
| `utils`       | 4.5.3   |
| `knitr`       | 1.51    |
| `rmarkdown`   | 2.31    |
| `R.utils`     | 2.13.0  |
| `BiocManager` | 1.30.27 |
| `remotes`     | 2.5.0   |
| `pkgdown`     | 2.2.1   |

`rsvg` enables tree Sankey PNG/PDF export; `qpdf` enables
continuation-page PDF export. `svglite` is used by
[`ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html) for
the Standard SVG figures. Chord SVG/HTML uses R’s Cairo SVG device. On
macOS, if export reports a missing `/opt/X11` library or a failed Cairo
DLL, install [XQuartz](https://www.xquartz.org/) and restart R before
exporting.

## Local KO–KEGG mapping and online annotation

Mapping and annotation answer different questions. The KO-to-KEGG
pathway mapping defines which KOs belong to each pathway and is used to
sum their predicted abundances. Annotation adds readable names and
categories to the resulting identifiers.

Table 3. Local reference data and KEGG network access

| Step | Data source and behaviour | KEGG connection required |
|----|----|----|
| KO-to-KEGG pathway abundance conversion | [`ko2kegg_abundance()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/ko2kegg_abundance.md) uses the bundled `ko_to_kegg_reference` by default, or a local mapping supplied through `kegg_map`. | No |
| Local KO descriptions | Standard reads `KO` and `KoDescription` from the bundled `KO_reference.RData` dictionary and matches the KO IDs. | No |
| Local EC or MetaCyc descriptions | `pathway_annotation(..., ko_to_kegg = FALSE)` uses the corresponding bundled reference files. | No |
| Online KEGG pathway annotation | `pathway_annotation(..., ko_to_kegg = TRUE)` uses `KEGGREST` to query KEGG for names and classification information. Entries already queried may be reused from the current R session’s cache. | Yes |
| Plotting fitted study results | PCA, heatmap and error-bar calls reuse the matrices and annotation tables created in Standard. | No additional connection after annotation |

The bundled KO–KEGG mapping is a local snapshot, not a live connection
to KEGG. It does not update automatically when online annotations are
retrieved. The supplied mapping does not include a clearly identified
KEGG release or retrieval date, so it should not be described as the
latest KEGG mapping. If you supply your own mapping, retain that file
and record its source, release or retrieval date alongside the results.
Keep the same mapping for abundance aggregation, analysis and plotting.

Academic users accessing the standard KEGG REST service do not need to
apply for an API key or enter one in MicroFun. MicroFun makes the
annotation requests through `KEGGREST`; you need the package installed
and a working connection to KEGG. See the [KEGG API access
conditions](https://www.kegg.jp/kegg/rest/) and [REST interface
documentation](https://www.kegg.jp/kegg/rest/keggapi.html).

The taxon-centered stratified KO workflow performs local KO-to-pathway
aggregation, then requests online KEGG annotation as part of
[`pathway_sdaa()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/pathway_sdaa.md).
Supplying a local `kegg_map` changes the membership mapping; it does not
disable that annotation request. Taxon-centered input already containing
KEGG pathway IDs also uses online pathway annotation. The
function-centered KO workflow keeps the KO identifiers and does not
invoke this KEGG pathway annotation step.

Once the software is installed, local-reference steps and plotting saved
annotated results can run without contacting KEGG. Initial software
installation may still require internet access. An annotation connection
failure is a reason to check network access or KEGG availability, rather
than look for a missing API key.

## Before you move on

Load MicroFun in a fresh R session and check that the installation
completed without missing-package messages. If a plotting or export
function asks for an optional dependency, install the package used by
that feature rather than changing your analysis inputs. The
[troubleshooting
guide](https://bioscinema.github.io/MicroFun_website_tutorials/articles/troubleshooting.md)
separates input issues from plotting and export issues.

## Record the resolved environment

``` r
sessionInfo()
writeLines(capture.output(sessionInfo()), "MicroFun_sessionInfo.txt")
```

Continue with [Study data and
downloads](https://bioscinema.github.io/MicroFun_website_tutorials/articles/study-data.md),
or [prepare your own
study](https://bioscinema.github.io/MicroFun_website_tutorials/articles/prepare-your-data.md).

The current source also supports MaAsLin2 transformations,
mean-contribution `top_n` boxplot selection, and scientific-notation
error-bar p-value labels. See [analysis
options](https://bioscinema.github.io/MicroFun_website_tutorials/articles/analysis-options.md).
Function-centered descriptive labels in the demonstration are explicitly
supplied for presentation, not new analysis identifiers.
