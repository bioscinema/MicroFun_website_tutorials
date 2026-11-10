# Safely Extract Elements from a List

Safely extracts elements from a list, returning NA if the extraction
fails

## Usage

``` r
safe_extract(list, field, index = 1)
```

## Arguments

- list:

  A list object from which to extract elements

- field:

  The name of the field to extract from the list

- index:

  The index position to extract from the field. Default is 1

## Value

The extracted element if successful, NA if extraction fails

## Examples

``` r
# Create a sample list
my_list <- list(
  a = list(x = 1:3),
  b = list(y = 4:6)
)

# Extract existing element
safe_extract(my_list, "a", 1)

# Extract non-existing element (returns NA)
safe_extract(my_list, "c", 1)
```
