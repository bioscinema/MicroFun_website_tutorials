# MicroFun categorical palettes

Returns the categorical palettes used by chord and Sankey plots. Effect
direction colours are controlled separately by each plotting function.

## Usage

``` r
microfun_palette(side = c("taxa", "function"))
```

## Arguments

- side:

  Taxa uses the light muted nine-colour palette; function uses the dark
  muted nine-colour palette.

## Value

A character vector of nine hexadecimal colours.

## Examples

``` r
microfun_palette("taxa")
```
