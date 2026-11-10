test_that("aggregation preserves signed weights and original records", {
  tx <- data.frame(Genus=c("A","A","B"),row.names=c("a1","a2","b"))
  tr <- ape::read.tree(text="((a1:1,a2:1):1,b:2);")
  r <- list(A=data.frame(pathway_class=c("F","F","F"),logFC=c(.5,.7,-.2),p_adjust=.01),
            B=data.frame(pathway_class="F",logFC=.3,p_adjust=.01))
  x <- tax2fun_sankey(r,tree_mode="phylogeny",taxonomy=tx,phylo_tree=tr)
  raw <- x$x$microfun_edges; ribbons <- x$x$microfun_ribbons
  expect_equal(nrow(raw),4L);expect_equal(nrow(ribbons),3L)
  expect_equal(sum(raw$value),sum(ribbons$value))
  for(i in seq_len(nrow(ribbons))) {
    expect_equal(sum(raw$value[raw$draw_group==i]),ribbons$value[i])
    expect_equal(sum(raw$draw_group==i),ribbons$n_records[i])
  }
  expect_equal(sum(x$x$microfun_tree$display_mapping$n_tips),3L)
  expect_equal(nrow(x$x$microfun_tree$display_mapping),2L)
  expect_setequal(x$x$microfun_tree$clade_membership$tip,c("a1","a2","b"))
  expect_false(grepl("Taxa (Genus)",x$x$svg,fixed=TRUE))
  expect_false(grepl("Saved differential",x$x$svg,fixed=TRUE))
  y <- redraw_sankey(x,tree_options=list(collapse_clades=FALSE,aggregate_links=FALSE))
  expect_equal(nrow(y$x$microfun_ribbons),4L)
  expect_identical(x$x$microfun_tree$trees,y$x$microfun_tree$trees)
  expect_identical(x$x$microfun_tree$order,y$x$microfun_tree$order)
})

test_that("letter labels remain unique and support supplied mappings", {
  expect_equal(vapply(c(1,26,27,52,53,702),.microfun_letter_code,character(1)),
               c("A","Z","AA","AZ","BA","ZZ"))
  tx <- data.frame(taxon_id=c("Long_genus_A","Long_genus_B"),Phylum=c("P1","P2"))
  ft <- data.frame(function_id=c("F1","F2"),function_group=c("Group1","Group2"))
  ll <- expand.grid(taxon=tx$taxon_id,function_id=ft$function_id,stringsAsFactors=FALSE)
  ll$contribution <- c(20,.01,10,.01);ll$effect <- c(.5,-.2,.5,-.2)
  ll$edge_direction <- ifelse(ll$effect>0,"Up","Down")
  x <- structure(list(tax_table=tx,function_table=ft,links=ll,settings=list(graphical=list())),class="microfun_chord")
  f <- tempfile(fileext=".pdf");grDevices::pdf(f,width=13,height=11)
  on.exit({grDevices::dev.off();unlink(f)},add=TRUE)
  a <- .draw_tax2fun_chord(x,narrow_labels="letters",show_legend=FALSE)
  expect_true(all(a$label_mapping$abbreviated))
  expect_false(anyDuplicated(a$label_mapping$code)>0)
  expect_equal(a$links$contribution,x$links$contribution)
  b <- .draw_tax2fun_chord(x,narrow_labels="letters",label_codes=a$label_codes,show_legend=FALSE)
  expect_identical(a$label_codes,b$label_codes)
  expect_error(.draw_tax2fun_chord(x,label_codes=c(a="A",b="A")),"unique")
  c <- .draw_tax2fun_chord(x,narrow_labels="letters",legend_min_cex=1.5)
  expect_true(length(c$legend_pages)>0)
  .microfun_chord_legend_pages(c$legend_pages)
})

test_that("narrow sectors keep clickable identities without static callouts", {
  tx <- data.frame(taxon_id = c("Wide genus", "Rare & <genus>", "Other rare genus"),
                   Phylum = "Shared phylum")
  ft <- data.frame(function_id = "K00001", function_group = "Metabolism")
  links <- data.frame(taxon = tx$taxon_id, function_id = "K00001",
                      contribution = c(100, 0.02, 0.03), effect = c(1, -1, 1),
                      edge_direction = c("Up", "Down", "Up"))
  x <- structure(list(tax_table = tx, function_table = ft, links = links,
    settings = list(graphical = list(), taxon_level = "Genus", function_level = "KO",
                    contrast = c("STS", "LTS"), effect_type = "AST")),
    class = "microfun_chord")
  codes <- c("Taxa|terminal|Rare & <genus>" = "IA", "Taxa|terminal|Other rare genus" = "IB")
  grDevices::pdf(tempfile(fileext = ".pdf"), width = 13, height = 11)
  drawn <- tryCatch(.draw_tax2fun_chord(x, label_codes = codes), finally = grDevices::dev.off())
  m <- drawn$label_mapping
  tiny <- m$code %in% c("IA", "IB")
  expect_equal(sum(tiny), 2L)
  expect_true(all(!m$visible[tiny] & !m$leader[tiny] & m$display_label[tiny] == ""))
  expect_false(any(grepl("^(IA|IB) - ", unlist(lapply(drawn$legend_pages, `[[`, "legend")))))
  expect_equal(drawn$links, x$links)

  output <- tempfile(fileext = ".html")
  on.exit(unlink(c(output, sub("[.]html$", "_label_mapping.csv", output))), add = TRUE)
  save_chord(x, output, label_codes = codes)
  html <- paste(readLines(output, encoding = "UTF-8"), collapse = "\n")
  expect_match(html, 'data-name="Rare &amp; &lt;genus&gt;"', fixed = TRUE)
  expect_match(html, '<span class="code">IA</span>', fixed = TRUE)
  json <- sub('(?s)^.*<script type="application/json" id="sector-geometry">(.*?)</script>.*$',
              "\\1", html, perl = TRUE)
  sectors <- jsonlite::fromJSON(json, simplifyVector = FALSE)
  mapping <- utils::read.csv(sub("[.]html$", "_label_mapping.csv", output))
  i <- match(c("IA", "IB"), mapping$code)
  expect_false(anyNA(i))
  expect_false(identical(sectors[[i[1]]]$path, sectors[[i[2]]]$path))
  expect_true(all(vapply(sectors, function(s) all(is.finite(unlist(s$center))), logical(1))))
})
