# Export a chord diagram

Save a chord diagram and its label mapping. HTML includes zoom controls
and a searchable, clickable sector legend. PDF legends continue on
separate pages.

## Usage

``` r
save_chord(x, file = "microfun_chord.html", width = 18, height = 16,
  formats = NULL, ...)
```

## Arguments

- x:

  A microfun_chord object.

- file:

  Output path ending in pdf, png, svg, html or rds; defaults to
  microfun_chord.html.

- formats:

  Optional additional formats to save alongside the primary output:
  html, pdf, png, svg, rds.

- width,height:

  Figure dimensions in inches.

- ...:

  Graphical arguments passed to the chord renderer; see `tax2fun_chord`.

## Details

HTML uses a separate legend panel. Selecting an entry highlights its
sector, including sectors with hidden labels. Labels that do not fit are
omitted from the chart, and their aliases are omitted from static
legends. PNG and SVG write a companion legend PDF when necessary.
Rendered exports write a label mapping CSV. RDS stores the chord object
without rendering.

## Value

Invisibly, the normalized output path or named vector of paths for
multi-format export.

## See also

[`tax2fun_chord`](https://bioscinema.github.io/MicroFun_website_tutorials/reference/tax2fun_chord.md)
