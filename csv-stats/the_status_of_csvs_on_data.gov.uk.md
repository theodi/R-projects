# The status of CSVs on data.gov.uk

In January 2014 we created a file that contains all CSVs published on [data.gov.uk](http://data.gov.uk). It's a simple file that mainly lists all the URLs on data.gov.uk that are classified as data in a CSV format. 

rantirat 
class="table offers table-horizontally-condensed”
<table >
  <tr>
    <td>dataset</td>
    <td>Usually title and publisher</td>
  </tr>
  <tr>
    <td>url</td>
    <td>The URL of the dataset</td>
  </tr>
  <tr>
    <td>description</td>
    <td>More information, usually date published</td>
  </tr>
  <tr>
    <td>size</td>
    <td>Size of the file in bytes</td>
  </tr>
</table>

3169 (19%) are served over a secure connection, i.e. `https`.


![overall-stats](https://raw.github.com/theodi/R-projects/master/csv-stats/graphics/overall-stats.png)


## Size 

The vast majority of CSV files is between 1 kb and 1 mb in size. 

![size-histogram](https://raw.github.com/theodi/R-projects/master/csv-stats/graphics/histogram-size-of-csvs.png)


## Problems

There are numerous problems that prohibit importing, or even reading, a CSV file with a machine. 

1. Not available, for example because the link changed, the website is down.
2. Errors that may be circumvented such as `# curl: (60) SSL certificate problem: Invalid certificate chain`
3. Non-standard symbols that are not recognised. For example, an `invalid multibyte string` or erroneous line ending.
4. Files where the header row is not in line 1 or not specified. More in the next section.
5. Multiple tables in one file
6. And many, many more.

We can loosely summarise them by recognising the source of many CSV files: **often a direct copy of an Excel sheet**. An Excel sheet, optimised to be read by humans. 


## Automatically recognising a header row

A header row in a CSV includes short descriptive names of the data underneath. The header is paramount to get a minimal understanding of the data. Unfortunately, if the header is not in line 1, the machine has to guess where else it might be. This may be a simple task if the first few rows are empty. In many cases, however, the first few lines contain metadata such as the title or the source.

The following steps create an algorithm that ought to recognise the header row:

1. Find the maximum number of columns for any row (`max.no.col`)
1. Discard all, if any, empty rows from the beginning to the first non-empty row (`firstrow`) 
1. Test whether `firstrow` has an equal number compared to `max.no.col`
1. If the test fails, discard `firstrow` and go to step 2.
1. If the test passes, use `firstrow` as header row. 

A simple example is below. The first line is the title and the second one is empty. 
   [http://www.royalwolverhamptonhospitals.nhs.uk/files/mth%206%20september%202013%20(3).csv](http://www.royalwolverhamptonhospitals.nhs.uk/files/mth%206%20september%202013%20(3).csv)

   ![example](https://raw.github.com/theodi/R-projects/master/csv-stats/graphics/missing-header-example.png)

Moreover, it is a good idea to check whether the CSV contains more than one table.
A. Check whether the header names appear in the respective column again.








 
