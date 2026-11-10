# Stratified PICRUSt2 analysis with inputs and two SDAA directions

A change in a community-level function can arise in several ways. A few
contributors may increase, many may shift together, or one set of taxa
may replace another while the total remains similar. We use stratified
PICRUSt2 output to keep the contributor information needed to
investigate those patterns.

Our aim is to carry the same biological question through data
preparation, statistical testing and plotting. That means deciding on
the cohort, comparison and taxonomic rank before fitting, then using
those choices consistently when drawing the figures.

## Generate stratified PICRUSt2 output

Use representative ASV sequences and the corresponding feature table to
obtain the contribution table.

``` bash
picrust2_pipeline.py \
  -s rep_seqs.fna \
  -i feature-table.tsv \
  -o picrust2_out \
  -p 8 \
  --stratified
```

Use the appropriate `*_contrib.tsv.gz` output in the checks below.
Replace example file paths and group names with those from your study.

## Keep the links intact

The contribution table tells us which ASV contributes to which function
in each sample. The phyloseq object supplies the corresponding taxonomy
and sample groups. If those identifiers do not match, the analysis
cannot reliably connect a contribution to its taxon or cohort.

Keep the ASV identifiers until MicroFun performs the requested
aggregation. Aggregating the phyloseq object to genus first can remove
the identifiers needed to match the original contribution table and tree
tips.

## Prepare the stratified inputs

Table 1. Stratified inputs

| Input | What MicroFun expects |
|----|----|
| PICRUSt2 contribution table | A tab-delimited long table, optionally gzipped, with `sample`, `taxon`, `function`, and `taxon_function_abun`. Typical filenames include `pred_metagenome_contrib.tsv.gz` and `KO_contrib.tsv.gz`. |
| ASV-level `phyloseq` object | ASV identifiers in its taxonomy rows, a `Genus` or `Class` column, and a metadata column for the comparison. Keep ASV identifiers until MicroFun aggregates them. |
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
# ps <- subset_samples(ps, Cohort == "Cohort_A")
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

## Which direction matches your question?

A taxon-centered analysis starts with a microbial contributor and asks
about its predicted functional differences. A function-centered analysis
starts with a functional feature and asks about its contributors. These
views are useful together, but they are not two orientations of one
fitted model.

## Fit the two SDAA directions

Table 2. The two SDAA directions

| Settings with KO input | Question | Result keys | Features within each table |
|----|----|----|----|
| `direction = "taxa", pathway = "KO"` | Within each genus, which predicted KEGG pathways differ by group? | Genus | KEGG pathway IDs such as `ko00010` |
| `direction = "function", pathway = "KO"` | For each KO, which genera contribute differently by group? | KO ID | Genus |

`taxon_level = "Class"` aggregates ASVs to class in either direction.
Set the rank before fitting and use the same rank and sample subset for
plots. To analyze a stratified table already containing KEGG pathway
IDs, use `direction = "taxa", pathway = "KEGG"`.

For the first KO route, MicroFun sums the contributions of mapped member
KOs for each KEGG pathway before fitting, then queries KEGG for
annotation. It uses the bundled membership mapping unless you pass
`kegg_map`. When you supply a custom mapping, retain it with the
analysis inputs for reproducibility. A KO can belong to multiple
pathways, so totals across pathways can include overlapping
contributions.

The taxon-centered KO call below needs internet access for KEGG
annotation, even though KO-to-pathway membership is read locally. The
function-centered KO call retains KOs and does not invoke this pathway
annotation step. Academic users do not need a KEGG API key; the requests
are handled by `KEGGREST`. A custom `kegg_map` changes the local
membership table, not the need for annotation access. See [local mapping
and online
annotation](https://bioscinema.github.io/MicroFun_website_tutorials/articles/installation.html#kegg-mapping-and-annotation).

``` r

result_taxa <- pathway_sdaa(
  stratified_path = strat_path, physeq = ps,
  taxon_level = rank, group = group_col,
  direction = "taxa", pathway = "KO",
  daa_method = "Maaslin2", reference = reference,
  p.adjust.method = "BH", threshold = 0.05
)

result_fun <- pathway_sdaa(
  stratified_path = strat_path, physeq = ps,
  taxon_level = rank, group = group_col,
  direction = "function", pathway = "KO",
  daa_method = "Maaslin2", reference = reference,
  p.adjust.method = "BH", threshold = 0.05
)
```

With `Maaslin2`, you can pass metadata column names such as
`confounders = c("Age", "Batch")` to account for covariates. MicroFun
uses total-sum scaling and an arcsine square-root transformation with
this backend. Here `group1` is the reference and `group2` the target.
Positive `logFC` values are positive model coefficients for the target
relative to the reference. In this backend the column stores AST
coefficients. Check `effect_type` when interpreting or reporting the
estimates.

The reference group anchors the interpretation of an effect. Decide that
direction explicitly instead of inferring it later from the order of
group names or the colour of a ribbon. With covariates, the coefficient
describes the modeled association conditional on the variables included;
it is not a causal effect.

BH is applied within each fitted table. The two KO workflows retain rows
with `p_adjust < threshold` in their result lists. Each direction fits
its own models and defines a separate collection of tests.

``` r

out <- "MicroFun_results"
dir.create(out, showWarnings = FALSE)
saveRDS(result_taxa, file.path(out, "sdaa_taxa.rds"))
saveRDS(result_fun, file.path(out, "sdaa_function.rds"))

attr(result_taxa, "microfun")[c("taxon_level", "direction", "function_level")]
head(result_taxa[[1]])
head(result_fun[[1]])

utils::write.table(
  dplyr::bind_rows(result_taxa, .id = "taxon"),
  file.path(out, "sdaa_taxa.tsv"), sep = "\t", quote = FALSE, row.names = FALSE
)
utils::write.table(
  dplyr::bind_rows(result_fun, .id = "function_id"),
  file.path(out, "sdaa_function.tsv"), sep = "\t", quote = FALSE, row.names = FALSE
)
```

Use the RDS files to resume plotting. They retain the named lists and
the `microfun` attribute, including the analysis rank and direction.

## Read the results before plotting

Inspect a few result tables and their recorded settings. Do the keys
describe the taxa or functions you expected? Does the saved rank agree
with your question? If a result list is empty, review the sample checks,
model messages and threshold before trying to force a plot.

Adjustment is applied within each fitted table, not as one global
correction across both analysis directions. Keep that scope clear when
comparing or reporting findings from multiple taxa and functions.

## Reuse the plotting examples

After fitting, run the plot sections with your new `result_taxa`,
`result_fun`, `strat_path` and `ps`. Use names from `names(result_taxa)`
or `names(result_fun)` when selecting a plot or filtering a Chord. For a
phylogeny Sankey, replace the demo tree with a matching tree from your
study. For Chord, adapt the example annotation table to your selected
IDs or omit `function_table` to use automatic annotation.

For community-level visualizations, pass a feature-by-sample abundance
matrix and matching metadata. Use
[`pathway_daa()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/pathway_daa.md)
to fit sample-level tests for the error-bar plot. To sum an unstratified
KO table into KEGG pathways, pass a data frame with KO IDs in its first
column to `ko2kegg_abundance(data = ...)`.

See the [stratified
demonstration](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.md)
for the complete set of example plots.
