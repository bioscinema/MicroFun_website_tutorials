# Pathway information annotation

This function serves two main purposes: 1. Annotating pathway
information from PICRUSt2 output files. 2. Annotating pathway
information from the output of \`pathway_daa\` function, and converting
KO abundance to KEGG pathway abundance when \`ko_to_kegg\` is set to
TRUE.

## Usage

``` r
pathway_annotation(
  file = NULL,
  pathway = NULL,
  daa_results_df = NULL,
  ko_to_kegg = FALSE,
  organism = NULL,
  threshold = 0.05
)
```

## Arguments

- file:

  A character string, the path to the PICRUSt2 output file.

- pathway:

  A character string, the type of pathway to annotate. Options are "KO",
  "EC", or "MetaCyc".

- daa_results_df:

  A data frame, the output from \`pathway_daa\` function.

- ko_to_kegg:

  A logical, decide if convert KO abundance to KEGG pathway abundance.
  Default is FALSE. Set to TRUE when using the function for the second
  use case.

- organism:

  A character string specifying the KEGG organism code (e.g., 'hsa' for
  human, 'eco' for E. coli). Default is NULL, which retrieves generic KO
  information not specific to any organism. Only used when ko_to_kegg is
  TRUE.

- threshold:

  numeric. Adjusted p-value (or score) cutoff used to retain, default is
  0.05

## Value

A data frame with annotated pathway information. If using the function
for the first use case, the output data frame will include the following
columns:

- `id`: The pathway ID.

- `description`: The description of the pathway.

- `sample1, sample2, ...`: Abundance values for each sample.

If `ko_to_kegg` is set to TRUE, the output data frame will also include
the following columns:

- `pathway_name`: The name of the KEGG pathway.

- `pathway_description`: The description of the KEGG pathway.

- `pathway_class`: The class of the KEGG pathway.

- `pathway_map`: The KEGG pathway map ID.

When `ko_to_kegg` is TRUE, the function queries the KEGG database for
pathway information. By default (organism = NULL), it retrieves generic
KO information that is not specific to any organism. If you are
interested in organism-specific pathway information, you can specify the
KEGG organism code using the `organism` parameter.

## Examples

``` r
if (FALSE) { # \dontrun{
# Example 1: Annotate pathways from PICRUSt2 output file
pathway_annotation(file = "path/to/picrust2_output.tsv",
                              pathway = "KO")

# Example 2: Annotate pathways from pathway_daa output
# and converting KO abundance to KEGG pathway abundance
daa_results <- pathway_daa(abundance, metadata, group = "Group")
annotated_results <- pathway_annotation(pathway = "KO",
                              daa_results_df = daa_results,
                              ko_to_kegg = TRUE)

# Example 3: Annotate EC pathways
ec_results <- pathway_daa(abundance, metadata, group = "Group")
annotated_ec <- pathway_annotation(pathway = "EC",
                              daa_results_df = ec_results,
                              ko_to_kegg = TRUE)

# Example 4: Annotate KO pathways with human-specific information
daa_results <- pathway_daa(abundance, metadata, group = "Group")
human_results <- pathway_annotation(pathway = "KO",
                              daa_results_df = daa_results,
                              ko_to_kegg = TRUE,
                              organism = "hsa")
} # }
```
