# Plot function-to-taxon contributions as grouped boxplots

This function takes a stratified PICRUSt2 output table, a phyloseq
object, and a list of pathway-level results, and produces ggplot2
boxplots of function contributions summarized by taxonomic level and
experimental group.

## Usage

``` r
fun2tax_box(
  stratified_path,
  pathway_sdaa_result,
  physeq,
  group,
  taxon_level = NULL,
  pathway = c("KO", "EC", "MetaCyc"),
  value_col = NULL,
  wrap_width = 36,
  group_functions = TRUE
)
```

## Arguments

- stratified_path:

  Character string. Path to a stratified PICRUSt2 output file (typically
  \`\*\_stratified.tsv\`), containing columns for function, taxon,
  sample, and contribution values.

- pathway_sdaa_result:

  A named list of results from an SDAA (statistical differential
  abundance analysis) step, keyed by function IDs. Only names are used
  here.

- physeq:

  A [`phyloseq`](https://rdrr.io/pkg/phyloseq/man/phyloseq.html) object
  containing sample metadata and taxonomy table. Sample IDs must match
  those in `stratified_path`.

- group:

  Character scalar. Column name in sample metadata to use for grouping
  (e.g. treatment).

- taxon_level:

  Taxonomy rank inferred from the result metadata; defaults to Genus for
  legacy lists without metadata. Conflicting explicit ranks are
  rejected.

- pathway:

  Character scalar. Functional annotation scheme used: one of `"KO"`,
  `"EC"`, or `"MetaCyc"`. Defaults to "KO".

- value_col:

  Character scalar. Name of the numeric contribution column in the
  stratified table. Defaults to the column recorded in the SDAA result
  or the PICRUSt2 abundance column when available.

- wrap_width:

  Integer. Width (in characters) for line-wrapping taxon labels on the
  x-axis. Defaults to 36.

- group_functions:

  Logical. Whether to group function IDs into higher-level reference
  categories (via reference maps included in the package). Defaults to
  `TRUE`.

## Examples

``` r
if (FALSE) { # \dontrun{
# Example with KO pathway
plots <- fun2tax_box(
  stratified_path = "ko_metagenome_out_stratified.tsv",
  pathway_sdaa_result = sdaa_result,
  physeq = physeq_obj,
  group = "Treatment",
  taxon_level = NULL,
  pathway = "KO"
)
# Display first plot
print(plots[[1]])
} # }
```
