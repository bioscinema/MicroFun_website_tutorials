# Prepare your own data

Use this page when adapting MicroFun to your own study. If you want to
try the published example first, start with [Study data and
downloads](https://bioscinema.github.io/MicroFun_website_tutorials/articles/study-data.md),
then follow
[Standard](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.md)
or
[Stratified](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.md).

The shared workflow supports Phylum, Class, Order, Family, Genus and
Species when annotations are available. The demonstration uses Genus;
the downloaded Species column is empty, so its deepest usable rank is
Genus. Keep the original ASV-level object and change `rank` before
refitting.

## Choose the PICRUSt2 output

A standard table pools predicted contributions within each sample. A
stratified table keeps the ASV–function–sample links needed for
contributor analysis.

| Your question | Required input | Continue with |
|----|----|----|
| Which community functions differ between groups? | Unstratified feature-by-sample matrix and sample metadata | [Standard study](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.md) |
| Which functions differ within a taxon, or which taxa contribute differently to a function? | Stratified contributions and ASV-level phyloseq object, with a matching tree for phylogeny views | [Stratified study](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.md) |

## Generate PICRUSt2 output

Start with representative ASV sequences and a matching feature table.
The sequence identifiers must agree with the feature-table rows. For
PICRUSt2 installation and full options, use the [official
documentation](https://huttenhower.sph.harvard.edu/picrust/).

``` bash
picrust2_pipeline.py \
  -s dna-sequences.fasta \
  -i feature-table.biom \
  -o picrust2_out \
  -p 8
```

Add `--stratified` when you need contributor tables. Retain the ASV
taxonomy, sample metadata and phylogenetic tree from your sequence
analysis alongside these outputs.

Typical community-level files include
`KO_metagenome_out/pred_metagenome_unstrat.tsv`,
`EC_metagenome_out/pred_metagenome_unstrat.tsv` and
`pathways_out/path_abun_unstrat.tsv`. The first column holds feature IDs
and the remaining columns hold sample abundances. Contribution tables
are long tables, typically named `pred_metagenome_contrib.tsv.gz`.

## Check a community-level table

Read your KO file and metadata, then select the same samples in both.
Replace these paths and group names with your own. Keep feature IDs as
matrix row names.

``` r
library(MicroFun)

meta <- read.delim("my_study/metadata.tsv", check.names = FALSE)
ko_table <- read.delim(
  "picrust2_out/KO_metagenome_out/pred_metagenome_unstrat.tsv",
  check.names = FALSE
)
ko_table[[1]] <- sub("^ko:", "", ko_table[[1]], ignore.case = TRUE)
reference <- "Control"
target <- "Treatment"
meta <- meta[meta$group %in% c(reference, target), , drop = FALSE]
meta$group <- factor(meta$group, levels = c(reference, target))
stopifnot(!anyDuplicated(meta$sample_name),
          !anyDuplicated(ko_table[[1]]),
          all(meta$sample_name %in% names(ko_table)[-1]),
          all(table(meta$group) > 0))
ko_abundance <- as.matrix(ko_table[, meta$sample_name, drop = FALSE])
rownames(ko_abundance) <- ko_table[[1]]
stopifnot(is.numeric(ko_abundance), all(is.finite(ko_abundance)),
          all(ko_abundance >= 0))
ko_table <- data.frame(
  function_id = rownames(ko_abundance),
  as.data.frame(ko_abundance, check.names = FALSE), check.names = FALSE
)
kegg_abundance <- ko2kegg_abundance(data = ko_table)
```

Continue from [Fit and annotate the
comparison](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.html#fit-and-annotate-the-comparison)
using these objects and your own output directory. Replace the
demonstration feature lists with IDs from your study when making
selected-feature plots.

The conversion uses a bundled local KO-to-KEGG membership map. Online
pathway annotation is a separate operation. See [mapping and network
access](https://bioscinema.github.io/MicroFun_website_tutorials/articles/installation.html#kegg-mapping-and-annotation)
before changing reference inputs.

## Keep the links intact

The contribution table tells us which ASV contributes to which function
in each sample. The phyloseq object supplies the corresponding taxonomy
and sample groups. If those identifiers do not match, the analysis
cannot reliably connect a contribution to its taxon or cohort.

Keep the ASV identifiers until MicroFun performs the requested
aggregation. Aggregating the phyloseq object to the analysis rank first
can remove the identifiers needed to match the original contribution
table and tree tips.

## Prepare the stratified inputs

Table 1. Stratified inputs

| Input | What MicroFun expects |
|----|----|
| PICRUSt2 contribution table | A tab-delimited long table, optionally gzipped, with `sample`, `taxon`, `function`, and `taxon_function_abun`. Typical filenames include `pred_metagenome_contrib.tsv.gz` and `KO_contrib.tsv.gz`. |
| ASV-level `phyloseq` object | ASV identifiers in its taxonomy rows, a populated column for the chosen rank, and a metadata column for the comparison. Keep ASV identifiers until MicroFun aggregates them. |
| Optional phylogenetic tree | ASV tip labels matching the taxonomy row names. A tree in `phyloseq` or an explicit Newick file can be used. |

The `taxon` column contains ASV IDs. The `function` column contains IDs
in the selected namespace, such as `K00844` for KO. Use raw predicted
`taxon_function_abun` for KO-to-KEGG and direct KEGG runs. Some other
modes accept `norm_taxon_function_contrib` with a compatible backend.
Keep contributions finite and nonnegative.

``` r
library(phyloseq)

strat_path <- "my_study/KO_contrib.tsv.gz"
ps <- readRDS("my_study/phyloseq_asv.rds")
group_col <- "group"
rank <- "Genus"
reference <- "Control"
target <- "Treatment"

# For an .RData file containing an object named ps, use this load pattern.
# input <- new.env()
# load("my_study/phyloseq_asv.RData", envir = input)
# ps <- input$ps

# If needed, subset the cohort before the checks below.
# ps <- prune_samples(sample_data(ps)$Cohort == "Cohort_A", ps)
# ps <- prune_taxa(taxa_sums(ps) > 0, ps)

stopifnot(file.exists(strat_path), inherits(ps, "phyloseq"))
meta <- data.frame(sample_data(ps))
taxonomy <- as(tax_table(ps), "matrix")
stopifnot(group_col %in% names(meta), rank %in% colnames(taxonomy))

selected <- rownames(meta)[meta[[group_col]] %in% c(reference, target)]
ps <- prune_samples(selected, ps)
meta <- data.frame(sample_data(ps))
group_counts <- table(factor(meta[[group_col]], levels = c(reference, target)))
print(group_counts)
stopifnot(all(group_counts > 0), sum(group_counts) > 5L)

ids <- data.table::fread(strat_path, select = c("sample", "taxon"),
                         colClasses = "character", showProgress = FALSE)
missing_samples <- setdiff(sample_names(ps), ids$sample)
selected_asvs <- unique(ids$taxon[ids$sample %in% sample_names(ps)])
matched_asvs <- intersect(taxa_names(ps), selected_asvs)
print(c(missing_samples = length(missing_samples),
        matched_asvs = length(matched_asvs),
        contribution_asvs = length(selected_asvs)))
stopifnot(length(missing_samples) == 0L, length(matched_asvs) > 0L)
rm(ids)
```

Review the overlap before fitting. If IDs use different prefixes or
representations, reconcile them from a verified sample or ASV mapping.
Extra samples in a contribution file can remain when you analyze a
`phyloseq` subset. Every selected sample must appear somewhere in the
file. The default `min_samples = 5` requires more than five eligible
samples in a table, with at least two groups represented.

## Continue with your own inputs

Reuse the preparation logic in the [Stratified
study](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.html#prepare-the-data-and-project-selections),
replacing its study-loading lines with the checked `ps`, `strat_path`,
rank and contrast above. Replace `keep_genera` and `keep_kos` with
selections suited to your project. The remaining preparation creates
`ps_taxa`, `taxa_strat_path` and `fun_strat_path` before either analysis
is fitted. For a rank other than Genus, the demonstrated preparation
uses all assigned taxa at that rank.

Fit the taxon-centered direction first. The optional function-centered
route uses the full `ps` and only the selected functions. Always select
functions before fitting and plotting; analyzing an entire function
library can take substantially longer. Keep the original ASV tree in
`ps` for phylogeny views.

Use [Differential analysis
options](https://bioscinema.github.io/MicroFun_website_tutorials/articles/analysis-options.md)
to choose a method suited to your data and design. After fitting, use
[Visualization
guides](https://bioscinema.github.io/MicroFun_website_tutorials/articles/plotting-setup.md)
for figure selection, parameters and export. These guides work with your
fitted study objects as well as the demonstration results.
