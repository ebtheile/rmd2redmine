# Convert RMarkdown  to Redmine (Textile) format

This script aims to near-automate Redmine updates.


## How to use:

Navigate to the directory containing the RMarkdown file to convert. Then use the system terminal to execute:

```bash
$ ./rmd2redmine.sh <RMarkdown file>
```

Upon invocation, the script knits the RMarkdown file to html, converts the figures from pdf to png and finally combines the html and figures to create a `.redmine` output file.

Copy the contents of the `.redmine` file straight into your Redmine update, upload the automatically generated png figures and you're done.

### Working with figures

In the most recent version of this script, figures are handled automatically. You don't even need to save them manually.

## Demonstration

The demonstration folder contains an example RMarkdown file and the output produced by `rmd2redmine.sh`.
