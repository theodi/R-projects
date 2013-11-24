# The Data Catalogue Update Hypothesis: Are Datasets Up-to-date?

Governments and institutions often publish open data as part of a collection. A minimum requirement for these [data catalogues](http://datacatalogs.o[rg/) are discoverable and up-to-date datasets. We looked at three case studies and found further evidence from an [analysis of Socrata's](http://thomaslevine.com/!/data-updatedness) data catalogues. 

This matters for several reasons, for example:

* Businesses and startups using open data want to trust the publisher that the data remains available and up-to-date. Obsolete data will stifle **innovation**.
* A measure of timeliness will put the spotlight on the update cycle. Automating this process can lead to gains in **efficiency**.
* Current data is more useful. We can pre-empt counter-arguments such as "this is not relevant data anymore". It will ultimately support the **sustainability** of the open data ecosystem.

## Findings

Here are some of the general findings:

1. **Missing timeliness**. More evidence points towards the hypothesis that many datasets are *not updated* with a regular schedule or at all. 

2. **Poor metadata**. The data about open data seems to be incomplete, undocumented or hard to find. (Ironic, you may say.) On the plus side, there is enough metadata available to make this statement.

3. What goes on *within* datasets is another question...

And in particular: 

1. World Bank
2. London Datastore
3. UK Datastore 



## On the timeliness of data

What is an up-to-date dataset? This isn't a trivial question and is a function of the update frequency. A dataset that is only released annually probably doesn't need be updated more than once a year. 

Arguable the biggest area of "dark matter" comes from **deleted datasets**. To update, a publisher uploads a new dataset and deletes the previous one. Where or how is this reflected in the metadata? [TK: ask London and UK store]

Lastly, a dataset should always contain timely data. Some datasets such as the UK census or, [below](addendum), carbon emissions, may be technically up-to-date, but are too far behind reality in their schedule. Here we will not discuss the questions of what is timely data and focus on the update cycle of datastores.

### The `tau` of data

I propose the following metric:

```
tau =   sum over N I[ update frequency / (today – last substantial update) ]
```

This is the average of the indicator whether the dataset's last update was further ago than its update frequency. `I()` is the [indicator function](indicator) and takes 1 if the ratio is bigger than 1 and zero otherwise. `N` is the number of datasets in the catalogue. 

By substantial we mean a new release of the data. Minor updates, for example if someone discovers a typo in the title and corrects it, should not appear as an update.

A `tau` of 0 means the catalogue has no up-to-date datasets. A `tau` of 1 means all datasets are up-to-date. 

| `tau` | timeliness of data |
| :-- | -----: |
| 0.91 - 1 | Exemplar |
| 0.71 - 0.9 | Standard | 
| 0.51 - 0.7 | OK | 
| 0.31 - 0.5 | Poor | 
| 0      - 0.3 | Obsolete | 

To implement the `tau`, you need to record the last substantial update and a standardised update frequency for all datasets (preferably in days; labels such as "biannually", "Bi-annually" and "every 6 months" are not helpful.)


## Methodology

The meandering landscape of open data portals prohibits a simple quantitative analysis. (Despite the limited number of data portal software such as CKAN.) [Some](http://thomaslevine.com/!/data-updatedness) have tried by looking at the Socrata metadata, though face numerous caveats.

We chose a more qualitative approach by looking at three case studies: the World Bank, the UK datastore and the London datastore. The three cases were selected because we have existing relationships with the publishers and they represent different regional levels (international, national and local, respectively).

An additional difficulty is that an uneven release cycle can stem from 

1. datasets that differ substantially in their update cycle; and
2. "waves" of updating datasets unrelated to the availability at the source.

Without additional information we cannot distinguish between the two explanations.  Even if we know how often datasets have to be updated, without a proper metric the answer will only be qualitative and suggestive.



## 1. The World Bank Data Catalogue

The original [metadata](http://datacatalog.worldbank.org/) contains 162 catalogues. For the columns `update frequency` and `last revision date` information for around 15% are missing. Missing data are treated as missing at random and are removed. 

The catalogues were last updated (`last revision date`) as follows:

2005 | 2006| 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013
 --: | --: |  --: | --:  |  --: | --:  | --:  | --:  | --:
   6 | 0   | 0    |  1   |    6 |  12  |  18  |  18  |  75 
   
We can see that the World Bank updated more than half of its data catalogues in 2013.

#### Figure 1.1: World Bank data catalogue last revision date 
![last revision](https://raw.github.com/theodi/R-projects/master/data-portal-analysis/graphics/last-revision.png)

(The 2005 figures are an artefact because in the original data they are dated as 1905.)

It is also clear that the update cycle has clear spikes in certain months and is not uniform over the years.

### Taking the update frequency into account

Not all datasets have to be updated within the last year. Below we can see that some update frequencies are longer than a year or are even not planned.

#### Figure 1.2: World Bank data catalogue update frequency
![update frequency](https://raw.github.com/theodi/R-projects/master/data-portal-analysis/graphics/update-frequency.png)

What happens if we only look at the catalogues that were not updated in 2013?
First, let's remove the 23 catalogues that are not planned to be updated.
Secondly, let's inspect the update frequency for those catalogues that have not been updated in 2013. (We could get more granular here, by quarter or month, but simple will do.)



This looks promising: it's possible that for around half of them there was no reason to update the catalogue in 2013. 

**Overall `tau` = 0.54**

This breaks down as follows.

Update frequency | `tau` | count 
 :-- | --: | --: 
 no fixed schedule | 0.59  |  27 
             daily| 1.00  |   5
            weekly| 1.00  |   1
           monthly| 0.14  |   7
         quarterly| 0.92  |  25
        biannually| 0.33  |   9
          annually| 0.33  |  30
          annual +| 0.33  |  15       

To account for I added a arbitrary number of 40 days. "no fixed schedule" is assumed to be two years, whereas "annual +" a thousand days.

### Conclusion

The World Bank updates its data catalogues with an irregular schedule. However, of the 102 data catalogues that have revision dates and are planned to be updated, only 39 were not revised in 2013. We estimate that of these 39 data catalogues around half do not have an updated release at the source. (The number of missing dates is relatively large, which is a substantial caveat.)

<!--This is a positive framing – we could also say "hasn't updated around 20%"-->
**This means that the World Bank updates around 80% of its data catalogues. In this case study we therefore *cannot* reject hypothesis 1b: despite the uneven release cycle we may support the hypothesis that data catalogues are continuously updated.**

### Addendum

While the update cycle of the World Bank's data catalogues seems reasonable, there are serious gaps in important indicators. For example, a key metric to mitigate climate change is carbon emissions. The most recent numbers are only from 2010! While this is certainly not the Bank's fault, an updated dataset should also contain timely data.

<div style="width:600px; font-family:'Helvetica Neue', Helvetica, Arial, sans-serif; line-height:20px"><div style="background-color:#333; padding:0px 5px; font-weight:bold"><div style="color:#fff; font-size:12px; line-height:20px;"><a href="http://data.worldbank.org/indicator/EN.ATM.CO2E.KT/countries?display=graph" style="color:#fff;text-decoration:none;" class="active">CO2 emissions (kt)</a></div></div><script type="text/javascript">widgetContext = { "url": "http://data.worldbank.org/widgets/indicator/0/web_widgets_3/EN.ATM.CO2E.KT/countries/1W", "width": 600, "height": 200, "widgetid": "web_widget_iframe_ea74e1142afed7b93751806f0dacae63" };</script><div id="web_widget_iframe_ea74e1142afed7b93751806f0dacae63"></div><script src="http://data.worldbank.org/profiles/datafinder/modules/contrib/web_widgets/iframe/web_widgets_iframe.js"></script><div style="font-size: 10px; color:#000">Data from <a href="http://data.worldbank.org/indicator/EN.ATM.CO2E.KT/countries?display=graph" style="color:#CCC;">World Bank</a></div></div>

Hans Rosling, in an [interview](http://blog.okfn.org/2013/01/21/carbon-dioxide-data-is-not-on-the-worlds-dashboard-says-hans-rosling/), puts it in colourful words: 

> I was with the Minister of Environment and she was going to Durban. And I said: "But you are going to Durban with eleven and a half month constipation. What if all of this shit comes out on stage? That would be embarrassing wouldn’t it?”


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

