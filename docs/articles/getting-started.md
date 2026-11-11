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
then [Study data and
downloads](https://bioscinema.github.io/MicroFun_website_tutorials/articles/study-data.md).
The installation page also explains the dependency policy and how to
record your analysis environment.

## Follow the demonstration studies

Start with [Study data and
downloads](https://bioscinema.github.io/MicroFun_website_tutorials/articles/study-data.md),
then follow
[Standard](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.md)
for community-level profiles and
[Stratified](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.md)
for contributor analysis. Each study contains the preparation, analysis,
plotting code and results in one place.

## Adapt the workflow

Use [Prepare your own
data](https://bioscinema.github.io/MicroFun_website_tutorials/articles/prepare-your-data.md)
for PICRUSt2 output formats and input checks. See [Differential analysis
options](https://bioscinema.github.io/MicroFun_website_tutorials/articles/analysis-options.md)
when choosing a statistical method.

After fitting, use [Visualization
guides](https://bioscinema.github.io/MicroFun_website_tutorials/articles/plotting-setup.md)
to look up plot controls, selections and export choices.
