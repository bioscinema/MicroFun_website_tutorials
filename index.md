# MicroFun

**Connect microbial taxa to predicted functions.**

<h1>
  MicroFun
  <img src="MicroFun logo.png"
       alt="MicroFun logo"
       align="right"
       width="160">
</h1>

Analyze and visualize PICRUSt2 predictions, linking community-level functional patterns to taxon-specific contributions.

<hr class="microfun-intro-divider">

## From community profiles to individual contributors

Understanding microbial communities requires knowing both which microbes are present and what they can do. Functional profiling helps characterize their roles in ecosystems, host physiology and disease. For 16S rRNA studies, PICRUSt2 predicts functional potential from reference genomes and sequence abundances, making downstream analysis accessible when shotgun metagenomic data are unavailable.

Community-level functional profiles summarize predictions across contributors, but can obscure the taxa behind a functional difference. An increase in a function may be driven by only a few taxa, while a stable total may conceal shifts in its contributors. Analyzing taxonomic abundance and pooled functional profiles separately cannot recover these links.

**MicroFun** is an R package for downstream analysis and visualization of standard and stratified PICRUSt2 output. Building on [ggpicrust2](https://github.com/cafferychen777/ggpicrust2), it integrates data preparation, statistical analysis, functional annotation and visualization, and extends the workflow with two complementary analyses of stratified contributions:

- **Taxon-centered analysis** tests for group-associated differences in predicted functional contributions within each taxon.
- **Function-centered analysis** tests for group-associated differences in taxon contributions to each function.

Together, these analyses help identify which taxa contribute to functional differences and how predicted contributions vary across groups, while retaining the links between taxa and functions.

## Connect statistical results to visual interpretation

MicroFun combines these analyses with complementary visualizations that keep taxa and functions connected. Users can explore the functions associated with a taxon or examine the taxa contributing to a function, moving between an overview of significant relationships and detailed group comparisons.

- **Bidirectional Sankey diagrams** summarize selected taxa–function associations, with optional taxonomy or ASV phylogeny on the taxon side. Ribbon width counts the displayed associations. Explore [taxon-to-function](articles/taxon-to-function.html) and [function-to-taxon](articles/function-to-taxon.html) views.
- **Chord diagrams** show mean predicted contributions as ribbon width and absolute model effects as outer bars, connecting [taxa to functions](articles/taxon-to-function.html#tax2fun-chord) or [functions to taxa](articles/function-to-taxon.html#fun2tax-chord).
- **Contribution box plots** compare predicted contributions across groups, organized by [taxon](articles/taxon-to-function.html#tax2fun-box) or [function](articles/function-to-taxon.html#fun2tax-box).
- **Signed-effect plots and association dendrograms** show model effects and organize selected relationships in both analysis directions. For MaAsLin2, signed effects are AST coefficients. For evolutionary relationships, use the phylogeny mode of Sankey.

By bringing data preparation, statistical testing, annotation and plotting into one workflow, MicroFun helps users explore functional differences together with their microbial contributors.

## Installation

Install **MicroFun** from the source package. See [installation and dependencies](articles/installation.html) for the setup instructions.

## Tutorials

- [Standard PICRUSt2 workflow](articles/standard-pipeline.html) and [stratified PICRUSt2 workflow](articles/stratified-pipeline.html).
- [Example data and plotting setup](articles/plotting-setup.html).
- [Taxon-to-function](articles/taxon-to-function.html) and [function-to-taxon](articles/function-to-taxon.html) visualizations.
- **Demonstration studies:** [Demonstration Study (Stratified)](articles/demonstration-stratified.html) and [Demonstration Study (Standard)](articles/demonstration-standard.html) (in preparation).
- [Export and redraw](articles/plot-export.html), and [troubleshooting](articles/troubleshooting.html).

## Explore MicroFun visualizations

Three representative views of predicted functional contributions. Select a figure for the full-size image; see the [stratified demonstration](articles/demonstration-stratified.html) for boxplots, signed effects and additional views.

<div class="microfun-gallery">
<figure class="microfun-result">
<a class="microfun-result-image" href="examples/study/images/tax2fun-chord-01.png" aria-label="View full-size Chord diagram"><img src="examples/study/images/tax2fun-chord-01.png" alt="Chord showing predicted taxon-function contributions" loading="lazy"></a>
<figcaption><h3>Chord diagram</h3><p>Compare predicted contributions and model-effect direction.</p><a href="articles/demonstration-stratified.html#taxon-centered">Explore the example &rarr;</a></figcaption>
</figure>
<figure class="microfun-result">
<a class="microfun-result-image" href="examples/study/images/tax2fun-dendro-01.png" aria-label="View full-size Association dendrogram"><img src="examples/study/images/tax2fun-dendro-01.png" alt="Dendrogram organizing taxon-function associations" loading="lazy"></a>
<figcaption><h3>Association dendrogram</h3><p>Explore modeled associations between taxa and functions.</p><a href="articles/demonstration-stratified.html#taxon-centered">Explore the example &rarr;</a></figcaption>
</figure>
<figure class="microfun-result">
<a class="microfun-result-image" href="examples/study/images/tax2fun-sankey-01.svg" aria-label="View full-size Sankey diagram"><img src="examples/study/images/tax2fun-sankey-01.svg" alt="Sankey with a taxonomic side tree" loading="lazy"></a>
<figcaption><h3>Sankey diagram</h3><p>Trace selected taxa–function associations with taxonomy context.</p><a href="articles/demonstration-stratified.html#taxon-centered">Explore the example &rarr;</a></figcaption>
</figure>
</div>

## Documentation

- [Getting started](articles/getting-started.html): installation and a guide to the documentation.
- [Function reference](reference/index.html): arguments, usage and examples from the package source.
- [Changelog](news/index.html): package updates.

## Support

Ask questions or report issues on [GitHub](https://github.com/bioscinema/MicroFun/issues).
