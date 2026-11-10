# Differentially Abundant Analysis Results with Annotation

This is a result dataset after processing 'kegg_abundance' through the
'pathway_daa' with the LinDA method and further annotation with
'pathway_annotation'.

## Usage

``` r
daa_annotated_results_df
```

## Format

A data frame with 10 variables:

- adj_method:

  Method used for adjusting p-values.

- feature:

  Feature being tested.

- group1:

  One group in the comparison.

- group2:

  The other group in the comparison.

- method:

  Statistical test used.

- p_adjust:

  Adjusted p-value.

- p_values:

  P-values from the statistical test.

- pathway_class:

  Class of the pathway.

- pathway_description:

  Description of the pathway.

- pathway_map:

  Map of the pathway.

- pathway_name:

  Name of the pathway.

## References

Douglas GM, Maffei VJ, Zaneveld J, Yurgel SN, Brown JR, Taylor CM,
Huttenhower C, Langille MGI. PICRUSt2 for prediction of metagenome
functions. Nat Biotechnol. 2020.
