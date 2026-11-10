# Function-to-taxon visualizations

Start here when a function is your point of interest. A pooled
functional profile may tell you that the community differs, but it does
not tell you whether the same taxa contribute in both groups.
Function-centered analysis lets us examine those contributors directly.

The figures follow the same principles as the taxon-centered workflow,
with the roles reversed. The statistical analysis must also be
function-centered. Redrawing a taxon-centered result with the nodes
swapped would not answer the same question.

Use the result list fitted with `direction = "function"`; do not
transpose taxon-oriented fitted results. Run [the shared
setup](https://bioscinema.github.io/MicroFun_website_tutorials/articles/plotting-setup.md)
first. Figures are collected in [the stratified
demonstration](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.html#function-centered).

## Sankey

Use this overview to see which taxa are linked to each selected
function. Keeping individual KOs visible makes it easier to follow a
specific feature; grouping functions can be useful for a broader
summary. Decide which resolution you want before interpreting a visually
large group of links.

Functions appear on the left and taxa on the right. Set
`group_functions = FALSE` to retain individual KOs. Optional taxonomy or
ASV phylogeny appears on the taxon side.

``` r

p_fun_sankey <- fun2tax_sankey(
  result_fun, pathway = "KO", group_functions = FALSE,
  tree_mode = "phylogeny", physeq = ps, phylo_tree = demo$phylo_tree
)
save_sankey(p_fun_sankey, file.path(out, "fun2tax_sankey.html"))
save_sankey(p_fun_sankey, file.path(out, "fun2tax_sankey.pdf"))
```

## Chord

Use Chord to compare the predicted contributions behind the selected
relationships. A broad ribbon identifies a large mean contribution in
the plotted subset, while the outer bar describes the absolute modeled
effect. Neither should be substituted for the other.

The example below narrows the view to one KO. This is often a helpful
first step when a full diagram is crowded. Select a function you can
interpret, inspect its contributors, then broaden the view if needed.

The contribution weighting, effect colours, taxonomy bands and export
interfaces match the taxon-to-function Chord. Use function-oriented
results and select relevant function IDs.

``` r

hexokinase <- data.frame(
  function_id = "K00844", function_group = "Carbohydrate metabolism",
  function_name = "Hexokinase"
)
p_fun_chord <- fun2tax_chord(
  result_fun, strat_path, ps, group = group_col,
  contrast = c(reference, target), functions = "K00844",
  max_taxa_per_function = 2, function_table = hexokinase, draw = FALSE
)
save_chord(p_fun_chord, file.path(out, "fun2tax_chord.png"))
save_chord(p_fun_chord, file.path(out, "fun2tax_chord.pdf"))
```

## Contribution boxplots

For a selected function, compare how different taxa contribute across
sample groups. Look for the spread and overlap as well as the medians.
The log-transformed y-axis helps show contributions on different scales;
equal visual distances on that axis are not equal changes in the
original contribution units.

An ungrouped call returns one named plot per function. The y-axis is
`log10(contribution + 1e-6)`.

``` r

fun_boxes <- fun2tax_box(
  strat_path, result_fun, ps, group = group_col,
  pathway = "KO", group_functions = FALSE
)
p_fun_box <- fun_boxes[["K00844"]]
ggplot2::ggsave(file.path(out, "fun2tax_box.pdf"), p_fun_box,
                width = 9, height = 6)
```

## Association dendrogram

Here the function defines a branch and its contributing taxa define the
leaves. This view is useful for comparing which taxa appear among the
selected model effects for several functions. It is an association
summary, so do not read it as a phylogenetic tree or a clustering of
taxon abundance profiles.

Functions label branches, and contributing taxa label the leaves.
`top_n_per_function` controls how many taxa are displayed per function.

``` r

p_fun_dendro <- fun2tax_dendro(
  result_fun, top_n_per_function = 3, label_size = 2.6,
  wrap_width = 20
)$plot
p_fun_dendro <- p_fun_dendro +
  ggplot2::coord_fixed(xlim = c(-1.6, 1.6), ylim = c(-1.6, 1.6), clip = "off")
ggplot2::ggsave(file.path(out, "fun2tax_dendrogram.pdf"), p_fun_dendro,
                width = 10, height = 7.5)
```

## Signed model effects

A signed-effect plot brings the contrast into focus. Which taxa have
positive effects for the selected function, and which have negative
effects? Read the model scale and reference group before comparing bar
lengths, and remember that a large coefficient does not by itself imply
the largest absolute contribution.

``` r

fun_effects <- fun2tax_logfc(result_fun, top_n = 3)
p_fun_effect <- fun_effects[["K00844"]] +
  ggplot2::labs(y = "MaAsLin2 AST coefficient")
ggplot2::ggsave(file.path(out, "fun2tax_effect.pdf"), p_fun_effect,
                width = 8, height = 5)
```

Choose names from `names(result_fun)` and record the reference/target
contrast. Signed effects are backend-dependent model estimates; MaAsLin2
AST coefficients are not literal log fold changes.

## When you return to the community-level result

A function may change overall because a few contributors shift strongly
or because many shift together. It may also remain similar in total
while its contributors change. Use the function-centered plots to
investigate those possibilities, then return to the pooled profile for
context. The two levels describe related parts of the same community,
rather than identical measurements.
