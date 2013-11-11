# The Data Catalogue Update Cycle Hypothesis: Do Datasets Appear In Waves?

Governments and institutions often publish open data as part of a collection. A minimum requirement for these [data catalogues](http://datacatalogs.org/) are discoverable and up-to-date datasets. Below is a lax methodological outline, which we will follow through with three case studies.


| H | Research null hypothesis |
| :-- | :----- |
| 1a | *Data catalogues publish datasets evenly over time.* |
| 1b | *Datasets in data catalogues are continuously updated.* | 


<!--Research null hypothesis 1a:
*Data catalogues publish datasets evenly over time.*

Research null hypothesis 1b:
*Datasets in data catalogues are continuously updated.*-->

Notice how rejecting hypothesis 1a is unrelated to hypothesis 1b. We have little information on how often datasets have to be updated. An uneven release cycle could mean that datasets have different update schedules. In fact, this is quite probable. Thus, how can we distinguish between:

1. a pattern due to datasets that differ substantially in their update cycle; and
2. "waves" of updating datasets unrelated to the availability at the source?

The answer will only be qualitative and suggestive. Let's start by having a look at the meta-information released by the [World Bank](http://data.worldbank.org). 

## 1. The World Bank Data Catalogue

The original [meta-data](http://datacatalog.worldbank.org/) contains 162 catalogues. For the columns "update frequency" and "last revision date" information for around 15% are missing. If not stated otherwise they are removed. 

The catalogues were last update as follows:

2005 | 2006| 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013
 --: | --: |  --: | --:  |  --: | --:  | --:  | --:  | --:
   6 | 0   | 0    |  1   |    6 |  12  |  18  |  18  |  75 
   
We can see that the World Bank updated more than half of its data catalogues this year.

#### Figure 1.1: World Bank data catalogue last revision date 
![last revision](https://raw.github.com/theodi/R-projects/master/data-portal-analysis/graphics/last-revision.png)

(The 2005 figures are an artefact because in the original data they are dated as 1905.)

It's also clear that we can reject hypothesis 1a. The update cycle has clear spikes in certain months and is not uniform over the years.

### Taking the update frequency into account

Not all datasets have to be updated within the last year. Below we can see that some update frequencies are longer than a year or are even not planned.

#### Figure 1.2: World Bank data catalogue update frequency
![update frequency](https://raw.github.com/theodi/R-projects/master/data-portal-analysis/graphics/update-frequency.png)

First, let's remove the 23 catalogues that are not planned to be updated.
Secondly, let's inspect the update frequency for those catalogues that have not been updated in 2013. (We could get more granular here, by quarter or month, but simple will do.)

#### Figure 1.3: World Bank data catalogue update frequency excluding 2013
![update frequency not 2013](https://raw.github.com/theodi/R-projects/master/data-portal-analysis/graphics/update-frequency-not2013.png)

This looks promising: it's possible that for around half of them there was no reason to update the catalogue in 2013. 

### Conclusion

The World Bank updates its data catalogues with an irregular schedule. However, of the 102 data catalogues that have revision dates and are planned to be updated, only 39 were not revised in 2013. We estimate that of these 39 data catalogues around half do not have an updated release at the source. (The number of missing dates is relatively large, which is a substantial caveat.)

<!--This is a positive framing – we could also say "hasn't updated around 20%"-->
**This means that the World Bank updates around 80% of its data catalogues. In this case study we therefore *cannot* reject hypothesis 1b: despite the uneven release cycle we may support the hypothesis that data catalogues are continuously updated.**

## 2. The London Datastore

At the time of analysis the [London datastore](http://data.london.gov.uk) hosts 537 datasets. They were published with the following pattern since January 2010. 

#### Figure 2.1 The London datastore dataset releases
![releases](https://raw.github.com/theodi/R-projects/master/data-portal-analysis/graphics/London-releases-per-month.png)

The big spikes at the beginning are months were the London datastore released many similar datasets. For example, in August 2010 the Department for Education released a series of datasets. Or in October 2013 the London Fire and Emergency Planning Authority (LFEPA) added around a dozen datasets to the datastore. 

The more relevant variable is however the **metadata** update cycle. (The metadata is the "Last Updated Date of the Dataset or metadata (in the London Datastore).") As we can see below, for the London datastore the month of September 2010 is a large outlier. We don't have a better explanation than a general update of the early releases, but comments are welcome. Otherwise the metadata updates slightly trail the release figures. They are **not**, as you might expect for an up-to-date datastore, particularly concentrated in recent months.

#### Figure 2.2 The London datastore dataset releases and updates
![metadata](https://raw.github.com/theodi/R-projects/master/data-portal-analysis/graphics/London-metadata.png)

The vast majority is updated annually or more often. So what is the average time distance between a release and a metadata update? As you can see below, the most common value is 32 weeks, which is a bit more than 7 months. Unfortunately, this is driven by the big spike in September 2010. Many datasets are also updated within a few weeks, which does not support an up-to-date data catalogue.

#### Figure 2.3 The London datastore update frequency
![difference](https://raw.github.com/theodi/R-projects/master/data-portal-analysis/graphics/London-month-diff-histogram.png)

### Conclusion

**The London datastore hosts around 550 datasets. They were released with stark differences in some months over the last three years. More importantly, the metadata updates are not concentrated in recent months and often happen soon after the original release. This is not a pattern we would expect in an up-to-date data catalogue.**

## 3. The UK Datastore ([data.gov.uk](http://data.gov.uk))

