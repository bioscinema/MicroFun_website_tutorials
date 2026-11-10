# Compare Metagenome Results

Compare Metagenome Results

## Arguments

- metagenomes:

  A list of metagenomes matrices with rows as KOs and columns as
  samples. Each matrix in the list should correspond to a different
  metagenome.

- names:

  A vector of names for the metagenomes in the same order as in the
  \`metagenomes\` list.

- daa_method:

  A character specifying the method for differential abundance analysis
  (DAA). Possible choices are: "ALDEx2", "DESeq2", "edgeR", "limma
  voom", "metagenomeSeq", "LinDA", "Maaslin2", and "Lefse". The default
  is "ALDEx2".

- p.adjust:

  A character specifying the method for p-value adjustment. Possible
  choices are: "BH" (Benjamini-Hochberg), "holm", "bonferroni",
  "hochberg", "fdr", and "none". The default is "BH".

- reference:

  A character specifying the reference group level for DAA. This
  parameter is used when there are more than two groups. The default is
  NULL.

## Value

A list containing two elements:

- "daa": a list of results from the \`pathway_daa\` function. Each
  result is a data frame containing the differential abundance analysis
  results with columns for the feature ID, the test statistic, the raw
  p-value, and the adjusted p-value.

- "correlation": a list with two elements: "cor_matrix" and "p_matrix",
  which are matrices of Spearman correlation coefficients and their
  corresponding p-values, respectively, between every pair of
  metagenomes.

## Examples

``` r
# \donttest{
library(dplyr)
library(ComplexHeatmap)
# Generate example data
set.seed(123)
# First metagenome
metagenome1 <- abs(matrix(rnorm(1000), nrow = 100, ncol = 10))
rownames(metagenome1) <- paste0("KO", 1:100)
colnames(metagenome1) <- paste0("sample", 1:10)
# Second metagenome
metagenome2 <- abs(matrix(rnorm(1000), nrow = 100, ncol = 10))
rownames(metagenome2) <- paste0("KO", 1:100)
colnames(metagenome2) <- paste0("sample", 1:10)
# Put the metagenomes into a list
metagenomes <- list(metagenome1, metagenome2)
# Define names
names <- c("metagenome1", "metagenome2")
# Call the function
results <- compare_metagenome_results(metagenomes, names, daa_method = "LinDA")
# Print the correlation matrix
print(results$correlation$cor_matrix)
# Print the p-value matrix
print(results$correlation$p_matrix)
# }
```
