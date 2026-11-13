# Installation, dependencies and software versions

## Software and version policy

Table 1. Software requirements

| Software | Version used or required | Version policy |
|----|----|----|
| MicroFun | Source package | Package documented on this website |
| R | Latest stable release compatible with the chosen Bioconductor release | Not pinned |
| RStudio (optional) | Latest stable release | Not pinned |
| vegan | **2.7.2** (CRAN package spelling **2.7-2**) | **Fixed version** |
| Other CRAN/Bioconductor dependencies | Latest compatible release | Not pinned |

The only dependency with an exact-version requirement is vegan. This pin
matters for the stratified workflow, where some genera have zero
contributions in individual samples. Use a fresh R session after
installing it. The [CRAN
archive](https://cran.r-project.org/src/contrib/Archive/vegan/)
distributes the required release as `vegan_2.7-2.tar.gz`; R treats
`2.7.2` and `2.7-2` as the same package version. Record the exact
versions resolved in your own analysis session with
[`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html).

## Why install from a source folder?

The source folder contains the functions, reference tables and
documentation that belong together. Installing that folder helps ensure
you are using one consistent copy. The folder itself should contain
`DESCRIPTION`; pointing R at its parent folder is a common cause of
installation errors.

## Install the source package

Download the source ZIP from the [MicroFun
repository](https://github.com/bioscinema/MicroFun_0.1.0). Extract it
into a folder containing `DESCRIPTION`, `NAMESPACE` and `R/`. Replace
`path/to/MicroFun` below with that folder. Restart R before replacing a
loaded package.

``` r
source_dir <- "path/to/MicroFun"
stopifnot(file.exists(file.path(source_dir, "DESCRIPTION")))
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")

imports <- read.dcf(file.path(source_dir, "DESCRIPTION"), fields = "Imports")[1, 1]
dependencies <- trimws(strsplit(imports, ",", fixed = TRUE)[[1]])
dependencies <- sub("[[:space:]]*\\(.*$", "", dependencies)
dependencies <- unique(c(dependencies, "KEGGREST", "R.utils", "rsvg", "qpdf", "svglite"))
BiocManager::install(setdiff(dependencies, "vegan"), ask = FALSE, update = FALSE)
install.packages(source_dir, repos = NULL, type = "source")

# Pin only vegan; keep other dependencies on compatible current releases.
remotes::install_version("vegan", version = "2.7-2",
                         repos = "https://cloud.r-project.org", upgrade = "never")
stopifnot(packageVersion("vegan") == package_version("2.7.2"))
library(MicroFun)
```

If vegan was already loaded, restart R after changing its version before
running an analysis. Installing this archived release from source
requires a working compiler toolchain. On macOS, use the matching
Fortran compiler from the [R for macOS tools
page](https://mac.r-project.org/tools/); on Windows, use the Rtools
version for your R release.

## R packages used by MicroFun

The table lists the current source imports together with vegan, which is
required by this workflow. “Latest compatible” records the version
policy, not an exact-version pin.

Table 2. R packages used by MicroFun

| Package                | Version policy                        |
|------------------------|---------------------------------------|
| `ALDEx2`               | Latest compatible release; not pinned |
| `aplot`                | Latest compatible release; not pinned |
| `ape`                  | Latest compatible release; not pinned |
| `DESeq2`               | Latest compatible release; not pinned |
| `dplyr`                | Latest compatible release; not pinned |
| `edgeR`                | Latest compatible release; not pinned |
| `GGally`               | Latest compatible release; not pinned |
| `ggplot2`              | Latest compatible release; not pinned |
| `ggh4x`                | Latest compatible release; not pinned |
| `lefser`               | Latest compatible release; not pinned |
| `limma`                | Latest compatible release; not pinned |
| `Maaslin2`             | Latest compatible release; not pinned |
| `metagenomeSeq`        | Latest compatible release; not pinned |
| `MicrobiomeStat`       | Latest compatible release; not pinned |
| `readr`                | Latest compatible release; not pinned |
| `SummarizedExperiment` | Latest compatible release; not pinned |
| `tibble`               | Latest compatible release; not pinned |
| `tidyr`                | Latest compatible release; not pinned |
| `ggprism`              | Latest compatible release; not pinned |
| `patchwork`            | Latest compatible release; not pinned |
| `circlize`             | Latest compatible release; not pinned |
| `data.table`           | Latest compatible release; not pinned |
| `ggplotify`            | Latest compatible release; not pinned |
| `magrittr`             | Latest compatible release; not pinned |
| `networkD3`            | Latest compatible release; not pinned |
| `phyloseq`             | Latest compatible release; not pinned |
| `reshape2`             | Latest compatible release; not pinned |
| `stringr`              | Latest compatible release; not pinned |
| `RColorBrewer`         | Latest compatible release; not pinned |
| `ggraph`               | Latest compatible release; not pinned |
| `igraph`               | Latest compatible release; not pinned |
| `scales`               | Latest compatible release; not pinned |
| `htmlwidgets`          | Latest compatible release; not pinned |
| `jsonlite`             | Latest compatible release; not pinned |
| `progress`             | Latest compatible release; not pinned |
| `grid`                 | Bundled with the installed R release  |
| `vegan`                | **2.7.2 / 2.7-2; fixed**              |

## Optional and website dependencies

Table 3. Optional and documentation packages

| Package     | Version policy                        |
|-------------|---------------------------------------|
| `rsvg`      | Latest compatible release; not pinned |
| `svglite`   | Latest compatible release; not pinned |
| `qpdf`      | Latest compatible release; not pinned |
| `KEGGREST`  | Latest compatible release; not pinned |
| `utils`     | Bundled with R                        |
| `knitr`     | Latest compatible release; not pinned |
| `rmarkdown` | Latest compatible release; not pinned |
| `R.utils`   | Latest compatible release; not pinned |

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

Table 4. Local reference data and KEGG network access

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
