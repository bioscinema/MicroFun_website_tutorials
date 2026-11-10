testthat::test_that("palettes assign consistent function categories", {
  testthat::expect_identical(microfun_palette("taxa"), c("#B5C3D7", "#B6C9C0", "#F5D8B7", "#F1D0C6", "#DDAEAB", "#D0E0EF", "#E9CDDF", "#C8BFD9", "#E4E3BF"))
  map <- MicroFun:::.microfun_category_colours
  cols <- map(c("Metabolism", "Human Diseases"), microfun_palette("function"), "function")
  testthat::expect_identical(unname(cols[c("Metabolism", "Human Diseases")]), c("#6E8FB2", "#ABC8E5"))
  fixed <- c(B = "#B5C3D7", A = "#B6C9C0")
  testthat::expect_identical(map("B", fixed), fixed["B"])
  testthat::expect_error(map("missing", fixed), "lacks categories")
})

testthat::test_that("Sankey node roles remain separate when labels are identical", {
  edges <- data.frame(source = "Shared", target = "Shared", value = 1)
  style <- MicroFun:::.microfun_sankey_style(edges, TRUE, microfun_palette("taxa"),
            microfun_palette("function"), NULL, c(Up = "#ffa551", Down = "#70afdf"))
  testthat::expect_equal(nrow(style$nodes), 2)
  testthat::expect_identical(style$edges$source_id, 0L)
  testthat::expect_identical(style$edges$target_id, 1L)
  testthat::expect_identical(style$nodes$colour, c("#B5C3D7", "#6E8FB2"))
})
