# Convert RMarkdown  to Redmine (Textile) format

This script aims to near-automate Redmine updates.

## How to use:

```bash
$ ./rmd2redmine.sh <file.Rmd>
```

Upon invocation, the script knits the RMarkdown file to html, converts the figures from pdf to png (make sure your script saves pdf figures to `./pdfs`) and finally combines the html and figures to create a `.redmine` output file.

Copy the contents of the `.redmine` file straight into your Redmine update, upload the automatically generated png figures and you're done.

## Demonstration

The demonstration folder contains an example RMarkdown file and the output produced by `rmd2redmine.sh`.
