test_that("function annotations reconcile missing and formatting differences", {
  x <- data.frame(function_id = c("F1", "F1", "F1", "F2"),
    function_group = c(NA, " metabolism ; Carbohydrate metabolism ", "Metabolism", ""))
  z <- MicroFun:::.chord_function_groups(x)
  expect_equal(z$function_group[z$function_id == "F1"], "Metabolism")
  expect_equal(z$function_group[z$function_id == "F2"], "Unclassified function")
  expect_identical(z, MicroFun:::.chord_function_groups(x[nrow(x):1, ]))
})
test_that("genuine conflicts are retained as auditable ambiguous annotations", {
  x <- data.frame(function_id = c("F1", "F1"),
                  function_group = c("Metabolism", "Human Diseases"))
  z <- MicroFun:::.chord_function_groups(x)
  expect_equal(z$function_group, "Ambiguous annotation")
  expect_equal(z$annotation_status, "conflicting")
  expect_match(z$observed_groups, "Human Diseases")
  expect_match(z$observed_groups, "Metabolism")
})
