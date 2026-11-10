# Import Differential Abundance Analysis (DAA) results from MicrobiomeAnalyst

This function imports DAA results from an external platform such as
MicrobiomeAnalyst. It can be used to compare the results obtained from
different platforms.

## Arguments

- file_path:

  a character string specifying the path to the CSV file containing the
  DAA results from MicrobiomeAnalyst. If this parameter is NULL and no
  data frame is provided, an error will be thrown. Default is NULL.

- data:

  a data frame containing the DAA results from MicrobiomeAnalyst. If
  this parameter is NULL and no file path is provided, an error will be
  thrown. Default is NULL.

- method:

  a character string specifying the method used for the DAA. This will
  be added as a new column in the returned data frame. Default is
  "MicrobiomeAnalyst".

- group_levels:

  a character vector specifying the group levels for the DAA. This will
  be added as new columns in the returned data frame. Default is
  c("control", "treatment").

## Value

a data frame containing the DAA results from MicrobiomeAnalyst with
additional columns for the method and group levels.

## Examples

``` r
if (FALSE) { # \dontrun{
# Assuming you have a CSV file named "DAA_results.csv" in your current directory
daa_results <- import_MicrobiomeAnalyst_daa_results(file_path = "DAA_results.csv")
} # }
```
