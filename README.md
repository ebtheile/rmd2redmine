# Convert RMarkdown  to Redmine (Textile) format

This script aims to near-automate Redmine updates.


## How to use:

```bash
$ ./rmd2redmine.sh <RMarkdown file>
```

Upon invocation, the script knits the RMarkdown file to html, converts the figures from pdf to png and finally combines the html and figures to create a `.redmine` output file.

Copy the contents of the `.redmine` file straight into your Redmine update, upload the automatically generated png figures and you're done.

### Working with figures

Adhere to the following steps to ensure figures are handled correctly.

1. The RMarkdown file and rmd2redmine.sh are in the same directory
1. Your script saves figures in `./pdfs/`
1. Figures follow the naming convention `[name of script][counter].pdf`, e.g., my_analysis_01.pdf, but you may add a description before the counter
1. The output of the RMarkdown file is an html document


## Demonstration

The demonstration folder contains an example RMarkdown file and the output produced by `rmd2redmine.sh`.
