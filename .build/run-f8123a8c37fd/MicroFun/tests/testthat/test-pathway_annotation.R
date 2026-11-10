# Helper function to suppress all messages and warnings during tests
quiet_run <- function(expr) {
  suppressMessages(suppressWarnings(expr))
}

test_that("pathway_annotation basic functionality works", {
  # Setup test data
  temp_file <- tempfile(fileext = ".tsv")
  test_data <- data.frame(
    feature = c("K00001", "K00002"),
    sample1 = c(1, 2),
    sample2 = c(3, 4)
  )
  quiet_run(write.table(test_data, temp_file, sep = "\t", row.names = FALSE))

  result_ko <- quiet_run(
    pathway_annotation(
      file = temp_file,
      pathway = "KO",
      daa_results_df = NULL,
      ko_to_kegg = FALSE
    )
  )

  expect_s3_class(result_ko, "data.frame")
  expect_true("description" %in% colnames(result_ko))
  expect_equal(nrow(result_ko), 2)

  unlink(temp_file)
})

test_that("pathway_annotation handles invalid inputs correctly", {
  # Test missing both required inputs
  expect_error(
    pathway_annotation(),
    "Please input the picrust2 output or results of pathway_daa daa_results_df"
  )

  # Test invalid pathway type
  temp_file <- tempfile(fileext = ".tsv")
  test_data <- data.frame(
    feature = c("K00001", "K00002"),
    sample1 = c(1, 2),
    sample2 = c(3, 4)
  )
  quiet_run(write.table(test_data, temp_file, sep = "\t", row.names = FALSE))

  expect_error(
    pathway_annotation(file = temp_file, pathway = "INVALID"),
    "Invalid pathway option. Please provide one of the following options: 'KO', 'EC', 'MetaCyc'"
  )

  unlink(temp_file)
})

test_that("pathway_annotation works with daa_results_df input", {
  # Create mock daa_results_df
  test_daa_df <- data.frame(
    feature = c("K00001", "K00002"),
    p_adjust = c(0.04, 0.03),
    stringsAsFactors = FALSE
  )

  result_daa <- quiet_run(
    pathway_annotation(
      file = NULL,
      pathway = "KO",
      daa_results_df = test_daa_df,
      ko_to_kegg = FALSE
    )
  )

  expect_s3_class(result_daa, "data.frame")
  expect_true("description" %in% colnames(result_daa))
  expect_equal(nrow(result_daa), 2)
})

test_that("pathway_annotation handles different file formats", {
  formats <- c(".tsv", ".txt", ".csv")

  for(fmt in formats) {
    temp_file <- tempfile(fileext = fmt)
    test_data <- data.frame(
      feature = c("K00001", "K00002"),
      sample1 = c(1, 2),
      sample2 = c(3, 4)
    )

    # Use the delimiter appropriate to the file format.
    delimiter <- if(fmt == ".csv") "," else "\t"
    quiet_run(
      write.table(
        test_data,
        temp_file,
        sep = delimiter,
        row.names = FALSE,
        quote = FALSE
      )
    )

    result <- quiet_run(
      pathway_annotation(
        file = temp_file,
        pathway = "KO",
        daa_results_df = NULL,
        ko_to_kegg = FALSE
      )
    )

    expect_s3_class(result, "data.frame")
    unlink(temp_file)
  }
})

test_that("ko_to_kegg functionality works", {
  skip_if_offline()

  # Create mock daa_results_df with significant results
  test_daa_df <- data.frame(
    feature = c("K00001", "K00002"),
    p_adjust = c(0.04, 0.03),
    stringsAsFactors = FALSE
  )

  result_kegg <- quiet_run(
    pathway_annotation(
      file = NULL,
      pathway = "KO",
      daa_results_df = test_daa_df,
      ko_to_kegg = TRUE
    )
  )

  # Check KEGG specific columns exist
  expect_true(all(c(
    "pathway_name",
    "pathway_description",
    "pathway_class",
    "pathway_map"
  ) %in% colnames(result_kegg)))

  # Check that the result is a data frame
  expect_s3_class(result_kegg, "data.frame")

  # Check that we have the same number of rows as significant results
  expect_equal(nrow(result_kegg), nrow(test_daa_df))
})

test_that("pathway_annotation handles no significant results correctly", {
  # Create mock daa_results_df with no significant results
  test_daa_df <- data.frame(
    feature = c("K00001", "K00002"),
    p_adjust = c(0.06, 0.07),
    stringsAsFactors = FALSE
  )

  expect_error(
    pathway_annotation(
      file = NULL,
      pathway = "KO",
      daa_results_df = test_daa_df,
      ko_to_kegg = TRUE
    ),
    "No statistically significant biomarkers found"
  )
})

test_that("pathway_annotation handles empty data frames correctly", {
  empty_df <- data.frame(
    feature = character(0),
    p_adjust = numeric(0),
    stringsAsFactors = FALSE
  )

  expect_error(
    quiet_run(
      pathway_annotation(
        file = NULL,
        pathway = "KO",
        daa_results_df = empty_df,
        ko_to_kegg = FALSE
      )
    ),
    "Input data frame is empty"
  )
})

test_that("pathway_annotation handles malformed input files", {
  # Test file with missing columns
  temp_file <- tempfile(fileext = ".tsv")
  bad_data <- data.frame(feature = c("K00001", "K00002"))
  quiet_run(write.table(bad_data, temp_file, sep = "\t", row.names = FALSE))

  expect_error(
    quiet_run(
      pathway_annotation(
        file = temp_file,
        pathway = "KO"
      )
    ),
    "Input file must contain at least two columns"
  )

  unlink(temp_file)

  # Test non-existent file
  expect_error(
    quiet_run(
      pathway_annotation(
        file = "nonexistent.tsv",
        pathway = "KO"
      )
    ),
    "File does not exist"
  )
})

test_that("pathway_annotation works with all pathway types", {
  test_daa_df <- data.frame(
    feature = c("K00001", "EC:1.1.1.1", "PWY-7219"),
    p_adjust = c(0.04, 0.03, 0.02),
    stringsAsFactors = FALSE
  )

  # Test KO pathway
  ko_result <- quiet_run(
    pathway_annotation(
      file = NULL,
      pathway = "KO",
      daa_results_df = test_daa_df,
      ko_to_kegg = FALSE
    )
  )
  expect_s3_class(ko_result, "data.frame")
  expect_true("description" %in% colnames(ko_result))

  # Test EC pathway
  ec_result <- quiet_run(
    pathway_annotation(
      file = NULL,
      pathway = "EC",
      daa_results_df = test_daa_df,
      ko_to_kegg = FALSE
    )
  )
  expect_s3_class(ec_result, "data.frame")
  expect_true("description" %in% colnames(ec_result))

  # Test MetaCyc pathway
  metacyc_result <- quiet_run(
    pathway_annotation(
      file = NULL,
      pathway = "MetaCyc",
      daa_results_df = test_daa_df,
      ko_to_kegg = FALSE
    )
  )
  expect_s3_class(metacyc_result, "data.frame")
  expect_true("description" %in% colnames(metacyc_result))
})

test_that("pathway_annotation preserves input data structure", {
  # Test with additional columns in input
  test_data <- data.frame(
    feature = c("K00001", "K00002"),
    p_adjust = c(0.04, 0.03),
    log2fc = c(1.5, -2.0),
    extra_col = c("A", "B"),
    stringsAsFactors = FALSE
  )

  result <- quiet_run(
    pathway_annotation(
      file = NULL,
      pathway = "KO",
      daa_results_df = test_data,
      ko_to_kegg = FALSE
    )
  )

  expect_true(all(c("log2fc", "extra_col") %in% colnames(result)))
  expect_equal(nrow(result), nrow(test_data))
})

test_that("pathway_annotation handles special characters in input", {
  # Test with special characters in feature IDs
  temp_file <- tempfile(fileext = ".tsv")
  test_data <- data.frame(
    feature = c("K00001-special", "K00002_test"),
    sample1 = c(1, 2),
    sample2 = c(3, 4)
  )
  quiet_run(write.table(test_data, temp_file, sep = "\t", row.names = FALSE))

  result <- quiet_run(
    pathway_annotation(
      file = temp_file,
      pathway = "KO",
      daa_results_df = NULL,
      ko_to_kegg = FALSE
    )
  )

  expect_s3_class(result, "data.frame")
  unlink(temp_file)
})

test_that("pathway_annotation handles KEGG query failures gracefully", {
  skip_if_offline()

  # Use invalid KO IDs.
  test_daa_df <- data.frame(
    feature = c("K99999", "K88888"),
    p_adjust = c(0.04, 0.03),
    stringsAsFactors = FALSE
  )

  # Expect NULL or a warning.
  expect_warning(
    result <- pathway_annotation(
      file = NULL,
      pathway = "KO",
      daa_results_df = test_daa_df,
      ko_to_kegg = TRUE
    ),
    "No valid KEGG annotations found for any features"
  )

  # A NULL result satisfies this check.
  expect_true(is.null(result))
})

test_that("pathway_annotation handles large datasets efficiently", {
  testthat::skip_if_not(identical(Sys.getenv("TEST_SLOW"), "true"),
                        "Skipping slow tests")

  # Create large test dataset
  large_data <- data.frame(
    feature = paste0("K", sprintf("%05d", 1:1000)),
    p_adjust = runif(1000, 0, 0.1),
    stringsAsFactors = FALSE
  )

  # Measure execution time
  start_time <- Sys.time()
  result <- quiet_run(
    pathway_annotation(
      file = NULL,
      pathway = "KO",
      daa_results_df = large_data,
      ko_to_kegg = FALSE
    )
  )
  end_time <- Sys.time()

  # Test should complete within reasonable time (e.g., 30 seconds)
  expect_true(as.numeric(end_time - start_time, units = "secs") < 30)
  expect_equal(nrow(result), nrow(large_data))
})

# Test the cache.
test_that("KEGG cache system works correctly", {
  skip_if_offline()

  # Clear the existing cache.
  rm(list = ls(envir = kegg_cache), envir = kegg_cache)

  test_ko <- "K00001"

  # The first query should access KEGG.
  start_time <- Sys.time()
  result1 <- quiet_run(get_kegg_with_cache(test_ko))
  first_query_time <- as.numeric(Sys.time() - start_time, units = "secs")

  # The second query should use the cache.
  start_time <- Sys.time()
  result2 <- quiet_run(get_kegg_with_cache(test_ko))
  second_query_time <- as.numeric(Sys.time() - start_time, units = "secs")

  # Check result consistency.
  expect_equal(result1, result2)
  # Check that the cached query is faster.
  expect_true(second_query_time < first_query_time)
  # Check that data were cached.
  expect_true(exists(test_ko, envir = kegg_cache))
})

# Test retry handling.
test_that("retry mechanism works correctly", {
  # Create a counter in the test environment.
  test_env <- new.env()
  test_env$attempt_count <- 0

  # Create the test function.
  test_fun <- function() {
    test_env$attempt_count <- test_env$attempt_count + 1
    if (test_env$attempt_count < 2) {
      stop("Simulated failure")
    }
    "success"
  }

  # Test a successful retry.
  result <- quiet_run(with_retry(test_fun()))
  expect_equal(result, "success")
  expect_equal(test_env$attempt_count, 2)

  # Test the maximum retry limit.
  test_env$attempt_count <- 0
  always_fails <- function() {
    test_env$attempt_count <- test_env$attempt_count + 1
    stop("Always fails")
  }

  # Test NULL after the maximum number of retries.
  result <- quiet_run(with_retry(always_fails(), max_attempts = 2))
  expect_null(result)
  expect_equal(test_env$attempt_count, 2)
})

# Test logging.
test_that("logging system works correctly", {
  # Test different log levels.
  expect_message(
    log_message("Test info message", "INFO"),
    "INFO: Test info message"
  )

  expect_message(
    log_message("Test warning message", "WARN"),
    "WARN: Test warning message"
  )

  # Test disabled logging.
  old_verbose <- options(ggpicrust2.verbose = FALSE)
  expect_no_message(log_message("This should not appear"))
  options(old_verbose)
})

# Test the progress bar.
test_that("progress bar works correctly", {
  pb <- create_progress_bar(100)
  expect_s3_class(pb, "progress_bar")
  expect_equal(pb$.__enclos_env__$private$total, 100)

  # Test progress updates.
  expect_no_error(pb$tick())
  expect_no_error(pb$tick(tokens = list(what = "Testing")))
})

# Test input validation.
test_that("input validation works correctly", {
  # Test file-path validation.
  expect_error(
    validate_inputs(file = 123, pathway = "KO", NULL, FALSE),
    "'file' must be a single character string"
  )

  # Test pathway-type validation.
  expect_error(
    validate_inputs(file = "test.txt", pathway = "invalid", NULL, FALSE),
    "must be one of: KO, EC, MetaCyc"
  )

  # Test data-frame validation.
  invalid_df <- list(a = 1)
  expect_error(
    validate_inputs(NULL, "KO", invalid_df, TRUE),
    "'daa_results_df' must be a data frame"
  )
})

# Test configuration.
test_that("configuration system works correctly", {
  # Save the original settings.
  old_options <- options()

  # Test defaults.
  expect_true(getOption("ggpicrust2.cache_enabled", TRUE))
  expect_equal(getOption("ggpicrust2.max_retries", 3), 3)

  # Test custom settings.
  options(ggpicrust2.max_retries = 5)
  expect_equal(getOption("ggpicrust2.max_retries"), 5)

  # Restore the original settings.
  options(old_options)
})

# Test KEGG annotation processing.
test_that("KEGG annotation processing works correctly", {
  skip_if_offline()

  # Test valid data.
  valid_df <- data.frame(
    feature = c("K00001", "K00002"),
    p_adjust = c(0.01, 0.02)
  )

  result <- quiet_run(process_kegg_annotations(valid_df))
  expect_true(all(c(
    "pathway_name",
    "pathway_description",
    "pathway_class",
    "pathway_map"
  ) %in% colnames(result)))

  # Test no significant results.
  nonsig_df <- data.frame(
    feature = "K00001",
    p_adjust = 0.06
  )
  expect_error(
    process_kegg_annotations(nonsig_df),
    "No statistically significant biomarkers found"
  )

  # Test an empty data frame.
  empty_df <- data.frame(
    feature = character(0),
    p_adjust = numeric(0)
  )
  expect_error(
    process_kegg_annotations(empty_df),
    "Empty data frame provided for KEGG annotation"
  )
})

# Test processing a large dataset.
test_that("large dataset processing works efficiently", {
  skip_if_not(identical(Sys.getenv("TEST_SLOW"), "true"),
              "Skipping slow tests")

  # Create a large dataset.
  n_rows <- 100
  large_df <- data.frame(
    feature = paste0("K", sprintf("%05d", 1:n_rows)),
    p_adjust = runif(n_rows, 0, 0.04)  # Include significant results.
  )

  # Measure processing time.
  start_time <- Sys.time()
  result <- quiet_run(process_kegg_annotations(large_df))
  end_time <- Sys.time()

  # Require a reasonable processing time, such as at most one second per entry on average.
  processing_time <- as.numeric(end_time - start_time, units = "secs")
  expect_true(processing_time/n_rows < 1)

  # Check result completeness.
  expect_equal(nrow(result), nrow(large_df))
  expect_true(all(c(
    "pathway_name",
    "pathway_description",
    "pathway_class",
    "pathway_map"
  ) %in% colnames(result)))
})
