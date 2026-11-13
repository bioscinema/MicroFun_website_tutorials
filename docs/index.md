# MicroFun

![MicroFun logo](logo.png)

**Connect microbial taxa to predicted functions.**

Analyze and visualize PICRUSt2 predictions, linking community-level
functional patterns to taxon-specific contributions.

------------------------------------------------------------------------

## From community profiles to individual contributors

Understanding microbial communities requires knowing both which microbes
are present and what they can do. Functional profiling helps
characterize their roles in ecosystems, host physiology and disease. For
16S rRNA studies, PICRUSt2 predicts functional potential from reference
genomes and sequence abundances, making downstream analysis accessible
when shotgun metagenomic data are unavailable.

Community-level functional profiles summarize predictions across
contributors, but can obscure the taxa behind a functional difference.
An increase in a function may be driven by only a few taxa, while a
stable total may conceal shifts in its contributors. Analyzing taxonomic
abundance and pooled functional profiles separately cannot recover these
links.

**MicroFun** is an R package for downstream analysis and visualization
of standard and stratified PICRUSt2 output. Building on
[ggpicrust2](https://github.com/cafferychen777/ggpicrust2), it
integrates data preparation, statistical analysis, functional annotation
and visualization, and extends the workflow with two complementary
analyses of stratified contributions:

- **Taxon-centered analysis** tests for group-associated differences in
  predicted functional contributions within each taxon.
- **Function-centered analysis** tests for group-associated differences
  in taxon contributions to each function.

Together, these analyses help identify which taxa contribute to
functional differences and how predicted contributions vary across
groups, while retaining the links between taxa and functions.

## Connect statistical results to visual interpretation

MicroFun combines these analyses with complementary visualizations that
keep taxa and functions connected. Users can explore the functions
associated with a taxon or examine the taxa contributing to a function,
moving between an overview of significant relationships and detailed
group comparisons.

- **Bidirectional Sankey diagrams** summarize selected taxa–function
  associations, with optional taxonomy or ASV phylogeny on the taxon
  side. Ribbon width counts the displayed associations. Explore
  [taxon-to-function](https://bioscinema.github.io/MicroFun_website_tutorials/articles/taxon-to-function.md)
  and
  [function-to-taxon](https://bioscinema.github.io/MicroFun_website_tutorials/articles/function-to-taxon.md)
  views.
- **Chord diagrams** show mean predicted contributions as ribbon width
  and absolute model effects as outer bars, connecting [taxa to
  functions](https://bioscinema.github.io/MicroFun_website_tutorials/articles/taxon-to-function.html#tax2fun-chord)
  or [functions to
  taxa](https://bioscinema.github.io/MicroFun_website_tutorials/articles/function-to-taxon.html#fun2tax-chord).
- **Contribution box plots** compare predicted contributions across
  groups, organized by
  [taxon](https://bioscinema.github.io/MicroFun_website_tutorials/articles/taxon-to-function.html#tax2fun-box)
  or
  [function](https://bioscinema.github.io/MicroFun_website_tutorials/articles/function-to-taxon.html#fun2tax-box).
- **Signed-effect plots and association dendrograms** show model effects
  and organize selected relationships in both analysis directions. For
  MaAsLin2, effect labels follow the chosen transformation. For
  evolutionary relationships, use the phylogeny mode of Sankey.

By bringing data preparation, statistical testing, annotation and
plotting into one workflow, MicroFun helps users explore functional
differences together with their microbial contributors.

[![MicroFun graphical abstract connecting microbial communities,
predicted functions and
visualizations](images/microfun_abstract.png)](https://bioscinema.github.io/MicroFun_website_tutorials/images/microfun_abstract.png)

## Installation

Install **MicroFun** from the source package. See [installation and
dependencies](https://bioscinema.github.io/MicroFun_website_tutorials/articles/installation.md)
for the setup instructions.

## Tutorials

- **Demonstration Study:** [Study data and
  downloads](https://bioscinema.github.io/MicroFun_website_tutorials/articles/study-data.md)
  →
  [Standard](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.md)
  →
  [Stratified](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.md).
- [Prepare your own
  data](https://bioscinema.github.io/MicroFun_website_tutorials/articles/prepare-your-data.md)
  for PICRUSt2 outputs and input checks.
- [Visualization
  guides](https://bioscinema.github.io/MicroFun_website_tutorials/articles/plotting-setup.md)
  for plot controls, selections, export and troubleshooting.

## Explore MicroFun visualizations

Three representative Genus-level views of predicted functional
contributions. Select a figure to explore the corresponding result; see
the [stratified
demonstration](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.md)
for boxplots, signed effects and additional views.

[![Genus-level Chord showing predicted taxon-function
contributions](examples/study/genus/images/tax2fun-chord.svg)](https://bioscinema.github.io/MicroFun_website_tutorials/examples/study/genus/images/tax2fun-chord.svg)

### Chord diagram

Compare predicted contributions and model-effect direction.

[Explore the example
→](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.html#chord-diagrams-add-contribution-weights)

[![Selected KOs and their Genus-level contributor
associations](examples/study/genus/images/fun2tax-dendrogram.png)](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.html#association-dendrogram-for-the-selected-kos)

### Association dendrogram

Explore genus contributors to the selected KOs.

[Explore the example
→](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.html#association-dendrogram-for-the-selected-kos)

[![Genus-level Sankey with a taxonomic side
tree](examples/study/genus/images/tax2fun-taxonomy.svg)](https://bioscinema.github.io/MicroFun_website_tutorials/examples/study/genus/images/tax2fun-taxonomy.svg)

### Sankey diagram

Trace selected taxa–function associations with taxonomy context.

[Explore the example
→](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.html#sankey-overviews-of-the-selected-genera)

## Documentation

- [Getting
  started](https://bioscinema.github.io/MicroFun_website_tutorials/articles/getting-started.md):
  installation and a guide to the documentation.
- [Function
  reference](https://bioscinema.github.io/MicroFun_website_tutorials/reference/index.md):
  arguments, usage and examples from the package source.
- [Changelog](https://bioscinema.github.io/MicroFun_website_tutorials/news/index.md):
  package updates.

## Support

Ask questions or report issues on
[GitHub](https://github.com/bioscinema/MicroFun_0.1.0/issues).
