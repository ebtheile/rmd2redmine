# Convert RMarkdown  to Redmine (Textile) format

This script aims to near-automate Redmine updates.


## How to use:

Navigate to the directory containing the RMarkdown file to convert. Make sure rmd2redmine.sh is in the same directory. Then use the system terminal to execute:

```bash
$ ./rmd2redmine.sh -f <RMarkdown file>
```

If you're using a custom library (e.g. by using renv in a project), specify the path with the `-l` flag. In R, use `.libPaths()` to find the location of your library.

```bash
$ ./rmd2redmine.sh -l </library/path> -f <RMarkdown file>
```

Upon invocation, the script knits the RMarkdown file to html, extracts the figures and saves them as png files, and finally combines it all to a `.redmine` output file.

Copy the contents of the `.redmine` file straight into your Redmine update, upload the automatically generated png figures and you're done.


### Working with figures

Figures are handled automatically. You don't even need to save them manually.


## Demonstration

The demonstration folder contains an example RMarkdown file and the output produced by `rmd2redmine.sh`.


## TODO

- Fix inline links not being converted
