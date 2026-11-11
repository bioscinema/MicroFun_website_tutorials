# Study data and downloads

## Study background and citation

The demonstration uses publicly available pancreatic tumor microbiome
data from [Riquelme and
colleagues](https://pubmed.ncbi.nlm.nih.gov/31398337/), *Tumor
Microbiome Diversity and Composition Influence Pancreatic Cancer
Outcomes*, Cell (2019), DOI
[10.1016/j.cell.2019.07.008](https://doi.org/10.1016/j.cell.2019.07.008).
Please cite the original paper when using these data. The downloads
below provide processed PICRUSt2 inputs for testing MicroFun. For
additional study information, contact Dr. Liangliang Zhang at
<lxz716@case.edu>.

The dataset contains 68 samples and 2,777 ASVs. The MDA discovery cohort
has 43 samples, with 22 STS and 21 LTS. The JHU validation cohort has 25
samples, with 10 STS and 15 LTS. The demonstration code defaults to MDA,
matching the 43-sample Standard figure exports. Change the cohort
explicitly to analyze JHU separately.

Table 1. Cohorts in the processed demonstration data

| Cohort               | Role         | STS | LTS | Total |
|----------------------|--------------|-----|-----|-------|
| MDA                  | Discovery    | 22  | 21  | 43    |
| JHU                  | Validation   | 10  | 15  | 25    |
| All supplied samples | Both cohorts | 32  | 36  | 68    |

Sample identifiers have been replaced consistently with `S001` to
`S068`. Metadata retain only the new sample identifier, survival group,
cohort and cohort role. Original sample aliases and sequencing run
identifiers are omitted. The same replacement is used in the abundance
tables, contribution tables, OTU table and phyloseq object.

## Choose the files for your analysis

Complete [installation and
dependencies](https://bioscinema.github.io/MicroFun_website_tutorials/articles/installation.md)
in a fresh R session before running the code below.

Start with the core archive for the [Standard
demonstration](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.md).
For the [Stratified
demonstration](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.md),
also download both KO contribution parts. The taxon-centered route
aggregates KOs into pathways; the function-centered example selects 24
candidate KOs from the same file. The dated KEGG, EC and MetaCyc
contributions are available for alternative workflows.

Table 2. Downloadable demonstration inputs

| Download | Approximate size | Contents |
|----|----|----|
| [Core data](https://bioscinema.github.io/MicroFun_website_tutorials/downloads/study/MicroFun_study_core.zip) | 2.8 MiB | All Standard profiles, deidentified metadata, phyloseq/R data, OTU table, taxonomy, ASV tree and assembly script. |
| [KEGG Stratified contributions](https://bioscinema.github.io/MicroFun_website_tutorials/downloads/study/MicroFun_study_KEGG_2026-11-04_stratified.zip) | 16.4 MiB | An alternative preaggregated KEGG pathway snapshot. |
| [KO Stratified part 1](https://bioscinema.github.io/MicroFun_website_tutorials/downloads/study/MicroFun_study_KO_stratified_part01.zip) | 80.0 MiB | First transfer part of the KO contribution table. Both parts are required. |
| [KO Stratified part 2](https://bioscinema.github.io/MicroFun_website_tutorials/downloads/study/MicroFun_study_KO_stratified_part02.zip) | 49.6 MiB | Second transfer part of the same KO contribution table. |
| [EC Stratified contributions](https://bioscinema.github.io/MicroFun_website_tutorials/downloads/study/MicroFun_study_EC_stratified.zip) | 63.0 MiB | EC contribution table. |
| [MetaCyc Stratified contributions](https://bioscinema.github.io/MicroFun_website_tutorials/downloads/study/MicroFun_study_MetaCyc_stratified.zip) | 47.0 MiB | MetaCyc contribution table. |

Use one R project folder for all three pages and keep its working
directory unchanged. Run [`getwd()`](https://rdrr.io/r/base/getwd.html)
to see where R expects the ZIP files. Download files with the filenames
shown below and leave them zipped until running the extraction code.

Each ZIP contains a folder named `MicroFun_demonstration_data`. Save
your chosen archives in the R working directory, then extract them into
the same location. The two KO parts are transfer fragments, not separate
input tables. The included script reconstructs one complete gzip file
and verifies its checksum.

``` r
# Install the software first using the installation guide.
# Use the fixed vegan release in a fresh R session.
stopifnot(requireNamespace("vegan", quietly = TRUE),
          getNamespaceVersion("vegan") == package_version("2.7.2"))

# Core data for both demonstrations.
stopifnot(file.exists("MicroFun_study_core.zip"))
unzip("MicroFun_study_core.zip", exdir = ".")

data_dir <- normalizePath("MicroFun_demonstration_data", mustWork = TRUE)
source(file.path(data_dir, "assemble-data.R"), local = new.env(), chdir = TRUE)
```

For either stratified analysis, download both KO parts and run these
additional lines.

``` r
ko_archives <- c("MicroFun_study_KO_stratified_part01.zip",
                 "MicroFun_study_KO_stratified_part02.zip")
stopifnot(all(file.exists(ko_archives)))
unzip("MicroFun_study_KO_stratified_part01.zip", exdir = ".")
unzip("MicroFun_study_KO_stratified_part02.zip", exdir = ".")
source(file.path(data_dir, "assemble-data.R"), local = new.env(), chdir = TRUE)
stopifnot(file.exists(file.path(data_dir, "stratified", "KO_contrib.tsv.gz")))
```

## Files after extraction

Table 3. Paths used by the demonstrations

| Relative path inside `MicroFun_demonstration_data` | Description |
|----|----|
| `phyloseq_asv.RData` | Objects named `ps`, `metadata`, `otu`, `taxonomy` and `phylo_tree`. |
| `metadata.tsv` | New sample identifiers, `group`, `Cohort` and `CohortRole`. |
| `otu.tsv.gz`, `taxonomy.tsv`, `asv_tree.nwk` | ASV-level abundance, taxonomy and phylogeny. |
| `standard/KO.tsv.gz` | 8,881 KO features across all 68 samples. |
| `standard/KEGG_2026-11-04.tsv.gz` | 234 KEGG pathways across all 68 samples. |
| `standard/EC.tsv.gz`, `standard/MetaCyc.tsv.gz` | 2,898 EC features and 542 MetaCyc pathways. |
| `stratified/KEGG_2026-11-04_contrib.tsv.gz` | Alternative dated pathway input, used with `pathway = "KEGG"`. |
| `stratified/KO_contrib.tsv.gz` | Reconstructed KO table for taxon-centered and function-centered analyses. |
| `standard/KO_figure_features.csv`, `standard/KEGG_figure_features.csv` | Feature selections used in the supplied figure exports. |
| `manifest.csv` | File sizes, feature counts and MD5 checksums. |

The KEGG filenames preserve the date of the supplied pathway-table
export. The underlying KO-to-pathway membership file is not included in
this download. To keep the displayed examples consistent, the Standard
and taxon-centered demonstrations aggregate KOs with the bundled
mapping. The dated 234-pathway snapshot has different coverage; it does
not reproduce the displayed KEGG PCA. With the bundled mapping and MDA
samples, the first two KEGG PCA axes explain 57.1% and 12.2%. See
[mapping and
annotation](https://bioscinema.github.io/MicroFun_website_tutorials/articles/installation.html#kegg-mapping-and-annotation)
before choosing another mapping.

## Load and select a cohort

``` r
library(phyloseq)
study <- new.env()
load(file.path(data_dir, "phyloseq_asv.RData"), envir = study)
ps <- study$ps
cohort <- "MDA"
ps <- prune_samples(sample_data(ps)$Cohort == cohort, ps)
ps <- prune_taxa(taxa_sums(ps) > 0, ps)
meta <- data.frame(sample_data(ps))
table(meta$group)
```

Standard profiles and contribution files retain all 68 samples so that
either cohort can be selected. Both demonstrations use the chosen sample
identifiers to subset the corresponding inputs.

Continue with [Demonstration Study
(Standard)](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.md),
then [Demonstration Study
(Stratified)](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.md),
using the same R project folder.

The Stratified demonstration uses Class-level aggregation to keep the
example practical. Its function-centered route selects 24 candidate KOs
motivated by disease-related questions. Standard remains a
community-level analysis. The source taxonomy supports Phylum through
Genus; its Species column is entirely unassigned.
