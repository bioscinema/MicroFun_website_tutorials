# Taxon-to-function visualizations

Use this guide to adjust the taxon-centered figures after fitting the
[Stratified
demonstration](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.html#taxon-centered).
The study contains the full workflow and representative results; this
page focuses on plotting controls and selections.

The demonstration defaults to Genus and selects Cloacibacterium for an
individual panel. Reuse `ps_taxa`, `taxa_strat_path`, `result_taxa_box`,
`result_taxa`, the group contrast and output directory from that study.
Choose a taxon from the fitted results when making an individual panel.

``` r
available_taxa <- names(result_taxa)[vapply(result_taxa, nrow, integer(1)) > 0L]
stopifnot(length(available_taxa) > 0L)
selected_taxon <- if ("Cloacibacterium" %in% available_taxa) "Cloacibacterium" else available_taxa[1]
```

## Sankey

Use a Sankey as an overview. Which functional categories connect to each
taxon, and where do the selected associations concentrate? Read a wide
ribbon as more displayed associations in this view. It is not a direct
abundance measurement.

The Genus demonstration starts with the 27 project-related genera. This
list is not applied to function-centered contributors.

The taxonomy side tree helps you place taxa within their classification.
The phylogeny mode instead uses relationships among the matching ASVs.
Choose the one that provides the context you want to discuss.

Taxa appear on the left and functional nodes on the right. Ribbon widths
count displayed associations. Positive effects use yellow/orange
(`#F5BB7C`); nonpositive effects use blue (`#B4CBE0`). Taxonomy and
phylogeny are optional side-tree modes.

``` r
p_tax_taxonomy <- tax2fun_sankey(
  result_taxa, tree_mode = "taxonomy", physeq = ps_taxa,
  tree_options = list(font_size = 16)
)
save_sankey(p_tax_taxonomy, file.path(out, "tax2fun_sankey.html"))


p_tax_phylogeny <- tax2fun_sankey(
  result_taxa, tree_mode = "phylogeny", physeq = ps_taxa,
  phylo_tree = phy_tree(ps_taxa)
)
```

Tree tips must match the ASV identifiers in the unagglomerated taxonomy.
The tree and taxon endpoint labels share `tree_options$font_size`; long
labels retain full hover text.

## Chord

What if you want to see how much each selected relationship contributes,
rather than how many associations were selected? Use Chord. It connects
the fitted results back to the original stratified contributions.

Balanced means give the two group means equal weight, which is useful
when group sizes differ. Read ribbon width, effect colour and outer bar
height separately. They represent contribution, direction and absolute
effect, respectively.

This preview keeps up to ten functions per taxon. Set
`max_functions_per_taxon = Inf` to include the complete association set.

Chord width is the mean predicted contribution, with equal weight
assigned to the two group means by default. Ribbon colour encodes effect
sign; outer bar height encodes absolute effect. Use the same sample
subset and rank as the fitted analysis.

In the HTML view, search for a taxon or function in the legend and click
its entry. An outline highlights the corresponding sector on its ring so
you can locate it even in a crowded diagram. Click **Clear selection**
to remove the highlight.

``` r
p_tax_chord <- tax2fun_chord(
  result_taxa, taxa_strat_path, ps_taxa, group = group_col,
  contrast = c(reference, target), max_functions_per_taxon = 10,
  draw = FALSE
)
save_chord(p_tax_chord, file.path(out, "tax2fun_chord.html"))

# Pick taxa and functions after inspecting the HTML overview.
chord_taxa <- head(unique(p_tax_chord$links$taxon), 3L)
p_tax_focus <- tax2fun_chord(
  result_taxa, taxa_strat_path, ps_taxa, group = group_col,
  contrast = c(reference, target), taxa_list = chord_taxa,
  max_functions_per_taxon = 10, draw = FALSE
)
save_chord(p_tax_focus, file.path(out, "tax2fun_chord_focus.html"))
save_chord(p_tax_focus, file.path(out, "tax2fun_chord_focus.pdf"))
head(p_tax_chord$links)
```

Functional labels use `Function name[function ID]`. Narrow sectors may
use letter codes; consult the companion label mapping CSV and legend.
Category colours encode identity, separately from signed effects. Adjust
ribbon and bar opacity using `link_alpha` and `bar_alpha`.

## Contribution boxplots

After finding an interesting relationship, look at its sample-level
distribution. Are most samples shifted, or is the apparent difference
concentrated in a few observations? A boxplot helps you inspect
variation that is hidden by the summary diagram. Use the same cohort and
taxonomic rank as the model so that the two views remain comparable.

The return value is a named list of ggplots. Blue identifies the
reference group and yellow/orange the target group for a two-group
contrast; these are group colours, not individual effect signs.

``` r
result_taxa_box <- result_taxa[selected_taxon]
attr(result_taxa_box, "microfun") <- attr(result_taxa, "microfun")
tax_boxes <- tax2fun_box(taxa_strat_path, result_taxa_box, ps_taxa, group = group_col, top_n = 5)
p_tax_box <- tax_boxes[[selected_taxon]]
ggplot2::ggsave(file.path(out, "tax2fun_box.pdf"), p_tax_box,
                width = 10, height = 6)
```

## Association dendrogram

A circular dendrogram is useful when you want to organize several
taxon–function relationships in one view. Follow a branch from a taxon
to its selected functions, and use point size to inspect the absolute
modeled effects. The branching is an organization of associations;
branch proximity should not be interpreted as evolutionary distance.

Branches organize functions by taxon; point sizes encode absolute model
effects. This is an association view, not an evolutionary tree. Use
`top_n_per_taxon`; `top_n_per_genus` remains a compatible alias for
older code; new examples use `top_n_per_taxon`.

``` r
p_tax_dendro <- tax2fun_dendro(
  result_taxa, top_n_per_taxon = 3, label_size = 2.6,
  wrap_width = 20
)$plot
p_tax_dendro <- p_tax_dendro +
  ggplot2::coord_fixed(xlim = c(-1.6, 1.6), ylim = c(-1.6, 1.6), clip = "off")
ggplot2::ggsave(file.path(out, "tax2fun_dendrogram.pdf"), p_tax_dendro,
                width = 10, height = 7.5)
```

The legend follows the result’s recorded rank, including Genus or Class.
Conflicting explicit ranks are rejected; older result lists without rank
metadata need the correct `taxon_level` supplied explicitly.

## Signed model effects

Use signed-effect bars when the main question is direction and
magnitude. Start by reading the group contrast, then compare the
coefficients. A positive value means a positive target-versus-reference
effect under the fitted model; its scientific meaning depends on the
model and input scale.

For the MaAsLin2 example, the axis is labelled with its AST coefficient.

``` r
tax_effects <- tax2fun_logfc(result_taxa, top_n = 3)
p_tax_effect <- tax_effects[[selected_taxon]]
ggplot2::ggsave(file.path(out, "tax2fun_effect.pdf"), p_tax_effect,
                width = 8, height = 5)
```

Positive values describe a positive target-versus-reference model
effect. See [export
formats](https://bioscinema.github.io/MicroFun_website_tutorials/articles/plot-export.md)
for the current saving interfaces.
