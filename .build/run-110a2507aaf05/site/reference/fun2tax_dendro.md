# Dendrogram of top differential taxa per function

Functions define the branches and taxa define the leaves. Taxon names
come directly from the function-oriented differential results at the
recorded rank.

## Usage

``` r
fun2tax_dendro(
  pathway_sdaa_result,
  functions = NULL,
  top_n_per_function = 5,
  taxon_level = NULL,
  ...
)
```

## Arguments

- pathway_sdaa_result:

  Named list keyed by function ID.

- functions:

  Optional function IDs to retain.

- top_n_per_function:

  Number of taxa per function ranked by absolute effect.

- taxon_level:

  Taxonomy rank; inferred from the differential analysis.

- ...:

  Other appearance arguments passed to tax2fun_dendro.

## Value

List with plot, used_functions, missing_functions and taxon_level.
