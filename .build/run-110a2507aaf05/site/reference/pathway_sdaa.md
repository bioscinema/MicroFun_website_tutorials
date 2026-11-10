# Stratified pathway-level DAA workflow for PICRUSt2 outputs

Given a PICRUSt2 stratified table (columns `sample`, `taxon`,
`function`, `taxon_function_abun`) and a `phyloseq` object, the
function:

1.  validates overlap of samples and taxa,

2.  aggregates ASV-level contributions to a chosen taxonomic rank
    (`taxon_level`) *or* groups by each `function`,

3.  constructs wide matrices (rows = function IDs; cols = samples),

4.  filters tables to ensure at least two groups and sufficient samples,

5.  runs
    [`pathway_daa()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/pathway_daa.md)
    on each table,

6.  annotates significant results using
    [`MicroFun::pathway_annotation()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/pathway_annotation.md)
    or
    [`result_annotation()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/result_annotation.md)
    depending on `direction/pathway`.

## Usage

``` r
pathway_sdaa(
  stratified_path,
  physeq,
  taxon_level = "Genus",
  group,
  daa_method = "Maaslin2",
  p.adjust.method = "none",
  threshold = 0.05,
  direction = "taxa",
  pathway = "KO",
  confounders = NULL,
  reference = NULL,
  min_samples = 5,
  verbose = TRUE,
  kegg_map = NULL
)
```

## Arguments

- stratified_path:

  Character scalar. Path to the stratified PICRUSt2 file (tab-delimited)
  containing columns `sample`, `taxon`, `function`, and
  `taxon_function_abun`. For inputs without this abundance column,
  `norm_taxon_function_contrib` is accepted for non-KEGG analyses with a
  compatible DAA method.

- physeq:

  A `phyloseq` object with both `tax_table` (ASV rows) and
  `sample_data`.

- taxon_level:

  Character scalar. Taxonomic rank used to aggregate ASVs when
  `direction = "taxa"` (e.g., `"Genus"`). Must exist in
  `phyloseq::tax_table(physeq)`.

- group:

  Character scalar. Column name in `sample_data(physeq)` for the primary
  grouping variable. Coerced to factor; optionally releveled via
  `reference`.

- daa_method:

  Character scalar. DAA backend passed to
  [`pathway_daa()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/pathway_daa.md)
  (e.g., `"Maaslin2"`, `"edgeR"`, `"DESeq2"`, `"limma voom"`,
  `"metagenomeSeq"`, `"Lefser"`).

- p.adjust.method:

  Character scalar. Multiple-testing adjustment method forwarded to
  [`pathway_daa()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/pathway_daa.md)
  (e.g., `"none"`, `"BH"`).

- threshold:

  Numeric. Significance cutoff used during result annotation (typically
  FDR/q-value threshold). Default: `0.05`.

- direction:

  Character. One of `"taxa"` or `"function"`. If `"taxa"`, ASV
  contributions are aggregated to `taxon_level` and analyzed per-taxon
  table. If `"function"`, tables are built per function (KO/EC/MetaCyc)
  across taxa.

- pathway:

  Character. Functional namespace of `function` IDs: `"KO"`, `"EC"`,
  `"MetaCyc"`, or `"KEGG"`. With `direction = "taxa"`, KO input is
  summarized by KEGG membership, and KEGG input uses PICRUSt2 pathway
  contributions directly.

- confounders:

  Optional. Confounding covariates to adjust for in DAA backends that
  support them. May be:

  - a character vector of column names found in `sample_data(physeq)`,

  - a numeric/character vector (single confounder),

  - or a `data.frame` of covariates (one column per variable).

  *Note:* This argument is prepared here; use depends on the selected
  analysis backend.

- reference:

  Optional character. Reference level for `group`; if present, `group`
  is releveled accordingly.

- min_samples:

  Integer. Require strictly more than `min_samples` samples (after
  metadata filtering) in a per-table subset to run DAA. Default: `5`.

- verbose:

  Logical. If `TRUE`, print progress messages. Default `TRUE`.

- kegg_map:

  Optional PICRUSt2 mapping TSV or named member list passed to
  [`ko2kegg_abundance()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/ko2kegg_abundance.md)
  when summarizing KO input.

## Details

Build per-`taxon` or per-`function` abundance tables from a stratified
PICRUSt2 file and run differential abundance analysis (DAA), with
optional annotation to KEGG/EC/MetaCyc names. Supports adjusting the
modeling design with confounders via backends that accept them (e.g.,
MaAsLin2).

## Examples

``` r
if (FALSE) { # \dontrun{
stratified_path <- "pred_metagenome_contrib.tsv"
# Minimal inputs
out <- pathway_sdaa(
  stratified_path = stratified_path,
  physeq          = physeq_obj,
  taxon_level     = "Genus",
  group           = "Group",
  daa_method      = "Maaslin2",
  p.adjust.method = "BH",
  threshold       = 0.05,
  direction       = "taxa",
  pathway         = "KO",
  confounders     = c("Age","Sex"),
  reference       = "Control",
  min_samples     = 5
)

# Function-centric EC analysis:
out_fun <- pathway_sdaa(
  stratified_path = stratified_path,
  physeq          = physeq_obj,
  taxon_level     = "Genus",
  group           = "Group",
  daa_method      = "edgeR",
  direction       = "function",
  pathway         = "EC"
)
} # }
```
