# Community-level visualizations

Use this guide to adjust figures after running the [Standard
demonstration](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.md).
It reuses that study’s matrices, metadata and fitted results. For data
preparation, complete code, figures and interpretation, follow the study
itself.

Table 1. Community-level plotting choices

| Plot | Useful controls | Study example |
|----|----|----|
| [`pathway_pca()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/pathway_pca.md) | Feature subset and group `colors`. | [KO and KEGG PCA](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.html#compare-overall-functional-profiles). |
| [`pathway_heatmap()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/pathway_heatmap.md) | Displayed features, `font_size`, `show_row_names`, `show_legend`, group `colors`. | [Selected-feature heatmaps](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.html#inspect-selected-features-across-samples). |
| [`pathway_errorbar()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/pathway_errorbar.md) | `select`, `p_values_threshold`, `order`, `x_lab`, `p_value_bar`. | [Group abundance summaries](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.html#examine-group-abundance-summaries). |

## PCA colours and feature selection

The matrix rows are features and its columns are samples. Keep metadata
aligned by sample identifier. Remove constant rows before scaled PCA,
then supply one colour for each group in factor-level order.

``` r
pathway_variance <- apply(kegg_abundance, 1, stats::var)
p_pca <- pathway_pca(
  kegg_abundance[is.finite(pathway_variance) & pathway_variance > 0, , drop = FALSE],
  meta, group = "group", colors = c("#B4CBE0", "#F5BB7C")
)
```

See the [Standard
PCA](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.html#pca-at-kegg-pathway-level)
for the resulting study view. Use the complete feature matrix for an
overview, or a defined subset when you want to explore specific
functions.

## Heatmap feature selection and labels

Choose the displayed features explicitly. `kegg_features` is the list
used in the Standard study; the following example narrows it to ten
pathways. Rows are standardized within the plotting function.

``` r
selected_pathways <- head(kegg_features, 10L)
p_heatmap <- pathway_heatmap(
  kegg_abundance[selected_pathways, , drop = FALSE], meta,
  group = "group", colors = c("#B4CBE0", "#F5BB7C"),
  font_size = 9, show_row_names = TRUE, show_legend = TRUE
)
```

See the [Standard
heatmaps](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.html#heatmap-of-selected-kegg-pathways)
for the full displayed selection and interpretation. Smaller selections
make individual labels easier to read.

## Error-bar selection and annotations

Use the study’s `daa_kegg` result table. `select` controls the displayed
IDs and `p_values_threshold` controls the significance filter. Keep the
full abundance matrix as input so sample normalization precedes feature
selection. As in Standard, leave `p_value_bar = FALSE` and use the
exported CSV tables for exact adjusted p-values.

``` r
sample_groups <- factor(
  meta$group[match(colnames(kegg_abundance), meta$sample_name)],
  levels = c(reference, target)
)
p_errorbar <- pathway_errorbar(
  abundance = kegg_abundance, daa_results_df = daa_kegg,
  Group = sample_groups, select = selected_pathways,
  p_values_threshold = 0.05, order = "p_values",
  ko_to_kegg = FALSE, x_lab = "pathway_name", p_value_bar = FALSE
)
```

Use `x_lab = "description"` with the annotated KO results and
`x_lab = "pathway_name"` with KEGG pathway results. See [Standard error
bars](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.html#error-bar-plot-at-kegg-pathway-level)
for the study output.

## Export a changed figure

``` r
ggplot2::ggsave(file.path(out, "selected_pathways_heatmap.pdf"), p_heatmap,
                width = 11, height = 6)
```

Use [Export and
redraw](https://bioscinema.github.io/MicroFun_website_tutorials/articles/plot-export.md)
for Sankey and Chord formats, and the [function
reference](https://bioscinema.github.io/MicroFun_website_tutorials/reference/index.md)
for complete argument lists.
