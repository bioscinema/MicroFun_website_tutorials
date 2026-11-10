# Example inputs and plotting setup

Here we load the same objects for every plotting tutorial, so you can
change the visual presentation without repeatedly preparing the inputs.

The toy data are deliberately small. They help you see how an ASV-level
contribution table, taxonomy, a tree and a result list fit together. The
[Demonstration Study
(Stratified)](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.md)
shows the richer example-study figures; its displayed STS/LTS
comparisons are distinct from the Control/Treatment toy inputs used
here.

## Download the example data

[Download the MicroFun example
data](https://bioscinema.github.io/MicroFun_website_tutorials/downloads/MicroFun_example_data.zip)
and extract the `MicroFun_example_data` folder into your R working
directory.

This synthetic toy dataset contains six samples, three genera and three
KOs, together with taxonomy, an ASV tree and illustrative differential
result lists. Effects and p-values are supplied for plotting practice;
they were not fitted to the synthetic counts and are not biological
findings.

## Shared setup

Run once per R session before the plotting tutorials.

``` r
library(MicroFun)

demo_dir <- "MicroFun_example_data"
stopifnot(file.exists(file.path(demo_dir, "synthetic_inputs.RData")))
demo <- new.env()
load(file.path(demo_dir, "synthetic_inputs.RData"), envir = demo)
strat_path <- file.path(demo_dir, "synthetic_KO_contrib.tsv")
ps <- demo$physeq
result_taxa <- demo$taxa_result
result_fun <- demo$function_result
group_col <- "group"
reference <- "Control"
target <- "Treatment"
out <- "MicroFun_plot_examples"
dir.create(out, recursive = TRUE, showWarnings = FALSE)
```

The taxon-oriented toy list is explicitly KO-level. In a fitted study
with `direction = "taxa", pathway = "KO"`, MicroFun aggregates mapped
KOs to KEGG pathways before fitting. Keep that distinction in mind when
replacing the toy data with study results.

## What have we loaded?

`strat_path` points to the long contribution table. `ps` keeps the ASV
taxonomy and sample metadata together. `result_taxa` is a list named by
taxon, while `result_fun` is named by function. The plotting functions
use these names to decide what each panel or diagram represents.

Before selecting a plot, inspect `names(result_taxa)` or
`names(result_fun)`. Using a name, such as a genus or KO ID, is clearer
than selecting `[[1]]`, whose meaning can change when the list is
reordered. The `reference` and `target` variables also make the intended
comparison explicit.

For your own study, replace both the contribution inputs and the fitted
result lists. Keeping a toy result list while changing only the raw data
would create a figure whose statistics and contributions describe
different analyses.

## Next steps

- [Taxon-to-function
  plots](https://bioscinema.github.io/MicroFun_website_tutorials/articles/taxon-to-function.md)
- [Function-to-taxon
  plots](https://bioscinema.github.io/MicroFun_website_tutorials/articles/function-to-taxon.md)
- [Stratified demonstration
  figures](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.md)
- [Use your own
  study](https://bioscinema.github.io/MicroFun_website_tutorials/articles/stratified-pipeline.md)
