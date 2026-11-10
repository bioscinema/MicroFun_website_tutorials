# Sankey diagram of taxon -\> pathway-class contributions (PICRUSt2 stratified)

Builds an interactive Sankey diagram (via \*\*networkD3\*\*) showing
flows from taxa (left) to pathway superclasses (right), using
per-taxon-per-pathway differential results (e.g., PICRUSt2 stratified
output summarized by MaAsLin2). Links are colored by effect direction
(Up/Down). Node labels for left-side genera can be rendered \*\*to the
left of the rectangles\*\* for readability.

## Usage

``` r
tax2fun_sankey(
  pathway_sdaa_result,
  taxa_list = NULL,
  node_color = c(Up = "#F5BB7C", Down = "#B4CBE0"),
  node_neutral = NULL,
  label_left_sources = TRUE,
  margin = list(top = 10, right = 140, bottom = 10, left = 160),
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
  height = NULL,
  width = NULL,
  phylogeny_order = c("median", "first")
)
```

## Arguments

- pathway_sdaa_result:

  A named `list` where each name is a taxon and each element is a
  `data.frame` with at least the columns:

  - `pathway_class` Character; pathway superclass label (e.g., KEGG
    level-1).

  - `logFC` Numeric; effect sign/size used to color links (\>\\0 = Up).

  - `p_adjust` Numeric; adjusted p-value (used only for filtering in
    user code).

  Rows with `NA` in `pathway_class` are dropped.

- taxa_list:

  Optional character vector of taxon names to include. Matching is
  case-insensitive. If supplied and none match, the function errors.

- node_color:

  Named character vector of length 2 giving link/node colors for
  `c(Up, Down)` directions. Default:
  `c(Up = '#F5BB7C', Down = '#B4CBE0')`.

- node_neutral:

  Optional single colour overriding both node palettes. NULL (default)
  uses the light taxa and dark function palettes.

- label_left_sources:

  Logical; if `TRUE` (default), place taxon labels on the \*\*left\*\*
  of left-column nodes and pathway labels on the \*\*right\*\* of
  right-column nodes. Implemented with a small
  [`htmlwidgets::onRender()`](https://rdrr.io/pkg/htmlwidgets/man/onRender.html)
  D3 hook.

- margin:

  A named list with `top`, `right`, `bottom`, `left` margins (pixels)
  passed to `networkD3::sankeyNetwork()`. Increase `left` when
  `label_left_sources = TRUE` to avoid clipping.

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

- height, width:

  Optional tree-mode canvas dimensions in pixels.

- phylogeny_order:

  Taxon ordering in phylogeny mode: 'median' (default) uses the median
  displayed ASV tip position; 'first' uses the first tip position.
  Median ties use the first tip position. Tree topology determines tip
  order. Used only in phylogeny mode.

## Value

An *htmlwidget* Sankey graph (class `htmlwidget`) that can be viewed in
RStudio Viewer or a web browser, and embedded in R Markdown/Quarto.

## Details

The function constructs a long table of edges (taxon -\> pathway class),
assigns a link group `'Up'` or `'Down'` by the sign of `logFC`, builds
unique node names, and then calls `networkD3::sankeyNetwork()`. A
post-render D3 callback adjusts text anchors so that left-side labels
appear to the left of their rectangles while right-side labels remain on
the right. Nodes use the selected categorical palettes by default, and
links retain their Up/Down colours. Named palettes preserve mappings
across subsets.
