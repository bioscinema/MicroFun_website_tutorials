# Dendrogram of top stratified functions per taxon (circular)

Build a \*\*circular dendrogram\*\* that connects each selected taxon
(e.g., Genus) to its \*\*top-\|logFC\| functions\*\* from a stratified
pathway analysis result (the list returned by \`pathway_sdaa()\` or a
similar routine). Leaf nodes are function labels colored by taxon, with
point size proportional to \\\|logFC\|\\. Ranking and selection use
\*\*absolute logFC only\*\* (no p-value filtering).

## Usage

``` r
tax2fun_dendro(
  pathway_sdaa_result,
  taxa_list = NULL,
  top_n_per_genus = 5,
  wrap_width = 36,
  title = "Function dendrogram",
  point_size_range = c(1.5, 5),
  label_size = 2,
  taxon_level = NULL,
  top_n_per_taxon = top_n_per_genus
)
```

## Arguments

- pathway_sdaa_result:

  A \*\*named list\*\* where each element corresponds to a taxon (e.g.,
  Genus) and contains a \`data.frame\` of differential results with at
  least a \`logFC\` column and one label column among \`pathway_name\`,
  \`feature\`, or \`function\` (the function tries them in that order).

- taxa_list:

  Optional character vector of taxon names to include (must match names
  of \`pathway_sdaa_result\`). If \`NULL\`, all taxa in the list are
  used.

- top_n_per_genus:

  Integer. Number of functions to keep \*\*per taxon\*\* after ranking
  by \`abs(logFC)\`. Default \`5\`.

- wrap_width:

  Integer. Maximum character width for wrapping function labels. Default
  \`36\`.

- title:

  Character plot title. Default \`"Function dendrogram"\`.

- point_size_range:

  Numeric length-2 vector specifying the range of point sizes mapped to
  \\\|logFC\|\\. Default \`c(1.5, 5)\`.

- label_size:

  Numeric. Text size for leaf labels. Default \`2\`.

- taxon_level:

  Rank inferred from recorded analysis settings; otherwise Genus.

- top_n_per_taxon:

  Rank-independent alias for top_n_per_genus.

## Value

A named \`list\` with components:

- plot:

  A \`ggraph\`/\`ggplot\` object (the circular dendrogram).

- used_taxa:

  Character vector of taxa actually plotted.

- missing_taxa:

  Character vector of requested taxa not found in
  \`pathway_sdaa_result\`.

## Details

The function constructs a simple hierarchy: a root node → each selected
taxon → that taxon’s top functions. It then draws a circular dendrogram
using \*\*ggraph\*\* with edges colored by the \*\*parent taxon\*\* and
leaf points sized by \\\|logFC\|\\. Labels are wrapped to
\`wrap_width\`. \*\*Note:\*\* selection is based solely on
\`abs(logFC)\`; if you want to enforce significance, pre-filter
\`pathway_sdaa_result\` before calling this function.

## Expected columns per taxon table

- logFC:

  Numeric signed log fold-change used for ranking and point size.

- pathway_name / feature / function:

  One of these will be used as the label (in this order).

## Examples

``` r
# \donttest{
# Suppose `res_list` is a named list of per-genus differential tables
# (each with columns like: pathway_name, feature, logFC).
# p_out <- tax2fun_dendro(res_list, top_n_per_genus = 8)
# p_out$plot
# }
```
