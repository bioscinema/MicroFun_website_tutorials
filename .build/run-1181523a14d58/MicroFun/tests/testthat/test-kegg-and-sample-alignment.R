test_that("limma P values follow selected sample IDs and coefficient columns", {
  skip_if_not_installed("limma")
  skip_if_not_installed("edgeR")
  set.seed(40)
  ids <- paste0("s", 1:12)
  counts <- matrix(rpois(120, 35), nrow = 10,
    dimnames = list(paste0("K", 1:10), ids))
  metadata <- data.frame(sample_id = ids, group = rep(c("A", "B", "C"), each = 4))
  selected <- ids[c(12, 2, 6, 11, 1, 7, 9, 3, 5)]
  result <- pathway_daa(counts, metadata[12:1, ], group = "group",
    daa_method = "limma voom", select = selected, reference = "B")

  groups <- stats::relevel(factor(metadata$group[match(selected, ids)]), "B")
  design <- stats::model.matrix(~groups)
  dge <- edgeR::calcNormFactors(edgeR::DGEList(counts[, selected], group = groups))
  fit <- limma::eBayes(limma::lmFit(limma::voom(dge, design), design))
  expect_equal(result$feature, rep(rownames(counts), 2))
  expect_equal(result$group1, rep("B", 20))
  expect_equal(result$group2, rep(c("A", "C"), each = 10))
  expect_equal(result$p_values, as.vector(fit$p.value[, -1]))
})

test_that("KEGG boxplots sum mapped raw KO contributions once per sample", {
  skip_if_not_installed("phyloseq")
  ids <- c("s1", "s2", "s3", "s4")
  metadata <- data.frame(group = c("A", "A", "B", "B"), row.names = ids)
  phy <- phyloseq::phyloseq(
    phyloseq::otu_table(matrix(1, 1, 4, dimnames = list("a1", ids)), taxa_are_rows = TRUE),
    phyloseq::tax_table(matrix("G1", 1, 1, dimnames = list("a1", "Genus"))),
    phyloseq::sample_data(metadata))
  rows <- data.frame(sample = c("s1", "s1", "s1", "s2", "s3", "s4"), taxon = "a1",
    function_id = c("ko:K00844", "K00101", "K00010", "K00844", "K00010", "K00844"),
    taxon_function_abun = c(90, 1, 700, 20, 100, 30),
    norm_taxon_function_contrib = c(.9, .5, 1, 1, 1, 1))
  names(rows)[3] <- "function"
  contrib <- tempfile(fileext = ".tsv")
  mapping <- tempfile(fileext = ".tsv")
  on.exit(unlink(c(contrib, mapping)), add = TRUE)
  utils::write.table(rows, contrib, sep = "\t", quote = FALSE, row.names = FALSE)
  writeLines(c("map00010\tK00844\tK00101", "ko00010\tK00844", "ko00020\tK00010"), mapping)
  results <- list(G1 = data.frame(feature = rep("ko00010", 2), pathway_name = "Glycolysis"))
  plot <- tax2fun_box(contrib, results, phy, group = "group", kegg_map = mapping)$G1
  expect_equal(plot$data$abundance[match(ids, plot$data$sample)], c(91, 20, 0, 30))
  expect_equal(nrow(plot$data), length(ids))

  results <- list(G1 = data.frame(feature = "K00010", pathway_name = "KO"))
  plot <- tax2fun_box(contrib, results, phy, group = "group")$G1
  expect_equal(plot$data$abundance[match(ids, plot$data$sample)], c(700, 0, 100, 0))
})
