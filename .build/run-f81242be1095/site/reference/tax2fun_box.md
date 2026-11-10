# Plot Functional Abundance Boxplots for Driving Taxa

This function generates boxplots of stratified functional pathway
abundances (from PICRUSt2 output) at a specified taxonomic level for
each driving taxon, grouped by a metadata variable.

## Usage

``` r
tax2fun_box(
  stratified_path,
  pathway_sdaa_result,
  physeq,
  taxon_level = NULL,
  group,
  kegg_map = NULL
)
```

## Arguments

- stratified_path:

  Path to the stratified output file from PICRUSt2 (typically
  \`\*\_strat.tsv\`).

- pathway_sdaa_result:

  A named list of data.frames containing differential results (with
  \`feature\` and optionally \`pathway_name\`) for each taxon.

- physeq:

  A \`phyloseq\` object containing the microbial abundance table,
  taxonomy, and sample metadata.

- taxon_level:

  A string indicating the taxonomic level to aggregate functions by
  (e.g., \`"Genus"\`, \`"Family"\`). Inferred from recorded analysis
  settings; otherwise \`"Genus"\`.

- group:

  A string specifying the sample metadata column used for grouping in
  boxplots.

- kegg_map:

  Optional PICRUSt2 mapping TSV or named member list. Defaults to the
  mapping recorded in the SDAA result or the package reference.

## Value

A named list of \`ggplot2\` boxplot objects, one for each taxon with
matching functional results.

## Details

This function:

- Parses PICRUSt2 stratified output and maps ASVs to their taxonomic
  levels.

- Aggregates function abundances at the taxon level.

- Filters and matches functions found in the user-provided differential
  result per taxon.

- Generates and returns a list of ggplot boxplots of function abundance
  by group.

## Examples

``` r
if (FALSE) { # \dontrun{
plot_list <- tax2fun_box(
  stratified_path = "ko_metagenome_out/pred_metagenome_contrib.tsv",
  pathway_sdaa_result = diff_results,
  physeq = my_phyloseq,
  taxon_level = NULL,
  group = "disease_status"
)
plot_list$Bacteroides  # View boxplot for Bacteroides genus
} # }
```
