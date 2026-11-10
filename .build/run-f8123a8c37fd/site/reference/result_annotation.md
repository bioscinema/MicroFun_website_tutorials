# Annotate Significant Features from Differential Abundance Results from function direction

This function filters and returns statistically significant features
from a differential abundance analysis (DAA) result based on an adjusted
p-value threshold.

## Usage

``` r
result_annotation(daa_result, threshold = 0.05)
```

## Arguments

- daa_result:

  A data frame containing the results of a differential abundance
  analysis. Must include at least the columns `feature` and `p_adjust`.

- threshold:

  A numeric value specifying the adjusted p-value cutoff for
  significance. Defaults to `0.05`.

## Value

A data frame of significant features with adjusted p-values below the
given threshold, sorted by ascending p-value.
