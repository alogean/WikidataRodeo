library(WikidataQueryServiceR)
library(tibble)
library(htmltab)
library(rvest)


sparql.query.1 <- 'SELECT
?company ?companyLabel ?isin ?web ?country ?countryLabel ?inception

WHERE
{
     ?article schema:inLanguage "en" .
     ?article schema:isPartOf <https://en.wikipedia.org/>.
     ?article schema:about ?company .

     ?company p:P31/ps:P31/wdt:P279* wd:Q783794.

     ?company wdt:P946 ?isin.
     OPTIONAL {?company wdt:P856 ?web.}
     OPTIONAL {?company wdt:P571 ?inception.}
     OPTIONAL {?company wdt:P17 ?country.}

     SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}'

url.1 <- "https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue"
xpath.1 <- "//html//body//div[3]//div[3]//div[5]//div[1]//table[2]"

xpast.2 <- "//html//body//main//table"
url.2 <- "https://www.rüstungsreport.ch/#a-datatable"

get_wikidata_companies <- function(){
  return(as_tibble(query_wikidata(sparql.query.1)))
}


get_wikipedia_biggest_us_companies <- function() {
  return(get_wikipedia_tabular_data(url.1, xpath.1))
}

get_wikipedia_tabular_data <- function(url, my.xpath) {
  html.doc <- read_html(url)
  node <- html_nodes(html.doc, xpath = my.xpath)
  tabular.data <- html_table(node, fill=TRUE)[[1]]
  return(tabular.data)
}

html.doc <- read_html(url)
data <- get_wikipedia_tabular_data(url, xpath)
