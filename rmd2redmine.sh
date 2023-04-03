#! /usr/bin/bash


libPath="not_set"
rmdFile=""

while getopts ':l:f:' opt; do
  case $opt in
    l)
      libPath="$OPTARG"
      ;;
    f)
      rmdFile="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Error: -${OPTARG} requires an argument."
      exit 1
      ;;
  esac
done


echo 'Knitting document...'
if [ $libPath == "not_set" ]; then
  Rscript -e "rmarkdown::render(\"$rmdFile\", quiet = T)"
else
  export R_LIBS_USER="$libPath"
  Rscript -e "rmarkdown::render(\"$rmdFile\", quiet = T)"
fi




echo "fileNameRmd = commandArgs(trailingOnly = T)[1]

library(stringr)
library(xml2)
library(rvest)

reportName = str_remove(fileNameRmd, '\\\\.Rmd')
fileName = paste0(reportName, '.html')

# Set up helper functions
df_to_textile = function(x) {
  result = ''
  if(Negate(is.null)(colnames(x))){
    for(i in seq_len(ncol(x))){
      result = paste0(result, '|_.', colnames(x)[i], ' ')
    }
    result = paste0(result, ' |\\n')
  }
  for(i in seq_len(nrow(x))){
    result = paste0(result, '|')
    for(j in seq_len(ncol(x))){
      result = paste0(result, ' ', x[i, j], ' |')
    }
    result = paste0(result, '\\n')
  }
  return(result)
}
htmllist_to_textile = function(htmllist) {
  list_type = list(ifelse(xml_name(htmllist) == 'ul', '*', '#'))
  c = xml_children(htmllist)
  
  out = ''
  for (ci in c) {
    tmp = as.character(ci)
    tmp = str_remove_all(tmp, '<li>|</li>')
    out = paste(out, tmp, sep = '\\n')
  }
  tmp = str_split(out, '\\n')[[1]]
  tmp = tmp[tmp != '']
  
  out = vector('character', length(tmp))
  depth = 1
  for (t in seq_along(tmp)) {
    if (str_detect(tmp[t], '<ul>|<ol.*?>')) {
      depth = depth + 1
      list_type[[depth]] = ifelse(str_detect(tmp[t], '<ul>'), '*', '#')
    } else if (str_detect(tmp[t], '</ul>|</ol.*?>')) {
      depth = depth - 1
    } else {
      out[t] = paste(paste0(rep(list_type[[depth]], depth), collapse = ''), tmp[t])
    }
  }
  out = out[out != '']
  return(paste(out, collapse = '\\n'))
}

# Extract elements
doc = read_html(fileName)
elements = html_elements(doc, 'h1, h2, h3, h4, h5, h6, p, table, pre, ol, ul, hr')

# Remove elements on the wrong level, such as nested lists which are included
# in other lists
for (i in rev(seq_along(elements))) {
  if (html_name(xml_parent(elements[i])) != 'div') {
    elements = elements[-i]
  }
}

# Prepare redminecontent
redminecontent = vector('character', length(elements))

# Get element types
element_types = sapply(elements, html_name)

# If there are figures, replace the type in the right place
img_pos = which(html_name(xml_child(elements, 'img')) == 'img')
element_types[img_pos] = 'img'

# Get numbers of children
n_children = xml_length(elements)

# Loop through elements
figure_counter = 0
for (i in seq_along(elements)) {
  switch (element_types[i],
    'h1' = {redminecontent[i] = paste('h1.', html_text2(elements[i]))},
    'h2' = {redminecontent[i] = paste('h2.', html_text2(elements[i]))},
    'h3' = {redminecontent[i] = paste('h3.', html_text2(elements[i]))},
    'h4' = {redminecontent[i] = paste('h4.', html_text2(elements[i]))},
    'h5' = {redminecontent[i] = paste('h5.', html_text2(elements[i]))},
    'h6' = {redminecontent[i] = paste('h6.', html_text2(elements[i]))},
    'p' = {redminecontent[i] = html_text2(elements[i])},
    'img' = {
      if (Negate(dir.exists)('pngs')) {
        dir.create('pngs')
      }
      child = html_children(elements[i])
      src = str_split(html_attr(child, 'src'), ',')[[1]]
      pngName = paste0(reportName, '_', sprintf('%02d', figure_counter), '.png')
      outconn = file(paste0('pngs/', pngName),'wb')
      base64enc::base64decode(what = src[2], output = outconn)
      close(outconn)
      figure_counter = figure_counter + 1
      redminecontent[i] = paste0('!{width:', html_attr(html_children(elements[i]), 'width'), 'px}', pngName, '!')
    },
    'table' = {redminecontent[i] = df_to_textile(as.data.frame(html_table(elements[i])))},
    'pre' = {redminecontent[i] = as.character(elements[i])},
    'hr' = {redminecontent[i] = '---'},
    'ol' = {redminecontent[i] = htmllist_to_textile(elements[i])},
    'ul' = {redminecontent[i] = htmllist_to_textile(elements[i])}
  )
}

redminecontent = paste0(redminecontent, collapse = '\\n\\n')

#####

# Handle miscellaneous things
# redminecontent = str_replace_all(redminecontent, '&quot;', '\"')
# redminecontent = str_replace_all(redminecontent, '&#39;', \"'\")
redminecontent = str_replace_all(redminecontent, '<strong>|</strong>', '*')
redminecontent = str_replace_all(redminecontent, '<em>|</em>', '_')

# Handle links
linkMatches = gregexpr('<a href=\".+?\">.+?</a>', redminecontent)[[1]]
if (linkMatches[1] > -1) {
  for (l in rev(seq_along(linkMatches))) {
    s = substr(redminecontent, linkMatches[l], linkMatches[l] + attr(linkMatches, 'match.length')[l] - 1)
    s1 = str_extract(s, '\".+?\"')
    s1 = substr(s1, 2, str_length(s1) - 1)
    s2 = str_extract(s, '(?<=>).+?(?=<)')
    redminecontent = str_replace(redminecontent, substr(redminecontent, linkMatches[l], linkMatches[l] + attr(linkMatches, 'match.length')[l] - 1), paste0('\"', s2, '\":', s1))
  }
}

cat(redminecontent, file = paste0(reportName, '.redmine'))

" > temporaryrscript.R

echo 'Creating redmine update...'
Rscript temporaryrscript.R "$rmdFile"
rm temporaryrscript.R

echo 'Done!'


