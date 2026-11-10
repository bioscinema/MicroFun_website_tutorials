# Taxon-to-function visualizations

Start here when a taxon is your point of interest. Perhaps it differs
between groups, or perhaps you want to understand its role in a
functional pattern. We first look at the selected associations, then
examine contribution weights, sample distributions and model effects.

No single plot captures all four. A taxon can have many selected
associations without making the largest predicted contribution, and a
large contribution need not have the largest group-associated effect.
MicroFun keeps these quantities separate so you can ask which one
matters for your question.

Use the named result list from `direction = "taxa"`. Run [the shared
setup](https://bioscinema.github.io/MicroFun_website_tutorials/articles/plotting-setup.md)
first. All representative outputs appear in [the stratified
demonstration](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.html#taxon-centered).

## Sankey

Use a Sankey as an overview. Which functional categories connect to each
taxon, and where do the selected associations concentrate? Read a wide
ribbon as more displayed associations in this view. It is not a direct
abundance measurement.

The taxonomy side tree helps you place taxa within their classification.
The phylogeny mode instead uses relationships among the matching ASVs.
Choose the one that provides the context you want to discuss.

Taxa appear on the left and functional nodes on the right. Ribbon widths
count displayed associations. Positive effects use yellow/orange
(`#F5BB7C`); nonpositive effects use blue (`#B4CBE0`). Taxonomy and
phylogeny are optional side-tree modes.

``` r

p_tax_sankey <- tax2fun_sankey(
  result_taxa, tree_mode = "taxonomy", physeq = ps,
  tree_options = list(font_size = 16)
)
save_sankey(p_tax_sankey, file.path(out, "tax2fun_sankey.html"))
save_sankey(p_tax_sankey, file.path(out, "tax2fun_sankey.pdf"))

p_tax_phylogeny <- tax2fun_sankey(
  result_taxa, tree_mode = "phylogeny", physeq = ps,
  phylo_tree = demo$phylo_tree
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

Chord width is the mean predicted contribution, with equal weight
assigned to the two group means by default. Ribbon colour encodes effect
sign; outer bar height encodes absolute effect. Use the same sample
subset and rank as the fitted analysis.

``` r

p_tax_chord <- tax2fun_chord(
  result_taxa, strat_path, ps, group = group_col,
  contrast = c(reference, target), draw = FALSE
)
save_chord(p_tax_chord, file.path(out, "tax2fun_chord.png"))
save_chord(p_tax_chord, file.path(out, "tax2fun_chord.pdf"))
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

tax_boxes <- tax2fun_box(strat_path, result_taxa, ps, group = group_col)
p_tax_box <- tax_boxes[["Lactobacillus"]]
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
`top_n_per_taxon`; `top_n_per_genus` remains a compatible alias.

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

The function name retains `logfc`, but the axis label should describe
the actual estimate. For a MaAsLin2 analysis, use an AST-coefficient
label rather than assuming the values are log fold changes.

``` r

tax_effects <- tax2fun_logfc(result_taxa, top_n = 3)
p_tax_effect <- tax_effects[["Lactobacillus"]] +
  ggplot2::labs(y = "MaAsLin2 AST coefficient")
ggplot2::ggsave(file.path(out, "tax2fun_effect.pdf"), p_tax_effect,
                width = 8, height = 5)
```

Positive values describe a positive target-versus-reference model
effect. For MaAsLin2, interpret these as AST coefficients and verify
`effect_type` before reporting them. See [export
formats](https://bioscinema.github.io/MicroFun_website_tutorials/articles/plot-export.md)
for the current saving interfaces.
