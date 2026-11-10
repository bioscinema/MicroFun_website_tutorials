# Changelog

## MicroFun 0.1.0

- Hide Chord labels that do not fit the available arc. Static plots omit
  their callouts and legend aliases while the CSV retains the complete
  mapping.
- Add a searchable, clickable HTML Chord legend. A selection highlights
  one sector on its actual track, including sectors whose labels are
  hidden.
- Batch HTML pan and zoom by animation frame and reduce polygon sampling
  for HTML only. Chord associations and contribution widths are
  preserved.
- The bundled PDAC workflow exports three Sankey variants and SDAA
  results for fun2tax. The tax2fun figure set remains available.

### Additional included improvements

- Unify signed visualization colours to honey yellow and sky blue, with
  plot-specific opacity and consistent two-group boxplot colours.
- Infer plot classification ranks from analysis metadata; remove the
  hard-coded Genus dendrogram legend and reject conflicting explicit
  ranks.
- Match tree Sankey node/taxon typography and show Taxon (rank)
  headings.
- Label Chord functions as name\[ID\], remove Terminal label prefixes,
  and embed PDF fonts when Cairo is available.
- Add fun2tax_chord, fun2tax_dendro and fun2tax_logfc; exercise both
  existing fun2tax Sankey tree modes.
- Fix EC/MetaCyc reference IDs, ungrouped function boxplots, metadata
  conversion and zero-filled taxon/sample contributions.
- Add reproducible Genus/Class visual examples and focused regression
  tests.
