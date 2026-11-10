# Interleaved taxa expose the difference between first-tip and median order.
ordering_fixture <- function() {
  tx <- data.frame(Genus=c("A","B","B","C","C","A","A"),
                   row.names=paste0("s",1:7))
  tr <- ape::read.tree(text="((s1:.1,(s2:.1,s3:.2):.2):.1,((s4:.1,s5:.2):.1,(s6:.1,s7:.2):.2):.2);")
  r <- setNames(lapply(c("A","B","C"), function(taxon)
    data.frame(pathway_class=c("K00001","K00002"),logFC=c(.5,-.2),p_adjust=.01)),c("A","B","C"))
  rr <- list(K00001=data.frame(feature=c("A","B","C"),logFC=.5,p_adjust=.01),
             K00002=data.frame(feature=c("A","B","C"),logFC=-.2,p_adjust=.01))
  list(tx=tx,tr=tr,r=r,rr=rr)
}

test_that("median ordering works in both directions without changing the tree or weights", {
  z <- ordering_fixture()
  old <- tax2fun_sankey(z$r,tree_mode="phylogeny",taxonomy=z$tx,phylo_tree=z$tr,phylogeny_order="first")
  p <- tax2fun_sankey(z$r,tree_mode="phylogeny",taxonomy=z$tx,phylo_tree=z$tr)
  q <- fun2tax_sankey(z$rr,group_functions=FALSE,tree_mode="phylogeny",taxonomy=z$tx,phylo_tree=z$tr)
  expect_identical(old$x$microfun_tree$order,c("A","B","C"))
  for (widget in list(p,q)) {
    tree <- widget$x$microfun_tree
    expect_identical(tree$order,c("B","C","A"))
    expect_identical(tree$taxon_bands$taxon,c("B","C","A"))
    expect_true(all(diff(tree$taxon_bands$cy)>0))
    expect_equal(tree$taxon_order$median_tip_position,c(2.5,4.5,6))
    expect_equal(tree$taxon_order$n_tips,c(2L,2L,3L))
    expect_identical(tree$diagnostics$noncontiguous_taxa,"A")
    expect_identical(tree$trees,old$x$microfun_tree$trees)
    expect_identical(tree$mapping$tip,old$x$microfun_tree$mapping$tip)
    expect_identical(tree$mapping$tip_position,1:7)
    expect_identical(tree$mapping$taxon_position,c(3L,1L,1L,2L,2L,3L,3L))
    expect_equal(sum(widget$x$microfun_edges$pixel_width),sum(tree$taxon_bands$h))
  }
  expect_equal(sort(p$x$microfun_edges$value),sort(old$x$microfun_edges$value))
  expect_equal(sort(q$x$microfun_edges$value),rep(1,6))
  expect_identical(p$x$microfun_tree$nodes,old$x$microfun_tree$nodes)
  expect_error(tax2fun_sankey(z$r,tree_mode="phylogeny",taxonomy=z$tx,
    phylo_tree=z$tr,phylogeny_order="alphabetical"),"arg")
})

test_that("median ties use first tip position, independent of result list order", {
  z <- ordering_fixture()
  z$tx$Genus <- c("A","B","C","C","B","A","D")
  z$r$D <- z$r$A
  p <- tax2fun_sankey(z$r,tree_mode="phylogeny",taxonomy=z$tx,phylo_tree=z$tr)
  q <- tax2fun_sankey(rev(z$r),tree_mode="phylogeny",taxonomy=z$tx,phylo_tree=z$tr)
  expect_identical(p$x$microfun_tree$order,c("A","B","C","D"))
  expect_equal(p$x$microfun_tree$taxon_order$median_tip_position,c(3.5,3.5,3.5,7))
  expect_identical(p$x$microfun_tree$taxon_order,q$x$microfun_tree$taxon_order)
})

test_that("forest order, missing taxa, and taxonomy mode stay explicit", {
  z <- ordering_fixture()
  forest <- list(bac=ape::keep.tip(z$tr,paste0("s",1:3)),
                 arc=ape::keep.tip(z$tr,paste0("s",4:7)))
  p <- tax2fun_sankey(z$r,tree_mode="phylogeny",taxonomy=z$tx,phylo_tree=forest)
  expect_equal(sum(is.na(p$x$microfun_tree$nodes$parent)),2)
  expect_identical(p$x$microfun_tree$order,c("B","C","A"))
  expect_identical(p$x$microfun_tree$mapping$tree,c(rep("bac",3),rep("arc",4)))
  z$tx <- rbind(z$tx,data.frame(Genus="D",row.names="missing")); z$r$D <- z$r$A
  q <- suppressWarnings(tax2fun_sankey(z$r,tree_mode="phylogeny",taxonomy=z$tx,
    phylo_tree=z$tr,missing_taxa="drop"))
  expect_identical(q$x$microfun_tree$order,c("B","C","A"))
  expect_identical(q$x$microfun_tree$diagnostics$missing_taxa,"D")
  z$tx$Phylum <- "P"
  a <- tax2fun_sankey(z$r,tree_mode="taxonomy",taxonomy=z$tx,phylogeny_order="first")
  b <- tax2fun_sankey(z$r,tree_mode="taxonomy",taxonomy=z$tx,phylogeny_order="median")
  expect_identical(a$x$svg,b$x$svg)
})
