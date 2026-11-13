# Differential Abundance Analysis for Predicted Functional Pathways

Performs differential abundance analysis on predicted functional pathway
data using various statistical methods. This function supports multiple
methods for analyzing differences in pathway abundance between groups,
including popular approaches like ALDEx2, DESeq2, edgeR, and others.

## Usage

``` r
pathway_daa(
  abundance,
  metadata,
  group,
  confounder = NULL,
  daa_method = "ALDEx2",
  select = NULL,
  p.adjust = "BH",
  reference = NULL,
  ...
)
```

## Arguments

- abundance:

  A data frame or matrix containing predicted functional pathway
  abundance, with pathways/features as rows and samples as columns. The
  column names should match the sample names in metadata. Values should
  be counts or abundance measurements.

- metadata:

  A data frame or tibble containing sample information. Must include a
  'sample' column with sample identifiers matching the column names in
  abundance data.

- group:

  Character string specifying the column name in metadata that contains
  group information for differential abundance analysis.

- confounder:

  Confounders covariates you want to adjust when doing analysis.

- daa_method:

  Character string specifying the method for differential abundance
  analysis. Available choices are:

  - `"ALDEx2"`: ANOVA-Like Differential Expression tool

  - `"DESeq2"`: Differential expression analysis based on negative
    binomial distribution

  - `"edgeR"`: Exact test for differences between groups using negative
    binomial model

  - `"limma voom"`: Limma-voom framework for RNA-seq analysis

  - `"metagenomeSeq"`: Zero-inflated Gaussian mixture model

  - `"LinDA"`: Linear models for differential abundance analysis

  - `"Maaslin2"`: Multivariate Association with Linear Models

  - `"Lefser"`: Linear discriminant analysis effect size

  Default is "ALDEx2".

- select:

  Vector of sample names to include in the analysis. If NULL (default),
  all samples are included.

- p.adjust:

  Character string specifying the method for p-value adjustment. Choices
  are:

  - `"BH"`: Benjamini-Hochberg procedure (default)

  - `"holm"`: Holm's step-down method

  - `"bonferroni"`: Bonferroni correction

  - `"hochberg"`: Hochberg's step-up method

  - `"fdr"`: False Discovery Rate

  - `"none"`: No adjustment

- reference:

  Character string specifying the reference level for the group
  comparison. If NULL (default), the first level is used as reference.

- ...:

  Additional arguments passed to the specific DAA method

## Value

A data frame containing the differential abundance analysis results. The
structure of the results depends on the chosen DAA method. For methods
that support multi-group comparisons (like LinDA), when there are more
than two groups, the results will contain separate rows for each feature
in each pairwise comparison between the reference group and each
non-reference group. The data frame includes the following columns:

- `feature`: Feature/pathway identifier

- `method`: The DAA method used

- `group1`: Reference group

- `group2`: Comparison group

- `p_values`: P-values for the comparison

- `p_adjust`: Adjusted p-values

- `adj_method`: Method used for p-value adjustment

Some methods may provide additional columns, such as `log2FoldChange`
for effect size information.

## References

- ALDEx2: Fernandes et al. (2014) Unifying the analysis of
  high-throughput sequencing datasets: characterizing RNA-seq, 16S rRNA
  gene sequencing and selective growth experiments by compositional data
  analysis. Microbiome.

- DESeq2: Love et al. (2014) Moderated estimation of fold change and
  dispersion for RNA-seq data with DESeq2. Genome Biology.

- edgeR: Robinson et al. (2010) edgeR: a Bioconductor package for
  differential expression analysis of digital gene expression data.
  Bioinformatics.

- limma-voom: Law et al. (2014) voom: precision weights unlock linear
  model analysis tools for RNA-seq read counts. Genome Biology.

- metagenomeSeq: Paulson et al. (2013) Differential abundance analysis
  for microbial marker-gene surveys. Nature Methods.

- Maaslin2: Mallick et al. (2021) Multivariable Association Discovery in
  Population-scale Meta-omics Studies.

## Examples

``` r
# \donttest{
# Create example data with more samples
abundance <- data.frame(
  sample1 = c(10, 20, 30),
  sample2 = c(20, 30, 40),
  sample3 = c(30, 40, 50),
  sample4 = c(40, 50, 60),
  sample5 = c(50, 60, 70),
  row.names = c("pathway1", "pathway2", "pathway3")
)

metadata <- data.frame(
  sample = c("sample1", "sample2", "sample3", "sample4", "sample5"),
  group = c("control", "control", "treatment", "treatment", "treatment")
)

# Run differential abundance analysis using ALDEx2
results <- pathway_daa(abundance, metadata, "group")

# Using a different method (limma voom instead of DESeq2 for this small example)
limma_results <- pathway_daa(abundance, metadata, "group",
                            daa_method = "limma voom")

# Analyze specific samples only
subset_results <- pathway_daa(abundance, metadata, "group",
                             select = c("sample1", "sample2", "sample3", "sample4"))
# }
```
