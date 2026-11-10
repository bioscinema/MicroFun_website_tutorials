# Sankey diagram: functions (KO/EC/MetaCyc) to taxa/features

The input `pathway_sdaa_result` must be a \*\*named list\*\* where names
are function IDs (KO/EC/MetaCyc), and each element is a data frame
containing at least `feature` (target/taxon), `logFC`, and one
multiple-testing column (e.g., `p_adjust`, `padj`, `qval`, `FDR`). The
function:

1.  normalizes function IDs (e.g., strips `'ko:'`, `'ec:'`),

2.  (optionally) maps IDs to higher-level groups using reference tables
    shipped in MicroFun (`inst/extdata/*_reference.RData`),

3.  assembles edges *source to target* (group or function → taxon),

4.  uses one unit of width per retained association,

5.  colors links by direction (Up/Down), and

6.  returns an interactive networkD3 sankey widget.

## Usage

``` r
fun2tax_sankey(
  pathway_sdaa_result,
  pathway = c("KO", "EC", "MetaCyc"),
  group_functions = TRUE,
  taxa_list = NULL,
  node_color = c(Up = "#F5BB7C", Down = "#B4CBE0"),
  node_neutral = NULL,
  label_left_sources = TRUE,
  margin = list(top = 10, right = 200, bottom = 10, left = 180),
  height = 1200,
  width = 1000,
  taxon_palette = microfun_palette("taxa"),
  function_palette = microfun_palette("function"),
  taxon_groups = NULL,
  tree_mode = c("none", "taxonomy", "phylogeny"),
  physeq = NULL,
  taxonomy = NULL,
  phylo_tree = NULL,
  tree_file = NULL,
  picrust2_dir = NULL,
  taxon_level = NULL,
  taxonomy_ranks = NULL,
  tree_tip_level = c("ASV", "taxon"),
  show_branch_length = TRUE,
  missing_taxa = c("error", "drop"),
  tree_options = list(),
  phylogeny_order = c("median", "first")
)
```

## Arguments

- pathway_sdaa_result:

  Named list. Names are function IDs (KO/EC/MetaCyc). Each element is a
  data frame with columns including:

  - `feature`: target/taxon (e.g., genus) label,

  - `logFC`: signed effect estimate,

  - a q/p-adjust column (any of: `p_adjust`, `padj`, `qval`, `q_value`,
    `qvalue`, `p.adj`, `FDR`, `p_adj`).

- pathway:

  Character. Functional namespace of the names in `pathway_sdaa_result`;
  one of `'KO'`, `'EC'`, `'MetaCyc'`.

- group_functions:

  Logical. If `TRUE`, map function IDs to higher groups before linking
  to taxa (KO to `PathwayL1`; EC/MetaCyc to `description`). Requires
  reference files in MicroFun's `inst/extdata`.

- taxa_list:

  Optional character vector. If provided, keep only edges whose *source*
  (group label or function ID) matches one of these entries.

- node_color:

  Named character vector of length 2 with colors for link groups: names
  must be `c('Up','Down')`. Default: orange for Up (`'#F5BB7C'`), blue
  for Down (`'#B4CBE0'`).

- node_neutral:

  Optional single colour overriding both node palettes. NULL (default)
  uses the light taxa and dark function palettes.

- label_left_sources:

  Logical. If `TRUE`, left-side node labels are right-aligned and
  wrapped via JavaScript for readability. Default `TRUE`.

- margin:

  Named list with pixel margins `top`, `right`, `bottom`, `left`. Passed
  to `networkD3::sankeyNetwork()`.

- height, width:

  Numeric. Output size in pixels for the widget canvas.

- taxon_palette:

  Light taxon colours; optionally named by colour category.

- function_palette:

  Dark function colours; optionally named by category.

- taxon_groups:

  Optional named character vector mapping each taxon name to a taxonomy
  category such as Phylum. Without it, taxa are coloured by name.

- tree_mode:

  Side tree: 'none' (networkD3), 'taxonomy', or 'phylogeny'.

- physeq:

  Optional phyloseq object with original ASV taxonomy/tree.

- taxonomy:

  Taxonomy data.frame/matrix; ASV row names or ASV/FeatureID column.

- phylo_tree:

  A phylo object or named list of independent phylo trees.

- tree_file:

  Newick file path(s). Each file must contain one tree.

- picrust2_dir:

  PICRUSt2 output folder. Prefers reduced domain trees, then out.tre.

- taxon_level:

  Rank inferred from recorded analysis settings; otherwise Genus. Use
  'ASV' for ASV IDs.

- taxonomy_ranks:

  Ordered ranks used for the taxonomic side tree; NULL uses available
  ancestors.

- tree_tip_level:

  'ASV' matches tree tips to taxonomy row IDs; 'taxon' requires already
  taxon-labelled tips.

- show_branch_length:

  Use available phylogenetic branch lengths; otherwise topology only.

- missing_taxa:

  'error' (default) or 'drop' for taxa without matched tree tips.

- tree_options:

  Named list: title, subtitle, font_size, font_family, tree_width,
  node_width, node_gap, show_tip_labels, tree_colour, link_opacity. Also
  accepts aggregate_links, collapse_clades, bundle_mapping and
  show_footer.

- phylogeny_order:

  Taxon ordering in phylogeny mode: 'median' (default) uses the median
  displayed ASV tip position; 'first' uses the first tip position.
  Median ties use the first tip position. Tree topology determines tip
  order. Used only in phylogeny mode.

## Details

Build an interactive Sankey diagram linking functional features (KO, EC,
or MetaCyc IDs) — optionally grouped to higher-level categories — to
taxa or features reported in differential analysis results (e.g., from
[`pathway_sdaa()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/pathway_sdaa.md)).

## Examples

``` r
if (FALSE) { # \dontrun{
# Minimal toy example
sdaa_list <- list(
  K00001 = data.frame(feature = c('GenusA','GenusB'),
                      logFC = c( 1.1, -0.4),
                      p_adjust = c(0.02, 0.3)),
  K00002 = data.frame(feature = c('GenusB','GenusC'),
                      logFC = c(-1.6,  0.5),
                      p_adjust = c(0.01, 0.7))
)

# Function to taxon (no grouping)
p1 <- fun2tax_sankey(sdaa_list, pathway = 'KO', group_functions = FALSE)
p1

# Group functions to higher-level categories (requires reference files)
p2 <- fun2tax_sankey(sdaa_list, pathway = 'KO', group_functions = TRUE)
p2
} # }
```
