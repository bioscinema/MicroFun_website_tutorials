# Using the visualization guides

## Learn through the demonstration studies

Start with [Study data and
downloads](https://bioscinema.github.io/MicroFun_website_tutorials/articles/study-data.md),
then follow
[Standard](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.md)
for community profiles or
[Stratified](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.md)
for taxon and function contributions. These pages contain the complete
input preparation, analysis, plotting code, figures and interpretation.

## Look up plotting choices here

The visualization guides are a reference for changing a figure after
running the corresponding study. Use them to choose a plot, adjust
parameters, filter taxa or functions, and save HTML or PDF. They reuse
the objects created by the studies and require no separate dataset or
initialization workflow.

Table 1. Choose a visualization guide

| Task | Guide | Starting point |
|----|----|----|
| Change PCA colours, heatmap features or error-bar selections | [Community-level visualizations](https://bioscinema.github.io/MicroFun_website_tutorials/articles/sample-level-plots.md) | Complete the Standard analysis. |
| Adjust taxon-to-function diagrams | [Taxon-to-function visualizations](https://bioscinema.github.io/MicroFun_website_tutorials/articles/taxon-to-function.md) | Fit the taxon-centered Stratified analysis. |
| Select and plot function contributors | [Function-to-taxon visualizations](https://bioscinema.github.io/MicroFun_website_tutorials/articles/function-to-taxon.md) | Run the selected-KO function-centered analysis. |
| Save an interactive preview or a focused static figure | [Export and redraw](https://bioscinema.github.io/MicroFun_website_tutorials/articles/plot-export.md) | Use the plot objects from either study or guide. |
| Resolve an input or rendering issue | [Troubleshooting](https://bioscinema.github.io/MicroFun_website_tutorials/articles/troubleshooting.md) | Inspect the relevant analysis or plotting step. |

## Reuse the study objects

Keep the relevant study session open while consulting a guide. The
studies also save their fitted results as RDS files so you can return to
them later.

Table 2. Objects used by the guides

| From the study | Objects used in the guide |
|----|----|
| Standard | `ko_abundance`, `kegg_abundance`, `meta`, `daa_ko`, `daa_kegg`, `kegg_features`, `reference`, `target`, `out`. |
| Stratified taxon-centered route | `ps`, `strat_path`, `study_tree`, `result_taxa`, `result_taxa_box`, `rank`, `group_col`, `reference`, `target`, `out`. |
| Stratified function-centered route | The same sample and grouping objects, plus `fun_strat_path`, `result_fun`, `result_fun_box`, `ko_candidates` and the selected function list. |

All input paths are resolved from the extracted
`MicroFun_demonstration_data` folder. The [download
page](https://bioscinema.github.io/MicroFun_website_tutorials/articles/study-data.html#files-after-extraction)
lists the archive contents and exact filenames; fitted result and figure
output paths are defined in each study.
