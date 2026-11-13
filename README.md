# MicroFun Website and Tutorials

<img src="assets/logo.png" alt="MicroFun logo" width="140" align="right">

Documentation and tutorials for **MicroFun**, an R package for analysis and visualization of standard and stratified PICRUSt2 predictions, linking microbial taxa to predicted functions.

[Website](https://bioscinema.github.io/MicroFun_website_tutorials/) · [R package](https://github.com/bioscinema/MicroFun_0.1.0) · [Report a package issue](https://github.com/bioscinema/MicroFun_0.1.0/issues)

## Explore the documentation

Start with [Study data and downloads](https://bioscinema.github.io/MicroFun_website_tutorials/articles/study-data.html), then follow [Demonstration Study (Standard)](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-standard.html) and [Demonstration Study (Stratified)](https://bioscinema.github.io/MicroFun_website_tutorials/articles/demonstration-stratified.html).

Use the [Visualization guides](https://bioscinema.github.io/MicroFun_website_tutorials/articles/plotting-setup.html) to adjust figures, explore interactive diagrams and export results. For your own analysis, see [Prepare your own data](https://bioscinema.github.io/MicroFun_website_tutorials/articles/prepare-your-data.html).

## Edit the website

| Source | Purpose |
|---|---|
| `index.md` | Homepage |
| `articles/*.Rmd` | Tutorials and demonstration studies |
| `_pkgdown.yml` | Navigation and website configuration |
| `assets/` | Styling, images, interactive figures and study downloads |
| `source/MicroFun_0.1.0.zip` | Package snapshot used for function reference and author information |
| `build.R` | Website build script |
| `docs/` | Generated website for GitHub Pages |

Edit the source files and rebuild to update `docs/`. Package functions and author information are maintained in the R package source.

## Build and preview locally

Install MicroFun and its dependencies using the [installation guide](https://bioscinema.github.io/MicroFun_website_tutorials/articles/installation.html). Building the website also requires Pandoc, available with RStudio, and these R packages.

```r
install.packages(c("pkgdown", "rmarkdown", "knitr"))
```

From the repository root, build the site and start a local preview server.

```sh
Rscript build.R
python3 -m http.server 8000 --directory docs
```

Open [http://localhost:8000](http://localhost:8000) in a browser. After editing, run `Rscript build.R` again and refresh the page. The website is built with [pkgdown](https://pkgdown.r-lib.org/).
