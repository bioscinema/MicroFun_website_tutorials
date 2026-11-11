# Export and redraw figures

Save Sankey and Chord diagrams as HTML first. HTML is suitable for
inspecting dense connections and deciding which taxa or functions to
keep in a static figure. Create the objects using the
[taxon-to-function](https://bioscinema.github.io/MicroFun_website_tutorials/articles/taxon-to-function.md)
or
[function-to-taxon](https://bioscinema.github.io/MicroFun_website_tutorials/articles/function-to-taxon.md)
guide.

Table 1. Figure export formats

| Plot type | Preview and exploration | Static output |
|----|----|----|
| PCA, heatmap, error bars, boxplots, dendrograms and signed-effect plots | Display the ggplot in R | [`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html) |
| Sankey with taxonomy or phylogeny | [`save_sankey()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/save_sankey.md) to HTML | SVG, PNG or PDF with [`save_sankey()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/save_sankey.md) |
| Adjustable Sankey without a tree | HTML is required for dragging nodes | Keep HTML or save the reusable object as RDS |
| Chord | [`save_chord()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/save_chord.md) to HTML | Filter taxa/functions in R, regenerate the Chord and save a focused PDF |

## Sankey HTML with a side tree

``` r
save_sankey(p_tax_taxonomy, file.path(out, "sankey_taxonomy.html"))
save_sankey(p_tax_phylogeny, file.path(out, "sankey_phylogeny.html"))
save_sankey(p_tax_taxonomy, file.path(out, "sankey_taxonomy.rds"))
```

Both taxonomy and phylogeny Sankeys can be saved as HTML. Their side
trees use fixed layouts; HTML preserves the supported hover and link
inspection behaviour. For a static copy, use
`save_sankey(p_tax_taxonomy, file.path(out, "sankey_taxonomy.pdf"))`.
Tree PNG/PDF export requires `rsvg`.

## Adjustable Sankey HTML

``` r
p_plain <- tax2fun_sankey(result_taxa, tree_mode = "none")
save_sankey(p_plain, file.path(out, "sankey_adjustable.html"),
            selfcontained = FALSE)
```

Open the HTML in a browser and drag nodes up or down. The links follow
their new positions. Save HTML for this version because a static PDF
cannot preserve dragging. Keep the adjacent `_files` folder with this
HTML file. `selfcontained = FALSE` avoids a Pandoc requirement. Browser
adjustments do not automatically update the saved R object or persist
after reloading the HTML.

## Preview a Chord before exporting PDF

``` r
save_chord(p_tax_chord, file.path(out, "chord_overview.html"))
save_chord(p_tax_chord, file.path(out, "chord_overview.rds"))
```

A full Chord can contain many sectors and ribbons. Start with HTML to
inspect the overview. Large full PDFs can be slow to load. For a
taxon-centered figure, choose the taxa in R and regenerate a focused
figure for PDF export. For a function-centered figure, choose the
functions.

``` r
taxa_of_interest <- head(unique(p_tax_chord$links$taxon), 3L)
p_focus <- tax2fun_chord(
  result_taxa, strat_path, ps, group = group_col,
  contrast = c(reference, target),
  taxa_list = taxa_of_interest, max_functions_per_taxon = 10,
  draw = FALSE
)
save_chord(p_focus, file.path(out, "chord_focus.html"))
save_chord(p_focus, file.path(out, "chord_focus.pdf"))
```

For function-to-taxon Chords, first filter the fitted result list and
pass explicit function IDs to
[`fun2tax_chord()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/fun2tax_chord.md).
The [function-to-taxon
guide](https://bioscinema.github.io/MicroFun_website_tutorials/articles/function-to-taxon.html#select-functions-before-plotting)
shows that selection. HTML inspection helps you choose a subset; apply
that choice in R before exporting the PDF.

## Save ggplots

``` r
ggplot2::ggsave(file.path(out, "boxplot.pdf"), p_tax_box,
                width = 10, height = 6)
```

Keep the fitted result RDS files, input paths, selected functions,
taxonomic rank and group contrast with the figures. These let you return
to the same analysis and redraw a different selection later.
