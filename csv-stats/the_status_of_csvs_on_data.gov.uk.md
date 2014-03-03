# What is a CSV? A case study of CSV files on data.gov.uk


## Abstract

CSV stands for *comma-separated values*. It is a simple format for tabular data and relatively easy to process. We analysed more than 20,000 links to CSV files on data.gov.uk – only around one third turned out to be machine-readable. Around 4,000 were other formats, another 4,000 are no longer available and the rest did not conform to a minimal standard such as a header row in the first line. Our analysis of the headers of 7390 machine-readable CSVs suggests that there are clear patterns. The most common type are spent records. Other departments such as the Crown Prosecution Service also releases vast amounts of CSVs, usually split by month and type.



## Metadata

In January 2014 we created a file that contains all CSVs published on [data.gov.uk](http://data.gov.uk). [STUART TO ADD A SENTENCE ON HOW] The result is a simple file that mainly lists all the URLs on data.gov.uk that are classified as data in a CSV format. 

 
<table class="table offers table-horizontally-condensed">
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

##### Figure 1. Number of valid CSVs on data.gov.uk
![overall-stats](https://raw.github.com/theodi/R-projects/master/csv-stats/graphics/overall-stats.png)

Figure 1 shows how the overall number of 20,692 dwindles to 7390:

1. Almost 4,000 URLs are not CSVs and link to other files or just web pages. 

2. Of the URLs that do end in `.csv`, around 4,000 yield an error. For example, some files that detail the [Crossrail Spend 2013](http://www.crossrail.co.uk/assets/library/document/c/original/crossrail_payments_period_13_2012-13.csv) are no longer available. 
3. Even if the CSV exists, it loses some of its value if we cannot read it automatically. Standards are hence important. An example of what did **not** get parsed is below. The first line is the title and the second one is empty. 
   [http://www.royalwolverhamptonhospitals.nhs.uk/files/mth%206%20september%202013%20(3).csv](http://www.royalwolverhamptonhospitals.nhs.uk/files/mth%206%20september%202013%20(3).csv)

   ![example](https://raw.github.com/theodi/R-projects/master/csv-stats/graphics/miss-header-example.png)


As a side note, of all the CSVs listed on data.gov.uk, 3169 (19%) are served over a secure connection, i.e. `https`.





## Size 

The vast majority of CSV files is between 1 kb and 1 mb in size. 

![size-histogram](https://raw.github.com/theodi/R-projects/master/csv-stats/graphics/histogram-size-of-csvs.png)


## Problems

What is going on? One simple explanation is that many CSV files were not 

There are numerous problems that prohibit importing, or even reading, a CSV file with a machine. 

1. Not available, for example because the link changed or the website is down.
2. Errors that can be circumvented such as `# curl: (60) SSL certificate problem: Invalid certificate chain`
3. Non-standard symbols that are not recognised. For example, an `invalid multibyte string` or erroneous line ending.
4. Files where the header row is not in line 1 or not specified. More in the next section.
5. Multiple tables in one file
6. And many more.

We can loosely summarise them by recognising the source of many CSV files: **often a direct copy of an Excel sheet**. An Excel sheet, optimised to be read by humans. 


## Automatically recognising a header row

A header row in a CSV includes short descriptive names of the data underneath. The header is paramount to get a minimal understanding of the data. Unfortunately, if the header is not in line 1, the machine has to guess where else it might be. This may be a simple task if the first few rows are empty. In many cases, however, the first few lines contain metadata such as the title or the source.

The following steps create an algorithm that ought to recognise the header row:

1. Find the maximum number of columns for any row (`max.no.col`)
1. Discard all, if any, empty rows from the beginning to the first non-empty row (`firstrow`) 
1. Test whether `firstrow` has an equal number compared to `max.no.col`
1. If the test fails, discard `firstrow` and go to step 2.
1. If the test passes, use `firstrow` as header row. 



Moreover, it is a good idea to check whether the CSV contains more than one table.


## Headers and schemas

After much experimentation we managed to automatically read 7,390 CSV-files. All of them have of course header names that can be analysed. For example, we see that a typical size of an CSV-file on data.gov.uk has eight columns.

![header-length](https://raw.github.com/theodi/R-projects/master/csv-stats/graphics/header-length-histogram.png)

What are the most popular header names? We had to clean up a lot of the names because in its raw format, you'll get "amount", " amount", "AMUONT" etc. After some [Open Refine](http://openrefine.org) magic, we get the following table. They may not be representative overall because only the machine-readable CSVs feature, but show how common certain data types are.

<table class="table offers table-horizontally-condensed">
 <tr><td>Expense Type</td><td>3,144</td></tr>
 <tr><td>Entity</td><td>3,039</td></tr>
 <tr><td>Expense Area</td><td>3,029</td></tr>
 <tr><td>Supplier</td><td>2,889</td></tr>
 <tr><td>Date</td><td>2,820</td></tr>
 <tr><td>Transaction Number</td><td>2,791</td></tr>
 <tr><td>Amount</td><td>2,734</td></tr>
 <tr><td>Department Family</td><td>2,498</td></tr>
 <tr><td>VAT Registration Number</td><td>916</td></tr>
 <tr><td>Convictions Percentage</td><td>836</td></tr>
</table>

The whole analysis is of course on [GitHub](https://github.com/theodi/R-projects/blob/master/csv-stats/csv-meta-analysis-data-gov.R).



![header-map](https://raw.github.com/theodi/R-projects/master/csv-stats/co-occurrence/top-headers-coocc.png)




Spend over £25,000
Crown prosecution





 
