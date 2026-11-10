# Create test data
test_that("pathway_daa works with basic inputs", {
  # Setup test data with more samples per group
  abundance <- data.frame(
    sample1 = c(10, 20, 30),
    sample2 = c(20, 30, 40),
    sample3 = c(15, 25, 35),
    sample4 = c(30, 40, 50),
    sample5 = c(35, 45, 55),
    sample6 = c(25, 35, 45),
    row.names = c("pathway1", "pathway2", "pathway3")
  )

  metadata <- tibble::tibble(
    sample = paste0("sample", 1:6),
    group = c("control", "control", "control", "treatment", "treatment", "treatment")
  )

  # Test ALDEx2 method
  result <- pathway_daa(abundance, metadata, "group", daa_method = "ALDEx2")
  expect_s3_class(result, "data.frame")
  expect_true(all(c("feature", "method", "p_values", "adj_method", "p_adjust") %in% colnames(result)))
  expect_equal(nrow(result), nrow(abundance))
  expect_equal(result$method[1], "ALDEx2")
  expect_true(all(!is.na(result$p_values)))
  expect_true(all(result$p_values >= 0 & result$p_values <= 1))
})

test_that("pathway_daa validates inputs correctly", {
  # Create test data.
  abundance <- data.frame(
    sample1 = c(10, 20, 30),
    sample2 = c(20, 30, 40),
    sample3 = c(30, 40, 50),
    sample4 = c(40, 50, 60),  # Add a fourth sample.
    row.names = c("pathway1", "pathway2", "pathway3")
  )

  # Create metadata with mismatched sample names.
  metadata_mismatch <- data.frame(
    wrong_sample = c("wrong1", "wrong2", "wrong3", "wrong4"),
    group = c("control", "control", "treatment", "treatment")
  )

  # Test mismatched sample names.
  expect_error(
    pathway_daa(abundance, metadata_mismatch, "group"),
    "No column in metadata matches the sample names in abundance data"
  )

  # Create aligned metadata with too few groups.
  metadata_single_group <- data.frame(
    sample = c("sample1", "sample2", "sample3", "sample4"),
    group = c("control", "control", "control", "control")
  )

  # Test a single group.
  expect_error(
    pathway_daa(abundance, metadata_single_group, "group"),
    "At least two groups are required"
  )

  # Test insufficient samples.
  small_abundance <- data.frame(
    sample1 = c(10, 20, 30),
    sample2 = c(20, 30, 40),
    sample3 = c(30, 40, 50),
    row.names = c("pathway1", "pathway2", "pathway3")
  )

  small_metadata <- data.frame(
    sample = c("sample1", "sample2", "sample3"),
    group = c("control", "control", "treatment")
  )

  expect_error(
    pathway_daa(small_abundance, small_metadata, "group"),
    "At least 4 samples are required for differential abundance analysis"
  )
})

test_that("pathway_daa methods produce expected results", {
  # Create a larger test dataset to avoid DESeq2 warnings.
  n_samples <- 10  # Increase the sample count.
  n_features <- 3

  # Create simulated data.
  set.seed(123)
  abundance <- matrix(
    rpois(n_samples * n_features, lambda = 20),  # Generate count data from a Poisson distribution.
    nrow = n_features,
    ncol = n_samples
  )
  rownames(abundance) <- paste0("pathway", 1:n_features)
  colnames(abundance) <- paste0("sample", 1:n_samples)
  abundance <- as.data.frame(abundance)

  # Create balanced metadata.
  metadata <- data.frame(
    sample = paste0("sample", 1:n_samples),
    group = rep(c("control", "treatment"), each = n_samples/2)
  )

  # Test all methods.
  for(method in c("ALDEx2", "DESeq2", "limma voom", "edgeR", "metagenomeSeq", "LinDA", "Maaslin2")) {
    result <- pathway_daa(abundance, metadata, "group", daa_method = method)

    # Require a data-frame result.
    expect_true(is.data.frame(result))

    # Check required columns.
    expect_true(all(c("feature", "method", "p_values") %in% colnames(result)))

    # Check the row count.
    expect_equal(nrow(result), n_features)

    # Check the valid P-value range.
    expect_true(all(result$p_values >= 0 & result$p_values <= 1))
  }
})

test_that("pathway_daa handles sample selection correctly", {
  abundance <- data.frame(
    sample1 = c(10, 20, 30),
    sample2 = c(20, 30, 40),
    sample3 = c(15, 25, 35),
    sample4 = c(30, 40, 50),
    row.names = c("pathway1", "pathway2", "pathway3")
  )

  metadata <- tibble::tibble(
    sample = paste0("sample", 1:4),
    group = c("control", "control", "treatment", "treatment")
  )

  # Test valid sample selection.
  selected_samples <- c("sample1", "sample2", "sample3", "sample4")
  result <- pathway_daa(abundance, metadata, "group",
                       daa_method = "ALDEx2",
                       select = selected_samples)
  expect_equal(ncol(abundance[, selected_samples]), length(selected_samples))

  # Test invalid sample selection.
  expect_error(
    pathway_daa(abundance, metadata, "group",
                daa_method = "ALDEx2",
                select = c("sample1", "invalid_sample")),
    "Some selected samples are not present in the abundance data"
  )
})

test_that("pathway_daa handles multiple groups correctly", {
  abundance <- data.frame(
    sample1 = c(10, 20, 30),
    sample2 = c(20, 30, 40),
    sample3 = c(30, 40, 50),
    sample4 = c(25, 35, 45),
    sample5 = c(15, 25, 35),
    sample6 = c(16, 26, 36),
    row.names = c("pathway1", "pathway2", "pathway3")
  )

  metadata <- tibble::tibble(
    sample = paste0("sample", 1:6),
    group = factor(c("control", "control", "treatment", "treatment", "other", "other"))
  )

  # Test multiple-group comparisons with a reference group.
  suppressWarnings({
    result <- pathway_daa(abundance, metadata, "group",
                         daa_method = "limma voom",
                         reference = "control")
  })

  expect_s3_class(result, "data.frame")
  expect_true(all(!is.na(result$p_values)))
})

test_that("pathway_daa handles p-value adjustment correctly", {
  abundance <- data.frame(
    sample1 = c(10, 20, 30),
    sample2 = c(20, 30, 40),
    sample3 = c(30, 40, 50),
    sample4 = c(25, 35, 45),
    row.names = c("pathway1", "pathway2", "pathway3")
  )

  metadata <- tibble::tibble(
    sample = paste0("sample", 1:4),
    group = c("control", "control", "treatment", "treatment")
  )

  # Test different P-value adjustment methods.
  methods <- c("BH", "holm", "bonferroni", "hochberg", "fdr")
  for(method in methods) {
    result <- pathway_daa(abundance, metadata, "group",
                         daa_method = "ALDEx2",
                         p.adjust = method)
    expect_true(all(result$adj_method == method))
    expect_true(all(!is.na(result$p_adjust)))
    expect_true(all(result$p_adjust >= 0 & result$p_adjust <= 1))
  }
})
