options(rstudio.markdownToHTML = 
          function(inputFile, outputFile) {      
            require(markdown)
            markdownToHTML(inputFile, outputFile, stylesheet='/Users/Ulrich/git/R-projects/R-custom-odi.css')   
          }
) 
