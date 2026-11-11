# Compare the Consistency of Statistically Significant Features

This function compares the consistency and inconsistency of
statistically significant features obtained using different methods in
\`pathway_daa\`. It creates a report showing the number of common and
different features identified by each method, and the features
themselves.

## Arguments

- daa_results_list:

  A list of data frames containing statistically significant features
  obtained using different methods.

- method_names:

  A character vector of names for each method used.

- p_values_threshold:

  A numeric value representing the threshold for the p-values. Features
  with p-values less than this threshold are considered statistically
  significant. Default is 0.05.

## Value

A data frame with the comparison results. The data frame has the
following columns:

- `method`: The name of the method.

- `num_features`: The total number of statistically significant features
  obtained by the method.

- `num_common_features`: The number of features that are common to other
  methods.

- `num_diff_features`: The number of features that are different from
  other methods.

- `diff_features`: The names of the features that are different from
  other methods.

## Examples

``` r
# \donttest{
library(magrittr)
library(tibble)
data("metacyc_abundance")
data("metadata")

# Run pathway_daa function for multiple methods
methods <- c("DESeq2", "edgeR","Maaslin2")
daa_results_list <- lapply(methods, function(method) {
pathway_daa(abundance = metacyc_abundance %>% column_to_rownames("pathway"),
metadata = metadata, group = "Environment", daa_method = method)
})

names(daa_results_list) <- methods
# Correct Maaslin2 feature names by replacing dots with hyphens.
# Note: When using Maaslin2 as the differential abundance analysis method,
# it modifies the original feature names by replacing hyphens (-) with dots (.).
# This replacement can cause inconsistencies when trying to compare results from Maaslin2
# with those from other methods that do not modify feature names.
# Therefore, this line of code reverses that replacement, converting the dots back into
# hyphens for accurate and consistent comparisons across different methods.
daa_results_list[["Maaslin2"]]$feature <- gsub("\\.", "-", daa_results_list[["Maaslin2"]]$feature)

# Compare results across different methods
comparison_results <- compare_daa_results(daa_results_list = daa_results_list,
method_names = c("DESeq2", "edgeR", "Maaslin2"))
# }
```
