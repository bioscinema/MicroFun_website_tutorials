# Reproducible visual regression examples using SYNTHETIC contributions and
# illustrative differential results (no biological/statistical inference).
# Normal use: library(MicroFun); source("revision_0_1_0.R")
# Optional: Sys.setenv(MICROFUN_SOURCE="path/to/MicroFun") to test source directly.
# Optional: Sys.setenv(MICROFUN_EXAMPLE_OUTPUT="path/to/output")
source_root <- Sys.getenv("MICROFUN_SOURCE", "")
if (nzchar(source_root)) {
  suppressPackageStartupMessages({
    library(ggplot2); library(dplyr); library(tidyr); library(phyloseq)
    library(data.table); library(igraph); library(htmlwidgets); library(jsonlite)
  })
  .microfun_source_dir <- normalizePath(source_root)
  for(f in list.files(file.path(source_root,"R"),pattern="[.]R$",full.names=TRUE)) source(f)
  load(file.path(source_root,"R/sysdata.rda"))
} else {
  library(MicroFun)
}
if (!requireNamespace("rsvg",quietly=TRUE)) stop("Install rsvg to export tree Sankey PDF/PNG.")
out <- Sys.getenv("MICROFUN_EXAMPLE_OUTPUT", "MicroFun_examples_0.1.0")
dir.create(out,recursive=TRUE,showWarnings=FALSE)
for(d in c("data","sankey","chord","boxplots","dendrogram","effects"))dir.create(file.path(out,d),showWarnings=FALSE)
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

z <- revision_fixture()
file.copy(z$path,file.path(out,"data/synthetic_KO_contrib.tsv"),overwrite=TRUE)
unlink(z$path)
z$path <- file.path(out,"data/synthetic_KO_contrib.tsv")
physeq <- z$ps
taxonomy <- z$tx
phylo_tree <- z$tr
taxa_result <- z$res
function_result <- z$reverse
save(physeq,taxonomy,phylo_tree,taxa_result,function_result,file=file.path(out,"data/synthetic_inputs.RData"))
utils::write.table(z$tx,file.path(out,"data/taxonomy.tsv"),sep="\t",quote=FALSE,col.names=NA)
ape::write.tree(z$tr,file=file.path(out,"data/asv_tree.nwk"))
export_gg <- function(p, folder, name, width=9, height=6) {
  ggplot2::ggsave(file.path(out,folder,paste0(name,".pdf")),p,width=width,height=height,device=grDevices::cairo_pdf)
  ggplot2::ggsave(file.path(out,folder,paste0(name,".png")),p,width=width,height=height,dpi=140,bg="white")
}
for(rank in c("Genus","Class")) {
  r <- z$res
  names(r) <- z$tx[[rank]]
  attr(r,"microfun")$taxon_level <- rank
  rr <- z$reverse
  for(k in names(rr)) rr[[k]]$feature <- z$tx[[rank]]
  attr(rr,"microfun")$taxon_level <- rank
  for(mode in c("taxonomy","phylogeny")) {
    for(direction in c("tax2fun","fun2tax")) {
      args <- list(tree_mode=mode, taxonomy=z$tx, phylo_tree=z$tr,
        tree_options=list(title=paste(direction,rank,mode),font_size=16))
      p <- if(direction=="tax2fun") do.call(tax2fun_sankey,c(list(pathway_sdaa_result=r),args)) else
        do.call(fun2tax_sankey,c(list(pathway_sdaa_result=rr,group_functions=FALSE),args))
      name <- paste(direction,rank,mode,sep="_")
      for(ext in c("html","svg","pdf","png","rds")) save_sankey(p,file.path(out,"sankey",paste0(name,".",ext)))
    }
  }
  ft <- data.frame(function_id=names(z$reverse),function_group=c("Metabolism","Metabolism","Genetic Information Processing"))
  for(direction in c("tax2fun","fun2tax")) {
    cplot <- if(direction=="tax2fun") tax2fun_chord(r,z$path,z$ps,"group",function_table=ft,draw=FALSE) else
      fun2tax_chord(rr,z$path,z$ps,"group",function_table=ft,draw=FALSE)
    name <- paste(direction,rank,sep="_")
    for(ext in c("pdf","html","png","rds")) save_chord(cplot,file.path(out,"chord",paste0(name,".",ext)),
      width=14,height=13,function_label_cex=0.63)
  }
  b1 <- tax2fun_box(z$path,r,z$ps,group="group")
  b2 <- fun2tax_box(z$path,rr,z$ps,"group",group_functions=FALSE)
  export_gg(b1[[1]],"boxplots",paste0("tax2fun_",rank))
  export_gg(b2[[1]],"boxplots",paste0("fun2tax_",rank))
  export_gg(tax2fun_dendro(r,label_size=2.4)$plot,"dendrogram",paste0("tax2fun_",rank),11,10)
  export_gg(fun2tax_dendro(rr,label_size=2.4)$plot,"dendrogram",paste0("fun2tax_",rank),11,10)
  export_gg(tax2fun_logfc(r)[[1]],"effects",paste0("tax2fun_",rank))
  export_gg(fun2tax_logfc(rr)[[1]],"effects",paste0("fun2tax_",rank))
}
# The legacy networkD3 branch is also exercised and exported with local assets.
p <- fun2tax_sankey(z$reverse,group_functions=FALSE)
htmlwidgets::saveWidget(p,file.path(out,"sankey/fun2tax_no_tree.html"),selfcontained=FALSE)
p <- tax2fun_sankey(z$res)
htmlwidgets::saveWidget(p,file.path(out,"sankey/tax2fun_no_tree.html"),selfcontained=FALSE)
writeLines(capture.output(sessionInfo()),file.path(out,"sessionInfo.txt"))
message("Examples written to ", normalizePath(out))
