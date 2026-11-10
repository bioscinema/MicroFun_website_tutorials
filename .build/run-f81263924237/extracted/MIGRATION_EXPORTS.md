# MicroFun 0.1.0 – plotting interface consolidation

- Chord implementation in `R/tax2fun_chord.R` (merged `tax2fun_chord_plot.R`, `chord_html.R`, `chord_export.R`).
- Tree Sankey implementation and `save_sankey()` in `R/sankey_tree.R` (merged `sankey_tree_plot.R`).
- `fun2tax_complete.R` wrappers moved to related functions.
- `save_chord(x)` now writes `microfun_chord.html`; `save_chord(x, formats=c("pdf","png"))` also writes PDF and PNG. `save_chord(x,"figure.pdf")` still saves only PDF. Explicit file format is always included in a multi-format request. Companion legend / CSV files unchanged.
- `save_sankey(standard_widget,"figure.html")` uses `htmlwidgets::saveWidget()`; tree-enabled exports preserve previous render paths. Standard widgets support HTML/RDS; PDF/PNG/SVG remain tree-only. `selfcontained=TRUE` uses Pandoc for ordinary Sankey HTML.
- No algorithmic changes to PICRUSt2 / statistics / graph geometry.
- Runtime R tests still required on a machine with R and package dependencies installed.
