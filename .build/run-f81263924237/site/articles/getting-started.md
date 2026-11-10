# Getting started with MicroFun

MicroFun starts from a simple idea. A community’s predicted functional
profile is easier to understand when we can still see its microbial
contributors. We want to move from a change in a function to the taxa
associated with that change, and then inspect how their predicted
contributions vary across samples.

A pooled profile is useful for asking whether a function differs between
groups. But the same total can be produced by different combinations of
contributors. Stratified profiles let us keep those links, rather than
trying to reconstruct them from separate taxonomic and functional
analyses.

## Two perspectives on microbial function

If you want a community-wide overview, start with standard PICRUSt2
output. If your question concerns contributors, use stratified output
and choose the perspective that matches your question.

- **Start with a taxon.** Which of its predicted functional
  contributions differ between groups?
- **Start with a function.** Which taxa contribute differently to that
  function?

These are complementary analyses. They use different feature tables and
collections of tests, so one fitted result should not simply be rotated
or transposed to stand in for the other.

## Install and prepare inputs

Follow [installation and dependency
versions](https://bioscinema.github.io/MicroFun_website_tutorials/articles/installation.md),
then [download the example data and run the
setup](https://bioscinema.github.io/MicroFun_website_tutorials/articles/plotting-setup.md).
The installation page also explains the dependency policy and how to
record your analysis environment.

## Choose a workflow

Table 1. MicroFun workflows

| Input or task | Tutorial |
|----|----|
| Community-level functional profiles | [Standard PICRUSt2 workflow](https://bioscinema.github.io/MicroFun_website_tutorials/articles/standard-pipeline.md) |
| Taxon-resolved contributions | [Stratified PICRUSt2 workflow](https://bioscinema.github.io/MicroFun_website_tutorials/articles/stratified-pipeline.md) |
| Plots organized by taxon | [Taxon-to-function plots](https://bioscinema.github.io/MicroFun_website_tutorials/articles/taxon-to-function.md) |
| Plots organized by function | [Function-to-taxon plots](https://bioscinema.github.io/MicroFun_website_tutorials/articles/function-to-taxon.md) |
| Saving and redrawing figures | [Export guide](https://bioscinema.github.io/MicroFun_website_tutorials/articles/plot-export.md) |

## Demonstration studies

- [Demonstration Study
  (Stratified)](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.md)
  follows both analysis directions through code and study figures.
- [Demonstration Study
  (Standard)](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.md)
  will present community-level analysis and figures.
