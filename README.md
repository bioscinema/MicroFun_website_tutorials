# MicroFun Website and Tutorials

This repository contains the official documentation website and tutorials for **MicroFun**, an R package for statistical analysis and visualization of taxon-resolved functional contributions in microbiome research.

- **R package:** [bioscinema/MicroFun](https://github.com/bioscinema/MicroFun)
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

**Important:** Edit the source files rather than the generated files in `docs/`. Changes made directly to `docs/` may be overwritten during the next build.

The bundled package snapshot is used for website generation and does not replace the official MicroFun package repository.

## Software and Citation

For the MicroFun source code, software updates, issue reporting, and citation information, please visit the [main MicroFun repository](https://github.com/bioscinema/MicroFun).
