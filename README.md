**THIS BRANCH WORKS WITH HTML INSTEAD OF RMD FILES AS INPUT**

# Convert HTML to Redmine (Textile) format

This script aims to near-automate Redmine updates.


## How to use:

Navigate to the directory containing the RMarkdown file to convert. Make sure rmd2redmine.sh is in the same directory. Then use the system terminal to execute:

```bash
$ ./rmd2redmine.sh -f <HTML file>
```

Upon invocation, the script extracts the figures, saves them as png files and finally combines it all to a `.redmine` output file.

Copy the contents of the `.redmine` file straight into your Redmine update, upload the automatically generated png figures and you're done.


### Working with figures

Figures are handled automatically. You don't even need to save them manually.


## Demonstration

Relates to the main branch.


## TODO

- Fix inline links not being converted
