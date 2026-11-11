# Export and redraw figures

A figure needs to remain useful after you close the plotting session.
Choose the format according to what you want to do next. Use PDF or SVG
for a scalable static figure, HTML for exploration, and RDS when you
want to return to the same object and change its appearance.

Saving a plot and saving an analysis are different tasks. Keep your
fitted result lists, input data and contrast settings as well as the
exported picture. A PNG is convenient to share, but it cannot tell you
all the choices that produced it.

## Current export interfaces

Table 1. Figure export formats

| Figure object | Saving interface |
|----|----|
| PCA, heatmap, error-bar, contribution boxplot, dendrogram and effect ggplots | [`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html) |
| Taxonomy/phylogeny Sankey | [`save_sankey()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/save_sankey.md); HTML, SVG, PDF, PNG and RDS |
| Ordinary Sankey (`tree_mode = "none"`) | [`save_sankey()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/save_sankey.md); HTML or RDS |
| Chord | [`save_chord()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/save_chord.md); HTML, SVG, PDF, PNG and RDS |

Use `ggsave()` for the returned ggplots, and the dedicated
[`save_sankey()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/save_sankey.md)
or
[`save_chord()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/save_chord.md)
functions for those diagram objects.

## Sankey

Tree-enabled Sankey diagrams keep a fixed layout across their HTML and
static exports. This is useful when you want to explore a relationship
interactively and then present the same geometry in a report. For a very
tall diagram, decide whether one fitted page or continuation pages will
make the labels easier to read.

``` r
save_sankey(p_tax_sankey, file.path(out, "sankey.html"))
save_sankey(p_tax_sankey, file.path(out, "sankey.svg"))
save_sankey(p_tax_sankey, file.path(out, "sankey.pdf"))
save_sankey(p_tax_sankey, file.path(out, "sankey.png"), width = 1800)
save_sankey(p_tax_sankey, file.path(out, "sankey.rds"))

p_redrawn <- redraw_sankey(
  file.path(out, "sankey.rds"), tree_options = list(font_size = 16)
)
save_sankey(p_redrawn, file.path(out, "sankey_redrawn.html"))
```

Tree PNG/PDF export requires `rsvg`. For very large tree diagrams,
`pdf_mode = "tiles"` writes vertical continuation pages and requires
`qpdf`; labels or ribbons can cross page boundaries. RDS keeps the
original result and tree for redrawing without recomputing the
statistical analysis.

``` r
p_plain <- tax2fun_sankey(result_taxa, tree_mode = "none")
save_sankey(p_plain, file.path(out, "sankey_no_tree.html"), selfcontained = FALSE)
```

Keep the adjacent dependency folder with ordinary HTML exports when
`selfcontained = FALSE`. A self-contained ordinary HTML export requires
Pandoc. Static SVG/PDF/PNG exports require a tree mode.

## Chord

A Chord can contain more labels than comfortably fit around its circle.
Export the label mapping and legends with the graphic so that compact
labels remain interpretable. The interactive HTML is useful for finding
a sector; the static PDF is useful when you want a figure and its
complete legend in a document.

``` r
save_chord(p_tax_chord, file.path(out, "chord.html"))
save_chord(p_tax_chord, file.path(out, "chord.pdf"), width = 12, height = 11)
save_chord(p_tax_chord, file.path(out, "chord.png"))
save_chord(p_tax_chord, file.path(out, "chord.rds"))

# The explicit extension is included along with the additional formats.
save_chord(p_tax_chord, file.path(out, "chord.html"), formats = c("pdf", "png"))
```

Chord HTML includes zoom controls and a searchable sector legend.
Selecting a legend entry highlights its sector; select it again or press
Escape to clear. Labels that do not fit can be omitted from the graphic.
The mapping CSV retains all labels and their `visible` status. Static
legends may continue on separate PDF pages or companion files.

## ggplot figures

``` r
ggplot2::ggsave(file.path(out, "boxplot.pdf"), p_tax_box,
                width = 10, height = 6)
```

Create the objects first using the
[taxon-to-function](https://bioscinema.github.io/MicroFun_website_tutorials/articles/taxon-to-function.md)
or
[function-to-taxon](https://bioscinema.github.io/MicroFun_website_tutorials/articles/function-to-taxon.md)
plotting examples.
