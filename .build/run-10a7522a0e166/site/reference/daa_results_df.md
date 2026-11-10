# DAA Results Dataset

This dataset is the result of processing 'kegg_abundance' through the
'LinDA' method in the 'pathway_daa' function. It includes information
about the feature, groups compared, p values, and method used.

## Usage

``` r
daa_results_df
```

## Format

A data frame with columns:

- adj_method:

  Method used for p-value adjustment.

- feature:

  The feature (pathway) being compared.

- group1:

  The first group in the comparison.

- group2:

  The second group in the comparison.

- method:

  The method used for the comparison.

- p_adjust:

  The adjusted p-value from the comparison.

- p_values:

  The raw p-value from the comparison.

## Source

From ggpicrust2 package demonstration.

## References

Douglas GM, Maffei VJ, Zaneveld J, Yurgel SN, Brown JR, Taylor CM,
Huttenhower C, Langille MGI. PICRUSt2 for prediction of metagenome
functions. Nat Biotechnol. 2020.
