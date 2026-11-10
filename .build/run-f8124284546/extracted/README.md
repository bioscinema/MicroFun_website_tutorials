# MicroFun 0.1.0

Chord HTML exports have a searchable sector list. Click an entry to highlight
its arc. Click again or press Escape to clear the selection. Labels that do not
fit are absent from the chart. Static exports also omit those label aliases
from the legend. The mapping CSV retains all labels and a `visible` column.
The PDAC runner exports Sankey and SDAA results for fun2tax and the complete
visualization set for tax2fun.


MicroFun 0.1.0 is the current package version. This is a source
package revision, not an official upstream release.

## Install

Restart R before replacing an already loaded MicroFun installation. Keep the
existing MicroFun dependencies installed, then run:

```r
remotes::install_local("D:/MicroFun/MicroFun", upgrade = "never")
library(MicroFun)
packageVersion("MicroFun")
```

The source ZIP contains the editable `MicroFun/` directory. It is not a Windows
binary package. Extract the archive to `D:/MicroFun/MicroFun` and install that source directory.
No new mandatory runtime dependency was added.

## Changes

| Request | Result |
|---|---|
| Signed colours | Positive/Up: `#F5BB7C`; negative/Down: `#B4CBE0`. Updated Sankey, Chord, signed logFC bars, the signed panel of pathway_errorbar, and the diverging heatmap scale. |
| Opacity | Boxplots: 1; Sankey ribbons: 0.48; Chord ribbons: 0.32; Chord outer effect bars: 0.95. Tree Sankey opacity remains configurable with `tree_options$link_opacity`; Chord with `link_alpha` / `bar_alpha`. |
| Boxplot groups | Reference group uses blue and target group uses yellow for a two-group contrast. Group colours identify groups, not the sign of each individual feature. Additional groups keep separate categorical colours. |
| Tree Sankey text | Tree node labels and taxon endpoint labels share `tree_options$font_size` (default 16) and `font_family` (default Arial/Helvetica/sans-serif). Heading: `Taxon (Genus)`, `Taxon (Class)`, etc. Long tree labels remain abbreviated with full hover text. |
| Chord functional labels | `Function name[function ID]`, e.g. `Hexokinase[K00844]`. Names resolve from explicit `function_table$function_name`, result annotations, then bundled KO/EC/MetaCyc/KEGG annotations. Unknown IDs remain visible as IDs. `Terminal` is removed from label/legend text. Narrow sectors retain letter codes with complete names in the legend and mapping CSV. |
| Classification level | Dendrogram legend was hard-coded to Genus; it now reads the analysis rank. Sankey and boxplots also infer rank from `attr(result, "microfun")$taxon_level`. An explicit conflicting rank is rejected. Legacy lists without recorded settings default to Genus; supply the correct `taxon_level` for those lists. |
| fun2tax completion | Existing taxonomy/phylogeny Sankey and boxplots retained; added exported `fun2tax_chord()`, `fun2tax_dendro()`, `fun2tax_logfc()`. Chord shares the contribution-weighted engine, taxonomy bands and export tools used by tax2fun. |

Category palettes still encode taxonomy/function identity. They are not
replaced with a two-colour signed palette. PCA and heatmap/errorbar group
annotations use blue/yellow for their first two groups.

Additional fixes: EC/MetaCyc references correctly read their bundled `id`
column; ungrouped fun2tax boxplots produce one plot per function rather than
one pooled plot; omitted taxon/sample contributions within the selected samples
are zero-filled. Conversion of phyloseq sample metadata to data.table no longer
retains the S4 sample_data class. Chord PDFs embed fonts when Cairo is available.

## Function-to-taxon analysis and plots

Use function-oriented differential results; do not transpose taxon-oriented
statistical results and interpret them as a new analysis.

```r
result_fun <- pathway_sdaa(
  stratified_path = "KO_contrib.tsv.gz", physeq = ps1,
  group = "group", taxon_level = "Genus", direction = "function",
  pathway = "KO", daa_method = "Maaslin2", p.adjust.method = "BH"
)

p_taxonomy <- fun2tax_sankey(
  result_fun, group_functions = FALSE, tree_mode = "taxonomy", physeq = ps1
)
p_phylogeny <- fun2tax_sankey(
  result_fun, group_functions = FALSE, tree_mode = "phylogeny", physeq = ps1,
  picrust2_dir = "picrust2_out"
)
save_sankey(p_taxonomy, "fun2tax_taxonomy.html")
save_sankey(p_phylogeny, "fun2tax_phylogeny.pdf")

p_chord <- fun2tax_chord(
  result_fun, "KO_contrib.tsv.gz", ps1, group = "group", draw = FALSE
)
save_chord(p_chord, "fun2tax_chord.html")
save_chord(p_chord, "fun2tax_chord.pdf")

p_box <- fun2tax_box(
  "KO_contrib.tsv.gz", result_fun, ps1, "group", group_functions = FALSE
)
p_dendro <- fun2tax_dendro(result_fun)
p_logfc <- fun2tax_logfc(result_fun)
```

For tax2fun, the plotting APIs retain their names. `tax2fun_dendro()` additionally
accepts `top_n_per_taxon`; `top_n_per_genus` remains a compatible alias.

Taxonomy and phylogeny are Sankey side-tree modes. Chord uses its existing
ancestor taxonomy bands. No new phylogenetic topology is inferred by Chord or
the circular association dendrogram.

## Reproduce the example output

```r
Sys.setenv(MICROFUN_EXAMPLE_OUTPUT = "D:/MicroFun/example_output_0.1.0")
source(system.file("examples/revision_0_1_0.R", package = "MicroFun"))
```

Install optional `rsvg` for tree Sankey PDF/PNG. For source-only visual testing,
set `MICROFUN_SOURCE` to the extracted `MicroFun` directory before running the
script. This route needs the plotting dependencies used by the script but not
all statistical backends.

The example archive includes synthetic stratified contributions, a phyloseq
object, taxonomy, an ASV tree and illustrative differential tables. Genus and
Class examples cover both directions, taxonomy/phylogeny Sankey, Chord,
boxplots, dendrograms and signed bars. The effect estimates and p-values are
illustrative inputs, not differential analyses fitted to the synthetic counts.
