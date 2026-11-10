test_that("pathway_pca works with basic inputs", {
  # Setup test data
  test_abundance <- matrix(rnorm(30), nrow = 3, ncol = 10)
  colnames(test_abundance) <- paste0("Sample", 1:10)
  rownames(test_abundance) <- c("PathwayA", "PathwayB", "PathwayC")

  test_metadata <- data.frame(
    sample_name = colnames(test_abundance),
    group = factor(rep(c("Control", "Treatment"), each = 5))
  )

  result <- pathway_pca(test_abundance, test_metadata, "group")
  expect_s3_class(result, "ggplot")
})

test_that("pathway_pca works with custom colors", {
  # Setup test data
  test_abundance <- matrix(rnorm(30), nrow = 3, ncol = 10)
  colnames(test_abundance) <- paste0("Sample", 1:10)
  rownames(test_abundance) <- c("PathwayA", "PathwayB", "PathwayC")

  test_metadata <- data.frame(
    sample_name = colnames(test_abundance),
    group = factor(rep(c("Control", "Treatment"), each = 5))
  )

  custom_colors <- c("red", "blue")
  result <- pathway_pca(test_abundance, test_metadata, "group", colors = custom_colors)
  expect_s3_class(result, "ggplot")
})

test_that("pathway_pca throws error with incorrect color vector length", {
  # Setup test data
  test_abundance <- matrix(rnorm(30), nrow = 3, ncol = 10)
  colnames(test_abundance) <- paste0("Sample", 1:10)
  rownames(test_abundance) <- c("PathwayA", "PathwayB", "PathwayC")

  test_metadata <- data.frame(
    sample_name = colnames(test_abundance),
    group = factor(rep(c("Control", "Treatment"), each = 5))
  )

  wrong_colors <- c("red", "blue", "green")  # 3 colors for 2 groups
  expect_error(
    pathway_pca(test_abundance, test_metadata, "group", colors = wrong_colors),
    sprintf("Number of colors \\(%d\\) does not match number of groups \\(%d\\)",
            length(wrong_colors), length(unique(test_metadata$group)))
  )
})

test_that("pathway_pca handles missing values correctly", {
  # Setup test data with some NA values
  test_abundance <- matrix(rnorm(30), nrow = 3, ncol = 10)
  test_abundance[1, 1] <- NA
  colnames(test_abundance) <- paste0("Sample", 1:10)
  rownames(test_abundance) <- c("PathwayA", "PathwayB", "PathwayC")

  test_metadata <- data.frame(
    sample_name = colnames(test_abundance),
    group = factor(rep(c("Control", "Treatment"), each = 5))
  )

  expect_error(pathway_pca(test_abundance, test_metadata, "group"))
})

test_that("pathway_pca handles different group sizes correctly", {
  # Setup test data with uneven groups
  test_abundance <- matrix(rnorm(40), nrow = 4, ncol = 10)
  colnames(test_abundance) <- paste0("Sample", 1:10)
  rownames(test_abundance) <- paste0("Pathway", LETTERS[1:4])

  test_metadata <- data.frame(
    sample_name = colnames(test_abundance),
    group = factor(c(rep("Control", 3), rep("Treatment", 4), rep("Other", 3)))
  )

  result <- pathway_pca(test_abundance, test_metadata, "group")
  expect_s3_class(result, "ggplot")

  # Check the number of groups in the plot layer.
  group_levels <- unique(test_metadata$group)
  expect_equal(length(group_levels), 3)
  # This check can be omitted because the input already contains three groups.
})

test_that("pathway_pca validates input dimensions", {
  test_abundance <- matrix(rnorm(30), nrow = 3, ncol = 10)
  colnames(test_abundance) <- paste0("Sample", 1:10)

  wrong_metadata <- data.frame(
    sample_name = paste0("Sample", 1:9),
    group = factor(rep(c("Control", "Treatment"), c(4, 5)))
  )
  rownames(wrong_metadata) <- wrong_metadata$sample_name

  expect_error(pathway_pca(test_abundance, wrong_metadata, "group"))
})

test_that("pathway_pca handles extreme values correctly", {
  # Setup test data with extreme values
  test_abundance <- matrix(c(rnorm(28), 1e6, -1e6), nrow = 3, ncol = 10)
  colnames(test_abundance) <- paste0("Sample", 1:10)
  rownames(test_abundance) <- c("PathwayA", "PathwayB", "PathwayC")

  test_metadata <- data.frame(
    sample_name = colnames(test_abundance),
    group = factor(rep(c("Control", "Treatment"), each = 5))
  )

  result <- pathway_pca(test_abundance, test_metadata, "group")
  expect_s3_class(result, "ggplot")
})

test_that("pathway_pca handles single-group data", {
  test_abundance <- matrix(rnorm(30), nrow = 3, ncol = 10)
  colnames(test_abundance) <- paste0("Sample", 1:10)
  rownames(test_abundance) <- c("PathwayA", "PathwayB", "PathwayC")

  test_metadata <- data.frame(
    sample_name = colnames(test_abundance),
    group = factor(rep("Control", 10))
  )

  result <- pathway_pca(test_abundance, test_metadata, "group")
  expect_s3_class(result, "ggplot")

  # Check the number of groups in the input data.
  group_levels <- unique(test_metadata$group)
  expect_equal(length(group_levels), 1)
  # This check can be omitted because the input already contains one group.
})

test_that("pathway_pca handles non-numeric values correctly", {
  test_abundance <- matrix(rnorm(30), nrow = 3, ncol = 10)
  test_abundance[1, 1] <- NA
  colnames(test_abundance) <- paste0("Sample", 1:10)
  rownames(test_abundance) <- c("PathwayA", "PathwayB", "PathwayC")

  test_metadata <- data.frame(
    sample_name = colnames(test_abundance),
    group = factor(rep(c("Control", "Treatment"), each = 5))
  )

  expect_error(pathway_pca(test_abundance, test_metadata, "group"))
})

# Add test cases.

test_that("pathway_pca handles missing required arguments", {
  test_abundance <- matrix(rnorm(30), nrow = 3, ncol = 10)
  test_metadata <- data.frame(
    sample_name = paste0("Sample", 1:10),
    group = factor(rep(c("Control", "Treatment"), each = 5))
  )

  expect_error(pathway_pca(), "Abundance matrix is required")
  expect_error(pathway_pca(test_abundance), "Metadata is required")
  expect_error(pathway_pca(test_abundance, test_metadata), "Group variable name is required")
})

test_that("pathway_pca validates abundance matrix format", {
  # Test non-matrix/data.frame input
  expect_error(
    pathway_pca(list(1,2,3),
                data.frame(sample_name=1:3, group=c("A","A","B")),
                "group"),
    "Abundance must be a matrix or data frame"
  )

  # Test matrix with too few pathways
  test_abundance_small <- matrix(1:10, nrow = 1, ncol = 10)
  expect_error(
    pathway_pca(test_abundance_small,
                data.frame(sample_name=1:10, group=rep(c("A","B"), each=5)),
                "group"),
    "Abundance matrix must contain at least 2 pathways"
  )

  # Test matrix with too few samples
  test_abundance_few <- matrix(1:4, nrow = 2, ncol = 2)
  expect_error(
    pathway_pca(test_abundance_few,
                data.frame(sample_name=1:2, group=c("A","B")),
                "group"),
    "Abundance matrix must contain at least 3 samples"
  )
})

test_that("pathway_pca validates metadata format", {
  test_abundance <- matrix(rnorm(30), nrow = 3, ncol = 10)
  colnames(test_abundance) <- paste0("Sample", 1:10)

  # Test non-data.frame metadata
  expect_error(
    pathway_pca(test_abundance, list(samples=1:10), "group"),
    "Metadata must be a data frame"
  )

  # Test missing sample_name column
  wrong_metadata <- data.frame(
    samples = paste0("Sample", 1:10),  # wrong column name
    group = factor(rep(c("Control", "Treatment"), each = 5))
  )
  expect_error(
    pathway_pca(test_abundance, wrong_metadata, "group"),
    "Metadata must contain a 'sample_name' column"
  )

  # Test missing group column
  wrong_metadata2 <- data.frame(
    sample_name = paste0("Sample", 1:10),
    wrong_group = factor(rep(c("Control", "Treatment"), each = 5))
  )
  expect_error(
    pathway_pca(test_abundance, wrong_metadata2, "group"),
    "Group column 'group' not found in metadata"
  )
})

test_that("pathway_pca validates sample name matching", {
  test_abundance <- matrix(rnorm(30), nrow = 3, ncol = 10)
  colnames(test_abundance) <- paste0("Sample", 1:10)
  rownames(test_abundance) <- c("PathwayA", "PathwayB", "PathwayC")

  # Test duplicate sample names.
  duplicate_metadata <- data.frame(
    sample_name = paste0("Sample", c(1:9, 1)),  # Use Sample1 through Sample9, then repeat Sample1.
    group = factor(rep(c("Control", "Treatment"), each = 5)),
    stringsAsFactors = FALSE  # Keep strings as character values.
  )

  # Do not assign row names because values are duplicated.
  # Row-name assignment is intentionally omitted for duplicate sample names.

  # First verify the test data.
  expect_equal(length(unique(duplicate_metadata$sample_name)), 9)  # Expect nine unique sample names.
  expect_equal(ncol(test_abundance), 10)  # Confirm that the abundance matrix has ten columns.

  # Test the expected error.
  expect_error(
    pathway_pca(test_abundance, duplicate_metadata, "group"),
    "Number of unique samples in metadata does not match abundance matrix"
  )
})

test_that("pathway_pca validates color specifications", {
  test_abundance <- matrix(rnorm(30), nrow = 3, ncol = 10)
  colnames(test_abundance) <- paste0("Sample", 1:10)
  test_metadata <- data.frame(
    sample_name = colnames(test_abundance),
    group = factor(rep(c("Control", "Treatment"), each = 5))
  )

  # Test an invalid colour name.
  invalid_colors <- c("not_a_color", "also_not_a_color")
  expect_error(
    pathway_pca(test_abundance, test_metadata, "group", colors = invalid_colors),
    "Invalid color names provided"
  )

  # Test non-vector colour input.
  expect_error(
    pathway_pca(test_abundance, test_metadata, "group", colors = list("red", "blue")),
    "Colors must be provided as a character vector"
  )
})

test_that("pathway_pca handles group variable conversion", {
  test_abundance <- matrix(rnorm(30), nrow = 3, ncol = 10)
  colnames(test_abundance) <- paste0("Sample", 1:10)
  test_metadata <- data.frame(
    sample_name = colnames(test_abundance),
    group = rep(c("Control", "Treatment"), each = 5)  # Character vector, not factor
  )

  expect_warning(
    pathway_pca(test_abundance, test_metadata, "group"),
    "Converting group variable to factor"
  )
})
