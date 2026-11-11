revision_fixture <- function() {
  samples <- paste0("s",1:6)
  tx <- data.frame(Phylum=c("Bacillota","Bacillota","Bacteroidota"),
    Class=c("Bacilli","Clostridia","Bacteroidia"),
    Order=c("Lactobacillales","Eubacteriales","Bacteroidales"),
    Family=c("Lactobacillaceae","Lachnospiraceae","Bacteroidaceae"),
    Genus=c("Lactobacillus","Roseburia","Bacteroides"),row.names=paste0("a",1:3))
  meta <- data.frame(group=factor(rep(c("Control","Treatment"),each=3),levels=c("Control","Treatment")),row.names=samples)
  ps <- phyloseq::phyloseq(phyloseq::otu_table(matrix(1,3,6,dimnames=list(rownames(tx),samples)),taxa_are_rows=TRUE),
    phyloseq::tax_table(as.matrix(tx)), phyloseq::sample_data(meta))
  tr <- ape::read.tree(text="((a1:0.2,a2:0.3):0.1,a3:0.4);")
  fun <- c("K00001","K00002","K00844")
  res <- setNames(lapply(seq_len(3),function(i) data.frame(feature=fun,
    pathway_name=c("Alcohol dehydrogenase","NADP alcohol dehydrogenase","Hexokinase"),
    pathway_class=c("Metabolism","Metabolism","Genetic Information Processing"),
    logFC=c(1,-.7,.4)*if(i==2)-1 else 1,p_adjust=.01,
    group1="Control",group2="Treatment",method="Maaslin2")),tx$Genus)
  attr(res,"microfun") <- list(taxon_level="Genus",direction="taxa",group="group",pathway="KO",function_level="KO",reference="Control")
  reverse <- setNames(lapply(seq_along(fun),function(j) data.frame(feature=tx$Genus,
    logFC=vapply(res,function(z)z$logFC[j],numeric(1)),p_adjust=.01,
    group1="Control",group2="Treatment",method="Maaslin2")),fun)
  attr(reverse,"microfun") <- modifyList(attr(res,"microfun"),list(direction="function"))
  raw <- expand.grid(sample=samples,taxon=rownames(tx),function_id=fun,stringsAsFactors=FALSE)
  raw$taxon_function_abun <- seq_len(nrow(raw)) %% 11 + 1
  names(raw)[3] <- "function"
  path <- tempfile(fileext=".tsv")
  utils::write.table(raw,path,sep="\t",quote=FALSE,row.names=FALSE)
  list(tx=tx,ps=ps,tr=tr,res=res,reverse=reverse,path=path,raw=raw)
}

test_that("rank metadata controls labels and rejects mismatched plotting ranks", {
  z <- revision_fixture(); on.exit(unlink(z$path))
  r <- z$res; names(r) <- z$tx$Class
  attr(r,"microfun")$taxon_level <- "Class"
  p <- tax2fun_sankey(r,tree_mode="taxonomy",taxonomy=z$tx)
  expect_equal(p$x$settings$taxon_level,"Class")
  expect_match(p$x$svg,"Taxon (Class)",fixed=TRUE)
  expect_error(tax2fun_sankey(r,tree_mode="taxonomy",taxonomy=z$tx,taxon_level="Genus"),"differs")
  d <- tax2fun_dendro(r)
  expect_equal(d$plot$scales$get_scales("colour")$name,"Class")
  b <- tax2fun_box(z$path,r,z$ps,group="group")
  expect_setequal(names(b),z$tx$Class)
  expect_error(fun2tax_sankey(r),"direction")
  testthat::skip_if_not_installed("xml2")
  texts <- xml2::xml_find_all(xml2::read_xml(p$x$svg),".//*[local-name()='text']")
  labels <- vapply(texts, function(x) xml2::xml_text(xml2::xml_find_first(x, "./text()")), character(1))
  # Tree node labels and taxon endpoint labels share the configured 16px type.
  matched <- texts[labels %in% c("Bacil...","Bacte...",z$tx$Class)]
  expect_true(length(matched)>=3)
  expect_true(all(xml2::xml_attr(matched,"font-size")=="16.00"))
})

test_that("both function-to-taxon tree modes conserve association weights", {
  z <- revision_fixture(); on.exit(unlink(z$path))
  for(mode in c("taxonomy","phylogeny")) {
    p <- fun2tax_sankey(z$reverse,group_functions=FALSE,tree_mode=mode,taxonomy=z$tx,phylo_tree=z$tr)
    expect_false(p$x$settings$taxa_on_left)
    expect_equal(sum(p$x$microfun_tree$taxon_bands$weight),9)
    expect_equal(sum(p$x$microfun_tree$function_bands$h),sum(p$x$microfun_tree$taxon_bands$h))
    expect_equal(unname(p$x$settings$node_color[c("Up","Down")]),c("#F5BB7C","#B4CBE0"))
  }
  ft <- data.frame(function_id=names(z$reverse),function_group="Metabolism")
  a <- tax2fun_chord(z$res,z$path,z$ps,"group",function_table=ft,draw=FALSE)
  b <- fun2tax_chord(z$reverse,z$path,z$ps,"group",function_table=ft,draw=FALSE)
  rownames(a$links) <- rownames(b$links) <- NULL
  expect_equal(a$links[c("taxon","function_id","contribution","edge_direction")],b$links[c("taxon","function_id","contribution","edge_direction")])
  d <- fun2tax_dendro(z$reverse)
  expect_equal(d$plot$scales$get_scales("colour")$name,"Function")
  expect_setequal(d$used_functions,names(z$reverse))
  expect_length(fun2tax_logfc(z$reverse),3)
})

test_that("ungrouped function boxplots remain separate and show structural zeros", {
  z <- revision_fixture(); on.exit(unlink(z$path))
  # Remove just one taxon/sample/function record; the sample still exists.
  raw <- z$raw[-1,]
  utils::write.table(raw,z$path,sep="\t",quote=FALSE,row.names=FALSE)
  plots <- fun2tax_box(z$path,z$reverse,z$ps,"group",group_functions=FALSE)
  expect_setequal(names(plots),names(z$reverse))
  expect_equal(nrow(plots[[1]]$data),18)
  expect_equal(min(plots[[1]]$data$abundance),0)
  build <- ggplot2::ggplot_build(plots[[1]])
  expect_setequal(build$data[[1]]$fill,c("#B4CBE0","#F5BB7C"))
  expect_true(all(build$data[[1]]$alpha==1))
})

test_that("chord names resolve from bundled annotations and omit Terminal", {
  z <- revision_fixture(); on.exit(unlink(z$path))
  ft <- data.frame(function_id=names(z$reverse),function_group="Metabolism")
  p <- fun2tax_chord(z$reverse,z$path,z$ps,"group",function_table=ft,draw=FALSE)
  file <- tempfile(fileext="pdf"); on.exit(unlink(file),add=TRUE)
  grDevices::pdf(file,width=16,height=16)
  rendered <- tryCatch(.draw_tax2fun_chord(p,narrow_labels="letters"),finally=grDevices::dev.off())
  labels <- rendered$label_mapping
  fn <- labels$full_name[labels$side=="Function" & labels$rank=="KO"]
  expect_true(all(grepl("\\[K[0-9]{5}\\]$",fn)))
  expect_true(all(!labels$rank %in% "Terminal"))
  expect_true(all(!grepl("Terminal",unlist(lapply(rendered$legend_blocks,`[[`,"legend")))))
  expect_match(.microfun_function_names(list(),"function","KEGG","ko00010"),"Glycolysis")
  expect_match(.microfun_reference_map("EC")[["1.1.1.1"]],"Alcohol",ignore.case=TRUE)
  expect_true(length(.microfun_reference_map("MetaCyc"))>0)
})


test_that("EC and MetaCyc function trees use the bundled reference schema", {
  z <- revision_fixture(); on.exit(unlink(z$path))
  for (namespace in c("EC", "MetaCyc")) {
    id <- names(.microfun_reference_map(namespace))[1]
    r <- z$reverse[1]
    names(r) <- id
    attr(r,"microfun")$pathway <- namespace
    p <- fun2tax_sankey(r,pathway=namespace,tree_mode="taxonomy",taxonomy=z$tx)
    expect_equal(sum(p$x$microfun_tree$taxon_bands$weight),3)
    raw <- z$raw[z$raw[["function"]]=="K00001",]
    raw[["function"]] <- id
    utils::write.table(raw,z$path,sep="\t",quote=FALSE,row.names=FALSE)
    plots <- fun2tax_box(z$path,r,z$ps,"group",pathway=namespace)
    expect_length(plots,1)
    expect_equal(nrow(plots[[1]]$data),18)
  }
})
