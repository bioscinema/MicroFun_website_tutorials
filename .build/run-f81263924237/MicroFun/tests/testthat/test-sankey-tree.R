# Targeted checks: mapping and flow conservation, not just rendering snapshots.
fixture_tree_sankey <- function() {
  tx <- data.frame(Phylum=c('P1','P1','P1','P2'),Family=c('F1','F1','F2','F3'),
                   Genus=c('A','A','B','C'),row.names=c('s1','s2','s3','s4'))
  r <- list(A=data.frame(pathway_class=c('f1','f2'),logFC=c(1,-1),p_adjust=c(.01,.02)),
            B=data.frame(pathway_class='f2',logFC=.5,p_adjust=.03),
            C=data.frame(pathway_class='f1',logFC=-.5,p_adjust=.04))
  tr <- ape::read.tree(text='((s1:0.1,s3:0.2):0.2,(s2:0.1,s4:0.3):0.1,reference:0.5);')
  list(tx=tx,r=r,tr=tr)
}
test_that('multiple ASVs do not multiply genus-level association weights', {
  z <- fixture_tree_sankey()
  p <- tax2fun_sankey(z$r,tree_mode='phylogeny',taxonomy=z$tx,phylo_tree=z$tr)
  expect_s3_class(p,'htmlwidget')
  expect_equal(nrow(p$x$microfun_tree$mapping),4)
  expect_equal(nrow(p$x$microfun_edges),4)
  expect_equal(sum(p$x$microfun_tree$taxon_bands$weight),4)
  expect_equal(sum(p$x$microfun_tree$function_bands$weight),4)
  expect_equal(sum(p$x$microfun_edges$pixel_width),sum(p$x$microfun_tree$taxon_bands$h))
  expect_equal(p$x$microfun_tree$order,c('A','B','C'))
  expect_true('reference' %in% p$x$microfun_tree$diagnostics$removed_tips)
  kept <- p$x$microfun_tree$trees[[1]]
  expect_equal(ape::cophenetic.phylo(kept),ape::cophenetic.phylo(z$tr)[kept$tip.label,kept$tip.label])
})
test_that('one-to-one trees are vertically aligned and reversed weights preserved', {
  z <- fixture_tree_sankey(); tr <- ape::read.tree(text='(A:.1,(B:.2,C:.2):.1);')
  p <- tax2fun_sankey(z$r,tree_mode='phylogeny',phylo_tree=tr,tree_tip_level='taxon')
  t <- p$x$microfun_tree
  expect_equal(t$nodes$y[t$leaves],unname(t$taxon_bands[t$order,'cy']))
  rr <- list(K00001=data.frame(feature=c('A','B','C'),logFC=c(-1,0,1),p_adjust=.01))
  q <- fun2tax_sankey(rr,group_functions=FALSE,tree_mode='phylogeny',phylo_tree=tr,tree_tip_level='taxon')
  expect_false(q$x$settings$taxa_on_left)
  expect_equal(sort(q$x$microfun_edges$value),rep(1,3))
  expect_equal(sum(q$x$microfun_tree$taxon_bands$h),sum(q$x$microfun_tree$function_bands$h))
})
test_that('taxonomy uses full ancestry paths and rejects ambiguous genus names', {
  z <- fixture_tree_sankey(); z$tx$Family <- 'Unclassified'
  p <- tax2fun_sankey(z$r,tree_mode='taxonomy',taxonomy=z$tx)
  n <- p$x$microfun_tree$nodes
  expect_equal(sum(n$label=='Family: Unclassified'),2)
  expect_equal(sum(p$x$microfun_edges$value),4)
  z$tx$Phylum[2] <- 'Conflicting'
  expect_error(tax2fun_sankey(z$r,tree_mode='taxonomy',taxonomy=z$tx),'Ambiguous')
})
test_that('missing IDs and duplicate domain placements are explicit', {
  z <- fixture_tree_sankey(); tr <- ape::read.tree(text='(s1:.1,s3:.2);')
  expect_error(tax2fun_sankey(z$r,tree_mode='phylogeny',taxonomy=z$tx,phylo_tree=tr),'No matched')
  p <- suppressWarnings(tax2fun_sankey(z$r,tree_mode='phylogeny',taxonomy=z$tx,phylo_tree=tr,missing_taxa='drop'))
  expect_equal(p$x$microfun_tree$diagnostics$missing_taxa,'C')
  expect_equal(sum(p$x$microfun_edges$value),3)
  expect_error(tax2fun_sankey(z$r,tree_mode='phylogeny',taxonomy=z$tx,phylo_tree=list(bac=z$tr,arc=z$tr)),'multiple trees')
})
test_that('forests stay separate and topology-only trees remain valid', {
  z <- fixture_tree_sankey()
  tr <- list(bac=ape::read.tree(text='(s1:.1,s2:.2,s3:.3);'),arc=ape::read.tree(text='(s4:.1,ref:.2);'))
  p <- tax2fun_sankey(z$r,tree_mode='phylogeny',taxonomy=z$tx,phylo_tree=tr)
  expect_equal(sum(is.na(p$x$microfun_tree$nodes$parent)),2)
  q <- tax2fun_sankey(z$r,tree_mode='phylogeny',taxonomy=z$tx,
    phylo_tree=ape::read.tree(text='((s1,s2),(s3,s4));'),show_branch_length=FALSE)
  expect_false(q$x$microfun_tree$branch_lengths)
  expect_true(all(is.finite(q$x$microfun_tree$nodes$y)))
})
test_that('single taxon, polytomy and zero length branches have finite layouts', {
  z <- fixture_tree_sankey()
  for(txt in c('(s1:0,s2:0,s3:0,s4:0);','((s1:0,s3:0):0,(s2:0,s4:0):0);')) {
    p <- tax2fun_sankey(z$r,tree_mode='phylogeny',taxonomy=z$tx,phylo_tree=ape::read.tree(text=txt))
    expect_true(all(is.finite(p$x$microfun_tree$nodes$y)))
    expect_true(all(is.finite(p$x$microfun_tree$nodes$x)))
  }
  p <- tax2fun_sankey(z$r['C'],tree_mode='phylogeny',taxonomy=z$tx,phylo_tree=z$tr)
  expect_equal(nrow(p$x$microfun_tree$mapping),1)
  expect_true(all(is.finite(p$x$microfun_tree$nodes$y)))
})
test_that('PICRUSt2 tree discovery prefers reduced trees', {
  z <- fixture_tree_sankey(); d <- tempfile(); dir.create(d)
  on.exit(unlink(d,recursive=TRUE))
  ape::write.tree(z$tr,file=file.path(d,'bac.tre'))
  ape::write.tree(z$tr,file=file.path(d,'arc.tre'))
  expect_error(tax2fun_sankey(z$r,tree_mode='phylogeny',taxonomy=z$tx,picrust2_dir=d),'ambiguous')
  ape::write.tree(z$tr,file=file.path(d,'bac_reduced.tre'))
  p <- tax2fun_sankey(z$r,tree_mode='phylogeny',taxonomy=z$tx,picrust2_dir=d)
  expect_identical(names(p$x$microfun_tree$trees),'bac_reduced.tre')
})
test_that('HTML/SVG exports escape labels and retain the same geometry', {
  z <- fixture_tree_sankey(); z$r$A$pathway_class[1] <- '<script>alert(1)</script>'
  p <- tax2fun_sankey(z$r,tree_mode='taxonomy',taxonomy=z$tx)
  expect_true(grepl('&lt;script&gt;',p$x$svg,fixed=TRUE))
  expect_false(grepl('<script>',p$x$svg,fixed=TRUE))
  f <- tempfile(fileext='.html'); on.exit(unlink(f))
  save_sankey(p,f)
  expect_true(grepl(p$x$svg,paste(readLines(f),collapse='\n'),fixed=TRUE))
})
