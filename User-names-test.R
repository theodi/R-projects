library(RCurl)
test_user = function(site = 'https://bitbucket.org/',
                     candidates = c(0:9, letters)) {
  for (i in candidates) {
    if (!url.exists(paste0(site, i))) message(i)
    Sys.sleep(runif(1, 0, .1)) # be nice
  }
}
# examples
test_user()
# two-letter names
test_user(candidates = as.vector(outer(letters, letters, 'paste0')))
# check github
test_user('https://github.com/')