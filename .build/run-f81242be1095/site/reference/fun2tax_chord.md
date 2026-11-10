# Chord diagram from function-oriented differential results

Uses the same contribution weighting, filtering, taxonomy bands, labels
and exports as tax2fun_chord. Requires results from direction =
'function'.

## Usage

``` r
fun2tax_chord(pathway_sdaa_result, stratified_path, physeq, group, ...)
```

## Arguments

- pathway_sdaa_result:

  Named list keyed by function ID.

- stratified_path:

  PICRUSt2 contribution TSV or TSV.GZ.

- physeq:

  A phyloseq object used for the differential analysis.

- group:

  Metadata grouping column.

- ...:

  Arguments passed to tax2fun_chord, except direction.

## Value

A microfun_chord object.
