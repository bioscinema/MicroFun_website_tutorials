# Validation scope

- R 4.5.0 on Linux; plotting dependencies are listed in sessionInfo.txt.
- 23 focused test cases, 135 assertions: 0 failures, 0 errors, 0 skipped.
- Tests executed against the real package R source and bundled references.
  The temporary source harness removes MicroFun::/MicroFun::: qualification
  from test calls to invoke the directly loaded source functions. No plotting
  or statistical functions were mocked.
- Coverage: both Sankey tree orientations, rank inference and conflicts,
  ASV/tree mapping and weight conservation, Chord contribution weighting,
  function annotations, grouped/ungrouped boxplots, structural zeros,
  EC/MetaCyc reference schemas, and selected-sample limma coefficient alignment.
- All R source files parsed successfully; standard R CMD build succeeded.
- Representative PNG and rendered PDF pages were visually reviewed.
- A complete R CMD check/full installation with every differential-analysis
  backend was not run. Synthetic example effects/p-values are illustrative,
  not fitted analyses or claims about biological datasets.

HTML files were generated with their local assets. Automated browser interaction
checks could not run because the environment prevented Chromium from starting;
HTML hover/zoom/search behavior was not browser-verified in this run.
