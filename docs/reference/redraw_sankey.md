# Redraw saved tree-integrated Sankey results

Reuses saved associations, the retained original tree and taxon
ordering. No differential model is fitted.

## Usage

``` r
redraw_sankey(x, tree_options = list(), width = NULL, height = NULL)
```

## Arguments

- x:

  An existing tree-enabled MicroFun widget or its RDS path.

- tree_options:

  Named appearance options. Defaults enable aggregate_links,
  collapse_clades and bundle_mapping, and disable title, subtitle and
  show_footer.

- width,height:

  Minimum drawing dimensions in pixels.

## Value

A tree-enabled htmlwidget with original edges, aggregated ribbons, clade
membership and SVG geometry.
