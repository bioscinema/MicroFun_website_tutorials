test_that("stratified chord weights, contrasts and exports are consistent", {
workdir <- tempfile("MicroFun_chord_checks_")
dir.create(workdir)
old_wd <- getwd()
on.exit({setwd(old_wd); unlink(workdir, recursive = TRUE)}, add=TRUE)
setwd(workdir)
samples <- c('S1','S2','L1','L2')
meta <- data.frame(group=factor(c('STS','STS','LTS','LTS'),levels=c('STS','LTS')),row.names=samples)
tax <- data.frame(Phylum=c('P1','P2'),Class=c('ClassA','ClassB'),Order=c('O1','O2'),Family=c('F1','F2'),Genus=c('G1','G2'),row.names=c('a1','a2'))
phy <- phyloseq::phyloseq(
  phyloseq::otu_table(matrix(1, nrow=2, ncol=4, dimnames=list(c('a1','a2'), samples)), taxa_are_rows=TRUE),
  phyloseq::tax_table(as.matrix(tax)), phyloseq::sample_data(meta))
raw <- data.frame(sample=c('S1','L1','L2',samples),taxon=c(rep('a1',3),rep('a2',4)),
                  function_id=c(rep('K00001',3),rep('K00002',4)), taxon_function_abun=c(2,6,10,8,8,4,4))
names(raw)[3] <- 'function'
write.table(raw,'fixture.tsv',sep='\t',quote=FALSE,row.names=FALSE)
res <- list(ClassA=data.frame(feature='K00001',logFC=0.4,p_adjust=0.01,group1='STS',group2='LTS',method='Maaslin2'),
            ClassB=data.frame(feature='K00002',logFC=-0.2,p_adjust=0.02,group1='STS',group2='LTS',method='Maaslin2'))
ft <- data.frame(function_id=c('K00001','K00002'),function_group=c('Metabolism','Processing'))
make <- function(r=res, p=phy, ...) tax2fun_chord(r,'fixture.tsv',p,group='group',taxon_level='Class',function_level='KO',contrast=c('STS','LTS'),function_table=ft,draw=FALSE,...)
p <- make()
stopifnot(inherits(p,'microfun_chord'),nrow(p$links)==2,identical(names(p$tax_table),c('taxon_id','Phylum')))
stopifnot(p$links$contribution[p$links$taxon=='ClassA']==4.5,p$links$contribution[p$links$taxon=='ClassB']==6)
stopifnot(p$links$mean_group1[p$links$taxon=='ClassA']==1,p$links$mean_group2[p$links$taxon=='ClassA']==8)
stopifnot(p$links$edge_direction[p$links$taxon=='ClassB']=='Down')
# Unequal groups: remove S2, so balanced mean=(2+8)/2=5; pooled mean=18/3=6.
phy2 <- phyloseq::prune_samples(c('S1','L1','L2'),phy)
a <- make(p=phy2); b <- make(p=phy2,contribution='mean')
stopifnot(a$links$contribution[a$links$taxon=='ClassA']==5,b$links$contribution[b$links$taxon=='ClassA']==6)
# Function-oriented output must produce the same raw edge weights.
rf <- list(K00001=transform(res$ClassA,feature='ClassA'),K00002=transform(res$ClassB,feature='ClassB'))
f <- make(r=rf,direction='function')
stopifnot(identical(f$links$contribution,p$links$contribution))
rd <- res; rd$ClassA <- rbind(rd$ClassA,rd$ClassA)
expect_error(make(r=rd),'Duplicate')
phy_missing <- phy
phyloseq::sample_names(phy_missing)[1] <- 'absent'
expect_error(make(p=phy_missing),'completely absent')
expect_error(make(padj_cutoff=0),'No edges')
re <- res; re$ClassA$logFC <- NULL
expect_error(make(r=re),'no effect')
# KO -> KEGG uses the actual package mapping, not matching numeric suffixes.
ref <- ko_to_kegg_reference
idx <- which(apply(ref[,-1,drop=FALSE],1,function(x) 'K00001' %in% x))[1]
stopifnot(!is.na(idx))
fid <- as.character(ref[idx,1])
rk <- list(ClassA=transform(res$ClassA,feature=fid))
k <- tax2fun_chord(rk,'fixture.tsv',phy,group='group',taxon_level='Class',function_level='KEGG',contrast=c('STS','LTS'),
                   function_table=data.frame(function_id=fid,function_group='Metabolism'),draw=FALSE)
stopifnot(nrow(k$links)==1,k$links$contribution==4.5)
# Automatic KO annotation loads the bundled reference file.
expect_warning(
  auto <- tax2fun_chord(res, 'fixture.tsv', phy, group = 'group',
    taxon_level = 'Class', function_level = 'KO', contrast = c('STS', 'LTS'), draw = FALSE),
  'conflicting annotations'
)
stopifnot(nrow(auto$function_table)==2)
# Genus displays four ancestor tracks.
rg <- res; names(rg) <- c('G1','G2')
g <- tax2fun_chord(rg,'fixture.tsv',phy,group='group',taxon_level='Genus',function_level='KO',contrast=c('STS','LTS'),function_table=ft,draw=FALSE)
stopifnot(ncol(g$tax_table)==5)
.save_chord(p,'chord_class.pdf','pdf')
.save_chord(g,'chord_genus.pdf','pdf')
stopifnot(file.info('chord_class.pdf')$size>1000,file.info('chord_genus.pdf')$size>1000)
stopifnot(length(circlize::get.all.sector.index())==0)
# Replot with legend hidden, and check renderer error closes the export device.
olddev <- dev.cur()
p$settings$graphical$effect_scale <- -1
expect_error(.save_chord(p,'error.pdf','pdf'),'positive')
stopifnot(dev.cur()==olddev)

})
