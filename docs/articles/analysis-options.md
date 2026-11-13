# Differential analysis options

MicroFun lets you choose the differential abundance backend using
`daa_method`. The demonstration uses `"Maaslin2"`, but the package also
provides the following options. Use the exact spelling shown in the
table.

Table 1. Differential analysis methods

| `daa_method` | R package | Analysis family |
|----|----|----|
| `"Maaslin2"` | Maaslin2 | Multivariable association models. |
| `"LinDA"` | MicrobiomeStat | Bias-corrected linear models for compositional abundance data. |
| `"Lefser"` | lefser | LEfSe-style differential testing and discriminant effect scores. |
| `"ALDEx2"` | ALDEx2 | Compositional differential abundance analysis. |
| `"DESeq2"` | DESeq2 | Negative-binomial count models. |
| `"edgeR"` | edgeR | Count-based differential analysis. |
| `"limma voom"` | limma | Mean-variance modeling with linear models. |
| `"metagenomeSeq"` | metagenomeSeq | Models for sparse metagenomic count data. |

Choose a backend that accepts the scale of your input and install its R
package before running it. The stratified wrapper rejects fractional
input for methods requiring integer counts; do not round PICRUSt2
predictions just to force those methods to run. The current LinDA
wrapper uses its count-data mode, and normalized contribution
proportions are not accepted for that route. Covariate adjustment
through `confounders` in the stratified workflow is currently available
with Maaslin2.

## Set the method for a community-level analysis

``` r
chosen_method <- "Maaslin2"  # Other supported names are listed above.
daa <- pathway_daa(
  abundance = kegg_abundance, metadata = meta,
  group = "group", daa_method = chosen_method,
  reference = "STS", p.adjust = "BH"
)
```

For example, set `chosen_method <- "LinDA"` for compatible input, or
`chosen_method <- "Lefser"` for the supported LEfSe-style workflow. The
method is a modeling choice, not a plotting preference. Keep one method
and contrast in each result object and retain its original effect and
adjustment fields.

## Set the method for a taxon-centered analysis

``` r
chosen_method <- "Maaslin2"
result_taxa <- pathway_sdaa(
  stratified_path = taxa_strat_path, physeq = ps_taxa,
  group = "group", taxon_level = rank,
  direction = "taxa", pathway = "KO",
  daa_method = chosen_method, reference = "STS",
  p.adjust.method = "BH", threshold = 0.05
)
```

Backend outputs differ. Contribution boxplots and overviews use
different result fields from signed-effect or Chord plots. Check the
method-specific output before choosing a plot that requires a finite
signed effect. The [function
reference](https://bioscinema.github.io/MicroFun_website_tutorials/reference/pathway_daa.md)
describes the analysis interface, and the [export
guide](https://bioscinema.github.io/MicroFun_website_tutorials/articles/plot-export.md)
explains how to inspect and save a focused result.

## Covariates and adjustment scope

With Maaslin2, pass metadata column names such as
`confounders = c("Age", "Batch")` to
[`pathway_sdaa()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/pathway_sdaa.md)
when those variables belong in your study design. By default, this
backend uses total-sum scaling and an arcsine square-root
transformation. Its default signed estimates are AST coefficients, with
the target compared against the recorded reference.

In the stratified workflows, BH adjustment is applied within each fitted
table. The two analysis directions fit separate models and collections
of tests. Save the result list as RDS to retain its `microfun` settings,
including rank and direction.

## Choose a MaAsLin2 transformation

`maaslin2_transform` accepts `"AST"` (default), `"LOG"`, `"LOGIT"` and
`"NONE"` in both
[`pathway_daa()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/pathway_daa.md)
and
[`pathway_sdaa()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/pathway_sdaa.md).
For example, add `maaslin2_transform = "LOG"` to a MaAsLin2 call and
refit before plotting. This argument is specific to MaAsLin2; omit it
for other backends. MicroFun records the transformation and uses it in
signed-effect labels, so signed-effect labels follow the fitted model.

`top_n` in
[`tax2fun_box()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/tax2fun_box.md)
and
[`fun2tax_box()`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/fun2tax_box.md)
ranks features by the average of group mean contributions. Use
`top_n = 5` for a focused panel or leave the default `Inf` to retain all
eligible features. This display ranking leaves the fitted p-values
unchanged.
