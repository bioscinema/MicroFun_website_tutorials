library(MicroFun)

# Synthetic associations and ASV taxonomy.
taxonomy <- data.frame(
  Phylum = c("P1", "P1", "P2"),
  Genus = c("GenusA", "GenusA", "GenusB"),
  row.names = c("ASV1", "ASV2", "ASV3")
)
result_taxa <- list(
  GenusA = data.frame(pathway_class = c("Metabolism", "Human Diseases"),
                      logFC = c(0.8, -0.4), p_adjust = c(0.01, 0.02)),
  GenusB = data.frame(pathway_class = "Metabolism", logFC = 0.6, p_adjust = 0.03)
)
phylogeny <- ape::read.tree(text = "((ASV1:0.1,ASV2:0.2):0.3,ASV3:0.4);")
p <- tax2fun_sankey(result_taxa, tree_mode = "phylogeny",
                    taxonomy = taxonomy, phylo_tree = phylogeny)
p

# Export without refitting a model.
output_dir <- file.path(tempdir(), "MicroFun_examples")
dir.create(output_dir, showWarnings = FALSE)
save_sankey(p, file.path(output_dir, "tree_sankey.html"))
save_sankey(p, file.path(output_dir, "tree_sankey.svg"))
save_sankey(p, file.path(output_dir, "tree_sankey.rds"))
