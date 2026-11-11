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

The only dependency with an exact-version requirement is vegan. The
[CRAN archive](https://cran.r-project.org/src/contrib/Archive/vegan/)
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

Extract the source ZIP into a folder containing `DESCRIPTION`,
`NAMESPACE` and `R/`. Replace `path/to/MicroFun` below with that folder.
Restart R before replacing a loaded package.

``` r
source_dir <- "path/to/MicroFun"
stopifnot(file.exists(file.path(source_dir, "DESCRIPTION")))
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")

imports <- read.dcf(file.path(source_dir, "DESCRIPTION"), fields = "Imports")[1, 1]
dependencies <- trimws(strsplit(imports, ",", fixed = TRUE)[[1]])
dependencies <- sub("[[:space:]]*\\(.*$", "", dependencies)
dependencies <- unique(c(dependencies, "KEGGREST", "R.utils", "rsvg", "qpdf", "ComplexHeatmap"))
BiocManager::install(setdiff(dependencies, "vegan"), ask = FALSE, update = FALSE)
install.packages(source_dir, repos = NULL, type = "source")

# Pin only vegan; keep other dependencies on compatible current releases.
remotes::install_version("vegan", version = "2.7-2",
                         repos = "https://cloud.r-project.org", upgrade = "never")
stopifnot(packageVersion("vegan") == package_version("2.7.2"))
library(MicroFun)
```

If vegan was already loaded, restart R after changing its version before
running an analysis.

## R packages used by MicroFun

The following packages are declared in the MicroFun source. “Latest
compatible” records the version policy, not an exact-version pin.

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

## Optional and documentation dependencies

Table 3. Optional and documentation packages

| Package          | Version policy                        |
|------------------|---------------------------------------|
| `rsvg`           | Latest compatible release; not pinned |
| `qpdf`           | Latest compatible release; not pinned |
| `Biobase`        | Latest compatible release; not pinned |
| `KEGGREST`       | Latest compatible release; not pinned |
| `ComplexHeatmap` | Latest compatible release; not pinned |
| `BiocGenerics`   | Latest compatible release; not pinned |
| `utils`          | Bundled with R                        |
| `knitr`          | Latest compatible release; not pinned |
| `rmarkdown`      | Latest compatible release; not pinned |
| `testthat`       | Latest compatible release; not pinned |
| `forcats`        | Latest compatible release; not pinned |
| `rlang`          | Latest compatible release; not pinned |
| `R.utils`        | Latest compatible release; not pinned |
| `xml2`           | Latest compatible release; not pinned |

`rsvg` enables tree Sankey PNG/PDF export; `qpdf` enables
continuation-page PDF export; `ComplexHeatmap` is used for metagenome
comparison heatmaps. Chord SVG/HTML export uses the graphics device
available on your platform.

## Local KO–KEGG mapping and online annotation

Mapping and annotation answer different questions. The KO-to-KEGG
pathway mapping defines which KOs belong to each pathway and is used to
sum their predicted abundances. Annotation adds readable names and
categories to the resulting identifiers.

Table 4. Local reference data and KEGG network access

| Step | Data source and behaviour | KEGG connection required |
|----|----|----|
| KO-to-KEGG pathway abundance conversion | [`ko2kegg_abundance()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/ko2kegg_abundance.md) uses the bundled `ko_to_kegg_reference` by default, or a local mapping supplied through `kegg_map`. | No |
| Local KO, EC or MetaCyc descriptions | `pathway_annotation(..., ko_to_kegg = FALSE)` uses the corresponding bundled reference files. | No |
| Online KEGG pathway annotation | `pathway_annotation(..., ko_to_kegg = TRUE)` uses `KEGGREST` to query KEGG for names and classification information. Entries already queried may be reused from the current R session’s cache. | Yes |
| Bundled community visualization examples | The PCA, heatmap and error-bar examples use packaged abundance tables, metadata and supplied annotated results. | No |

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

Once the software is installed, the local-reference steps and bundled
community plotting examples can run without contacting KEGG. Initial
software installation may still require internet access. An annotation
connection failure is a reason to check network access or KEGG
availability, rather than look for a missing API key.

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

Continue with [example data and
setup](https://bioscinema.github.io/MicroFun_website_tutorials/articles/plotting-setup.md),
or [prepare your own
study](https://bioscinema.github.io/MicroFun_website_tutorials/articles/stratified-pipeline.md).
