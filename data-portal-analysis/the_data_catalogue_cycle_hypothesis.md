# The Data Catalogue Update Cycle Hypothesis: How Datasets Appear In Waves


Governments and institution publish open data often as part of a collection. A minimum requirement for these [data catalogues](http://datacatalogs.org/) are discoverable and up-to-date datasets. Below is a lax methodological outline, which we will follow through with three case studies.


H | Research null hypothesis
: ------------ | : ------------- 
1a | *Data catalogues publish datasets evenly over time.*
1b | *Datasets in data catalogues are continuously updated.* 


<!--Research null hypothesis 1a:
*Data catalogues publish datasets evenly over time.*

Research null hypothesis 1b:
*Datasets in data catalogues are continuously updated.*-->

Notice how rejecting hypothesis 1a is unrelated to hypothesis 1b. We have little information of how often datasets have to be updated. An uneven release cycle could mean that datasets have different update schedules. In fact, this is quite probable. Thus, how can we distinguish between:

1. airtnai
2. anristen?

The answer will only be qualitative and suggestive. Let's start by having a look at the meta-information released by the [World Bank](http://data.worldbank.org). 

## The World Bank Data Catalogue

The original [dataset](http://datacatalog.worldbank.org/) contains 162 catalogs. For the columns "update frequency" and "last revision date" information for around 15% are missing. If not stated otherwise they are removed. 

The catalogues were last update as follows:

2005 | 2006| 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013
 --: | --: |  --: | --:  |  --: | --:  | --:  | --:  | --:
   6 | 0   | 0    |  1   |    6 |  12  |  18  |  18  |  75 
   
We can see that more than half were updated this year.

#### Figure 1: World Bank data catalogue last revision date
![last revision](https://raw.github.com/theodi/R-projects/master/data-portal-analysis/graphics/last-revision.png)

(The 2005 figures are an artefact because in the original data they are dated as 1905.)

### Taking the update frequency into account

Not all datasets have to be updated within the last year. We can see below that some update frequencies are longer than a year or are even not planned.

#### Figure 2: World Bank data catalogue update frequency
![update frequency](https://raw.github.com/theodi/R-projects/master/data-portal-analysis/graphics/update-frequency.png)