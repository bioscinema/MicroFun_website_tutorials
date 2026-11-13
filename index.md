
<img src="logo.png" alt="MicroFun logo" class="microfun-home-logo">

# MicroFun

**Connect microbial taxa to predicted functions.**

Analyze and visualize PICRUSt2 predictions, linking community-level functional patterns to taxon-specific contributions.

<div style="clear: both;"></div>

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
- **Signed-effect plots and association dendrograms** show model effects and organize selected relationships in both analysis directions. For MaAsLin2, effect labels follow the chosen transformation. For evolutionary relationships, use the phylogeny mode of Sankey.

By bringing data preparation, statistical testing, annotation and plotting into one workflow, MicroFun helps users explore functional differences together with their microbial contributors.

<figure class="microfun-graphical-abstract">
<a href="images/microfun_abstract.png"><img src="images/microfun_abstract.png" width="8325" height="5580" alt="MicroFun graphical abstract connecting microbial communities, predicted functions and visualizations" loading="lazy"></a>
</figure>

## Installation

Install **MicroFun** from the source package. See [installation and dependencies](articles/installation.html) for the setup instructions.

## Tutorials

- **Demonstration Study:** [Study data and downloads](articles/study-data.html) → [Standard](articles/demonstration-standard.html) → [Stratified](articles/demonstration-stratified.html).
- [Prepare your own data](articles/prepare-your-data.html) for PICRUSt2 outputs and input checks.
- [Visualization guides](articles/plotting-setup.html) for plot controls, selections, export and troubleshooting.

## Explore MicroFun visualizations

Three representative Genus-level views of predicted functional contributions. Select a figure to explore the corresponding result; see the [stratified demonstration](articles/demonstration-stratified.html) for boxplots, signed effects and additional views.

<div class="microfun-gallery">
<figure class="microfun-result">
<a class="microfun-result-image" href="examples/study/genus/images/tax2fun-chord.svg" aria-label="View full-size Chord diagram"><img src="examples/study/genus/images/tax2fun-chord.svg" width="1296" height="1152" alt="Genus-level Chord showing predicted taxon-function contributions" loading="lazy"></a>
<figcaption><h3>Chord diagram</h3><p>Compare predicted contributions and model-effect direction.</p><a href="articles/demonstration-stratified.html#chord-diagrams-add-contribution-weights">Explore the example &rarr;</a></figcaption>
</figure>
<figure class="microfun-result">
<a class="microfun-result-image" href="articles/demonstration-stratified.html#association-dendrogram-for-the-selected-kos" aria-label="View full-size Association dendrogram"><img src="examples/study/genus/images/fun2tax-dendrogram.png" width="1440" height="1152" alt="Selected KOs and their Genus-level contributor associations" loading="lazy"></a>
<figcaption><h3>Association dendrogram</h3><p>Explore genus contributors to the selected KOs.</p><a href="articles/demonstration-stratified.html#association-dendrogram-for-the-selected-kos">Explore the example &rarr;</a></figcaption>
</figure>
<figure class="microfun-result">
<a class="microfun-result-image" href="examples/study/genus/images/tax2fun-taxonomy.svg" aria-label="View full-size Sankey diagram"><img src="examples/study/genus/images/tax2fun-taxonomy.svg" width="2400" height="894" alt="Genus-level Sankey with a taxonomic side tree" loading="lazy"></a>
<figcaption><h3>Sankey diagram</h3><p>Trace selected taxa–function associations with taxonomy context.</p><a href="articles/demonstration-stratified.html#sankey-overviews-of-the-selected-genera">Explore the example &rarr;</a></figcaption>
</figure>
</div>

## Documentation

- [Getting started](articles/getting-started.html): installation and a guide to the documentation.
- [Function reference](reference/index.html): arguments, usage and examples from the package source.
- [Changelog](news/index.html): package updates.

## Support

Ask questions or report issues on [GitHub](https://github.com/bioscinema/MicroFun_0.1.0/issues).
