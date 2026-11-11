# MicroFun Website and Tutorials

<img src="assets/logo.png"
     alt="MicroFun logo"
     width="150"
     align="right">
     
This repository contains the official documentation website and tutorials for **MicroFun**, an R package for statistical analysis and visualization of taxon-resolved functional contributions in microbiome research.

- **R package:** [bioscinema/MicroFun](https://github.com/bioscinema/MicroFun_0.1.0)
- **Website:** [bioscinema.github.io/MicroFun_website_tutorials](https://bioscinema.github.io/MicroFun_website_tutorials/)

The website is maintained separately from the R package, allowing documentation, tutorials, and examples to be updated independently of package development.

## Website Content

The website provides:

- **Overview:** Introduction to MicroFun, its motivation, and main features.
- **Getting Started:** Installation instructions and basic usage.
- **Function Reference:** Documentation of available functions and their arguments.
- **Tutorials:** Examples of taxon-centered and function-centered analyses.
- **Demonstrations:** Example workflows, statistical analyses, and visualizations.

## Repository Structure

| File or Directory | Description |
|---|---|
| `index.md` | Website homepage |
| `articles/*.Rmd` | Tutorials and demonstration pages |
| `_pkgdown.yml` | Website configuration and navigation |
| `assets/extra.css` | Custom website styling |
| `assets/examples/` | Images and interactive figures |
| `NEWS.md` | Website changelog |
| `source/MicroFun_0.1.0.zip` | Local package snapshot used to build function reference pages |
| `build.R` | Script for building the website |
| `docs/` | Generated website files published through GitHub Pages |

The website is built using [pkgdown](https://pkgdown.r-lib.org/).

## Software and Citation

For the MicroFun source code, software updates, issue reporting, and citation information, please visit the [main MicroFun repository](https://github.com/bioscinema/MicroFun_0.1.0).

## Build tools and study downloads

The site is currently built with pkgdown 2.2.1. Install or update pkgdown with
`install.packages("pkgdown")` before rebuilding. A project-local installation in
`.build/library/` is used when available; that directory is not committed.

The processed public study downloads are stored in `assets/downloads/study/` and
copied to `docs/downloads/study/` by the build. Each download is below GitHub's
100 MiB single-file limit. KO contributions are transferred in two parts and
reassembled with the included R script. The private original-to-demo sample-ID
lookup is not included in the website or the download archives.

## Learning flow

Start with Study data and downloads, then follow the Standard and Stratified
demonstration studies. Dataset provenance, cohort descriptions and download
instructions are maintained on the data page. Visualization guides are a plotting
reference that reuses the study objects; they have no independent example dataset
or setup workflow.

PICRUSt2 input generation and checks are consolidated in `articles/prepare-your-data.Rmd`.
The separate workflow pages and link-only demonstration overview have been retired.
