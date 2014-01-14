# The Data Catalogue Update Hypothesis: Are Datasets Up-to-date?

### This is an obsolete draft. The current paper is under review and will be published at the end of March.

Governments and institutions often publish open data as part of a collection. A minimum requirement for these [data catalogues](http://datacatalogs.o[rg/) are discoverable and up-to-date datasets. We looked at three case studies and found further evidence from an [analysis of Socrata's](http://thomaslevine.com/!/data-updatedness) data catalogues.[^1] 

This matters for several reasons, for example:

* Businesses and startups using open data want to trust the publisher that the data remains available and up-to-date. Obsolete data will stifle **innovation**.
* A measure of timeliness will put the spotlight on the update cycle. Automating this process can lead to gains in **efficiency**.
* Current data is more useful. We can pre-empt counter-arguments such as "this is not relevant data anymore". It will ultimately support the **sustainability** of the open data ecosystem.

## Findings and summary

Here are some of the general findings:

1. **Missing timeliness**. More evidence points towards the hypothesis that many datasets are *not updated* with a regular schedule or at all. 

2. **Poor metadata**. The data about open data seems to be incomplete, undocumented or hard to find. (Ironic, you may say.) On the plus side, there is enough metadata available to make this statement.

3. A **new metric tau** (&tau;) to assess the **timeliness** of data. The World Bank scores "ok" with 0.54 (i.e., slightly more than half of the datasets are updated according to schedule.)  For our case studies this could easily be improved by releasing *monthly* datasets on a more regular basis. 

And in particular: 

#### 1. World Bank
The World Bank updates its data catalogues with an irregular schedule. Of the 102 data catalogues that have revision dates and are planned to be updated, only 39 were not revised in 2013. Overall slightly more than half of the datasets were updated according to schedule (&tau; = 0.54). The number of missing dates is relatively large, which is a substantial caveat.
     
#### 2. London Datastore

The London datastore hosts around 550 datasets. They were released with stark differences in some months over the last three years. More importantly, the updates are not concentrated in recent months, which suggests a poor update cycle. The &tau; = 0.53 is optimistic because its `metadata update` variable possibly includes minor updates.


#### 3. UK Datastore 

The UK datastore has an irregular release cycle. Even worse, only around 25% (4,000) datasets include data on update frequency. This *may* be one of the reason why it performs so poorly on the &tau; with 0.27. The UK datastore updated almost 3/4 of its datasets in 2013.

## Literature


## On the timeliness of data

What is an up-to-date dataset? This isn't a trivial question and is a function of the update frequency. A dataset that is only released annually probably doesn't need be updated more than once a year. 

Arguable the biggest area of "dark matter" comes from **deleted datasets**. To update, a publisher uploads a new dataset and deletes the previous one. Where or how is this reflected in the metadata? At least in the UK datastore this scenario seems to be "very, very rare".[^2]

Lastly, a dataset should always contain timely data. Some datasets such as the UK census or, [below](addendum), carbon emissions, may be technically up-to-date, but are too far behind reality in their schedule. Here we will not discuss the questions of what is timely data and focus on the update cycle of datastores.

### The tau of data

I propose the following metric for measuring the **timeliness** of data. The **tau** (&tau;) can be interpreted as *the percentage of datasets up-to-date in a datastore*.

<math xmlns="http://www.w3.org/1998/Math/MathML" mathsize="big">
  <mrow>
    <mi timeliness>timeliness</mi>
    <mo>=</mo>
     <mi mathvariant="bold">I</mi>
    <mfenced>
      <mfrac>
      <mrow>
        <mi>update frequency</mi>
      </mrow>
      <mrow>
        <mi>today</mi>
		<mo>&#x2212;</mo>
        <mi>last substantial update</mi>        
      </mrow>
   	</mfrac>
   </mfenced>
  </mrow>
</math>


This is simply an indicator (1 or 0) whether the dataset's last update was further ago than its update frequency. `I()` is the [indicator function](http://en.wikipedia.org/wiki/Indicator_function) and takes 1 if the ratio is bigger than 1 and zero otherwise. 

By *substantial* we mean a new release of the data. Minor updates, for example if someone discovers a typo in the title and corrects it, should not appear as an update.

The &tau; of a datastore is the average across datasets.

<math xmlns="http://www.w3.org/1998/Math/MathML" mathsize="big">
  <mrow>
    <mi>&tau;</mi>
    <mo>=</mo>
        <mfrac>
          <mrow>
            <mn>1</mn>
          </mrow>
          <mrow>
            <mi>N</mi>
          </mrow>
        </mfrac>
         <munderover>
              <mrow>
                <mo>&#x2211;</mo>
              </mrow>
              <mrow>
                <mi>i</mi>
                <mo>=</mo>
                <mn>1</mn>
              </mrow>
              <mrow>
                <mi>N</mi>
              </mrow>
            </munderover>
    <mi mathvariant="bold">I</mi>
     <mfenced>
      <mfrac>
      <mrow>
         <msub>
           <mrow>
             <mi>update frequency</mi>
           </mrow>
           <mrow>
             <mi>i</mi>
           </mrow>
         </msub>
        <mo>&sdot;</mo>
        <mi>&lambda;</mi>
     <mo>+</mo>
     <mi>&delta;</mi>
     </mrow>
      <mrow>
        <mi>today</mi>
		<mo>&#x2212;</mo>
         <msub>
           <mrow>
             <mi>last substantial update</mi>
           </mrow>
           <mrow>
             <mi>i</mi>
           </mrow>
         </msub>        
       </mrow>
      </mrow>
   	</mfrac>
   </mfenced>
  </mrow>
</math>


N is the number of datasets in the catalogue. We can make this more flexible by introducing two paramters, δ and &lambda;: the "leeway" of days we allow the datastore for updating. In our case studies we allowed for an extra 40 days.<!--We can introduce even more flexibility by allowing it to change by any category:       <math><msub><mrow><mi>&delta;</mi></mrow><mrow><mi>i</mi></mrow></msub></math>.-->

A &tau; of 0 means the catalogue has no up-to-date datasets. A &tau; of 1 means all datasets are up-to-date. 

| &tau; (tau)| timeliness of data |
| :-- | -----: |
| 0.91 - 1 | Exemplar |
| 0.71 - 0.9 | Standard | 
| 0.51 - 0.7 | OK | 
| 0.26 - 0.5 | Poor | 
| 0      - 0.25 | Obsolete | 

To implement the &tau;, you need to record two variables: the last substantial update and a standardised update frequency for all datasets (preferably in days; labels such as "biannually", "Bi-annually" and "every 6 months" are not helpful.)


## Methodology

The meandering landscape of open data portals prohibits a simple quantitative analysis. (Despite the limited number of data portal software such as CKAN.) [Some](http://thomaslevine.com/!/data-updatedness) have tried by looking at the Socrata metadata, though face numerous caveats.

We chose a more qualitative approach by looking at three case studies: the World Bank, the UK datastore and the London datastore. The three cases were selected because we have existing relationships with the publishers and they represent different regional levels (international, national and local, respectively).

An additional difficulty is that an uneven release cycle can stem from 

1. datasets that differ substantially in their update cycle; and
2. "waves" of updating datasets unrelated to the availability at the source.

Without additional information we cannot distinguish between the two explanations.  Even if we know how often datasets have to be updated, without a standardised metric the answer will only be suggestive. We therefore devised an unambiguous metric, the tau of data. However, "garbage in, garbage out", its validity relies on the underlying quality of the data. In our case studies the number of missing data poses substantial reason for concern.



## 1. The World Bank Data Catalogue

The original [metadata](http://datacatalog.worldbank.org/) contains 162 catalogues. For the columns `update frequency` and `last revision date` information for around 15% are missing. Missing data are treated as missing at random and are removed. 

The catalogues were last updated (`last revision date`) as follows:

2005 | 2006| 2007 | 2008 | 2009 | 2010 | 2011 | 2012 | 2013
 --: | --: |  --: | --:  |  --: | --:  | --:  | --:  | --:
   6 | 0   | 0    |  1   |    6 |  12  |  18  |  18  |  75 
   
We can see that the World Bank updated more than half of its data catalogues in 2013.

#### Figure 1.1: World Bank data catalogue last revision date 
![last revision](https://raw.github.com/theodi/R-projects/updata-cycle-new/data-portal-analysis/graphics/last-revision.png)

(The 2005 figures are an artefact because in the original data they are dated as 1905.)

It is also clear that the update cycle has clear spikes in certain months and is not uniform over the years.

### Taking the update frequency into account

Not all datasets have to be updated within the last year. Below we can see that some update frequencies are longer than a year or are even not planned.

#### Figure 1.2: World Bank data catalogue update frequency
![update frequency](https://raw.github.com/theodi/R-projects/updata-cycle-new/data-portal-analysis/graphics/update-frequency.png)

What happens if we look at the last update *taking into account the update frequency*? First, let's remove the 23 catalogues that are not planned to be updated. Secondly, we can now calculated the tau as outlined in the section above.

### The tau of the World Bank catalogue

The **overall <mi>&tau;</mi> = 0.54**, which means slightly more than half of the datasets are updated according to schedule.

This breaks down as follows:

Update frequency | <mi>&tau;</mi> | count 
 :-- | :--: | --: 
 no fixed schedule | 0.59  |  27 
             daily| 1.00  |   5
            weekly| 1.00  |   1
           monthly| 0.14  |   7
         quarterly| 0.92  |  25
        biannually| 0.33  |   9
          annually| 0.33  |  30
          annual +| 0.33  |  15       

To account for a small delay in publishing we added 40 days to the update frequency (the &delta;). "no fixed schedule" is assumed to be two years, which is generous. We set "annual +" to mean a thousand days.

### Conclusion

**The World Bank updates its data catalogues with an irregular schedule. Of the 102 data catalogues that have revision dates and are planned to be updated, only 39 were not revised in 2013. Overall slightly more than half of the datasets were updated according to schedule (&tau; = 0.54). The number of missing dates is relatively large, which is a substantial caveat.**


#### Addendum: up-to-date datasets ≠ up-to-date data

While the update cycle of the World Bank's data catalogues seems reasonable, there are serious gaps in important indicators. For example, a key metric to mitigate climate change is carbon emissions. The most recent numbers are only from 2010! While this is certainly not the Bank's fault, an updated dataset should also contain timely data.

<div style="width:800px; "height": 250px; font-family:'Helvetica Neue', Helvetica, Arial, sans-serif; line-height:20px"><div style="background-color:#333; padding:0px 5px; font-weight:bold"><div style="color:#fff; font-size:12px; line-height:20px;"><a href="http://data.worldbank.org/indicator/EN.ATM.CO2E.KT/countries?display=graph" style="color:#fff;text-decoration:none;" class="active">CO2 emissions (kt)</a></div></div><script type="text/javascript">widgetContext = { "url": "http://data.worldbank.org/widgets/indicator/0/web_widgets_3/EN.ATM.CO2E.KT/countries/1W", "width": 800, "height": 200, "widgetid": "web_widget_iframe_ea74e1142afed7b93751806f0dacae63" };</script><div id="web_widget_iframe_ea74e1142afed7b93751806f0dacae63"></div><script src="http://data.worldbank.org/profiles/datafinder/modules/contrib/web_widgets/iframe/web_widgets_iframe.js"></script><div style="font-size: 10px; color:#000">Data from <a href="http://data.worldbank.org/indicator/EN.ATM.CO2E.KT/countries?display=graph" style="color:#CCC;">World Bank</a></div></div>

Hans Rosling, in an [interview](http://blog.okfn.org/2013/01/21/carbon-dioxide-data-is-not-on-the-worlds-dashboard-says-hans-rosling/), puts it in colourful words: 

> I was with the Minister of Environment and she was going to Durban. And I said: "But you are going to Durban with eleven and a half month constipation. What if all of this shit comes out on stage? That would be embarrassing wouldn’t it?”


## 2. The London Datastore

At the time of analysis the [London datastore](http://data.london.gov.uk) hosts 537 datasets. They were published with the following pattern since January 2010. 

#### Figure 2.1 The London datastore, new data releases per month
![releases](https://raw.github.com/theodi/R-projects/updata-cycle-new/data-portal-analysis/graphics/London-releases-per-month.png)

The big spikes at the beginning are months were the London datastore released many similar datasets. For example, in August 2010 the Department for Education released a series of datasets. Or in October 2013 the London Fire and Emergency Planning Authority (LFEPA) added around a dozen datasets to the datastore. 

The more relevant variable is however the **metadata update** cycle. The metadata update is the "Last Updated Date of the Dataset or metadata (in the London Datastore)." As we can see below, for the London datastore the month of September 2010 is a large outlier. We don't have a better explanation than a general update of the early releases, but comments are welcome. 
#### Figure 2.2 The London datastore, metadata updates histogram
![metadata](https://raw.github.com/theodi/R-projects/updata-cycle-new/data-portal-analysis/graphics/london-metadata-modified.png)

Otherwise the metadata updates slightly trail the release figures. They are *not*, as you might expect for an up-to-date datastore, particularly concentrated in recent months. Below are figure 2.1 and 2.2 combined in one graphic.

#### Figure 2.3 The London datastore, new data releases and updates combined
![both](https://raw.github.com/theodi/R-projects/updata-cycle-new/data-portal-analysis/graphics/London-metadata.png)


### The tau of the London datastore

The **overall &tau; = 0.53**, which suggests, as with the World Bank, around half of the datasets are updated according to schedule. Some uncertainty persists as around 20% miss a measure of update frequency. However, the field "Last Updated Date of the Dataset or metadata (in the London datastore)" is more general than needed.

Update frequency | <mi>&tau;</mi> | count 
 :-- | :--: | --: 
     daily| 0.00  |  2
    weekly| 0.00  |  2
   monthly| 0.57  | 37
 quarterly| 0.51  | 57
biannually| 0.20  | 10
annually (and various)| 0.47  | 216
every 2 years | 1.00  |  1
every 4 years | 1.00  |  7
every 10 years| 1.00  | 29

The &delta; is again set at 40 days. "Annually" includes various qualitative codes such as "sporadically".


### Conclusion

**The London datastore hosts around 550 datasets. They were released with stark differences in some months over the last three years. More importantly, the updates are not concentrated in recent months, which suggests a poor update cycle. The &tau; = 0.53 is optimistic because its `metadata update` variable possibly includes minor updates.**


## 3. The UK Datastore (data.gov.uk)

The UK datastore, [data.gov.uk](http://data.gov.uk), hosts more than 16,000 datasets, although at least 4,000 of them are currently unpublished. According to the variable `last_major_modification`, which excludes minor revisions, most datasets were updated recently. Almost 3/4 were updated in 2013. 

#### Figure 3.1 The UK datastore, histogram of last major modification 

![data.gov.uk](https://raw.github.com/theodi/R-projects/updata-cycle-new/data-portal-analysis/graphics/gov-last-major-modification.png)

However, there is a substantial problem with missing data for `update_frequency`. This is one reason why the UK datastore performs not well. According to data.gov.uk there is a wider issue of educating publishers on what metadata to include.

If we compare the distribution of all datasets with the one that omits missing `update_frequency` (only around 4,000 remain!), we see a different pattern. The updates are no longer concentrated in recent months.

#### Figure 3.2 The UK datastore, last major modification with and without (orange) missing update frequency

![data.gov.uk](https://raw.github.com/theodi/R-projects/updata-cycle-new/data-portal-analysis/graphics/gov-last-major-modification-overlay.png)



### The tau of the UK datastore

The **overall <mi>&tau;</mi> = 0.27**, which is a poor figure and below the other two case studies. However, as mentioned above almost 3/4 of the update frequency data are missing. 

Update frequency | <mi>&tau;</mi> | count 
 :-- | :--: | --: 
     daily| 0.02  |  45
    weekly| 0.00  |  12
   monthly| 0.11  | 1445
 quarterly| 0.29  | 638
biannually| 0.23  | 228
annually (and various)| 0.38  | 1464
every 2 years | 0.06  |  17
every 10 years| 1.00  | 129


Given the strong pattern using all datasets, we might be inclined to assume the UK datastore does much better than the &tau; would suggest. The fact is, though, we cannot know without data. The distribution of "metadata_created" also has a spike September 2013 (see figure 3.3). This implies many datasets were added recently and that they may bias the `last_major_modification` variable. The release cycle is also highly irregular.

#### Figure 3.3 The UK datastore, histogram of metadata created 
![data.gov.uk](https://raw.github.com/theodi/R-projects/updata-cycle-new/data-portal-analysis/graphics/gov-metadata-created.png)

### Conclusion
**The UK datastore has an irregular release cycle. Even worse, only around 25% (4,000) datasets include data on update frequency. This *may* be one of the reason why it performs so poorly on the &tau; with 0.27. The UK datastore updated almost 3/4 of its datasets in 2013.**

## Future research

The [Dublin Core Metadata Initiative](http://dublincore.org/) (DCMI)

date range of dataset vs last publication

how does tau vary over time.
ranges for assessing timeliness of data



[^1]: We use the words 'datastore' and 'data catalogue' interchangeably.
[^2]: Personal email communication on 28 Nov 2013.

