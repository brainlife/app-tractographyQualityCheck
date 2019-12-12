[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.189-blue.svg)](https://doi.org/10.25663/brainlife.app.189)

# app-tractographyQualityCheck
Compute a number of statistics about your input tractogram and any (optionally input) associated classification structure.

### Authors
- Daniel Bullock (dnbulloc@iu.edu)

### Contributors
- Soichi Hayashi (hayashis@iu.edu)

### Project Director
- Franco Pestilli (franpest@indiana.edu)

### Funding 
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)

### References 
TBA

## Running the App 

### On Brainlife.io

Visit https://doi.org/10.25663/brainlife.app.189 to run this app on the brainlife.io platform.  Minimally requires a tractogrphy input.  Can also be augmented with a LiFE input and/or a white matter classificaiton (WMC) object to perform statistical analyes relevant to the LiFE fit and/or segmentation.

### Running Locally (on your machine) using singularity & docker

Because this is compiled code which runs on singularity, you can download the repo and run it locally with minimal setup.  

### Running Locally (on your machine)

Pull the wma toolkit repo:  https://github.com/DanNBullock/wma_tools

Ensure that the packages listed under 'adding paths' are avaialble on your local environment.

Run: https://github.com/DanNBullock/wma_tools/blob/master/bsc_feAndSegQualityCheck_BL_v2.m, but take care to ensure that the addpath-genpath statements are relevant to your local setup.

Utilize a config.json setup that is analagous to the one contained within this repo, listed as a sample.

### Sample Datasets

Visit brainlife.io and explore the following data sets to find viable classification and tractography inputs:

HCP classificaiton:  https://brainlife.io/project/5c3caea0a6747b0036dcbf9a/
HCP tractography:  https://brainlife.io/project/5c3caea0a6747b0036dcbf9a/

### Output

There are three outputs associated A tractmeasures csv, an image/svg, and “raw”  type output.

**tractmeasures**

a csv output from the quality check app ([https://doi.org/10.25663/brainlife.app.189](https://doi.org/10.25663/brainlife.app.189)) which displays the following traits for each tract:

| **Column header** | **Description** |
| --- | --- |
| TractName | The name of this tract |
|   | Code Link:  NA |
| StreamlineCount | The number of streamlines in this tract |
|   | Code Link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L75 |
| volume | The volume occupied by this tract (presented in cubic mm) |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L94 |
| avgerageStreamlineLength | The mean streamline length of this tract |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L79 |
| streamlineLengthStdev | The standard deviation of streamline lengths for this tract |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L80 |
| averageFullDisplacement | The average distance between streamline endpoints for this tract |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L67 |
| fullDisplacementStdev | The standard deviation of distances between streamline endpoints for this tract |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L68 |
| ExponentialFitA | The (a) parameter when fitting y=a^(b\*x) for the whole brain distribution of fiber lengths.  Only ever computed for the whole brain tractography (i.e. is empty for all non &quot;whole brain&quot; tracts) |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantWBFG.m#L67 |
| ExponentialFitB | The (b) parameter when fitting y=a^(b\*x) for the whole brain distribution of fiber lengths.  Only ever computed for the whole brain tractography (i.e. is empty for all non &quot;whole brain&quot; tracts) |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantWBFG.m#L68 |
| StreamlineLengthTotal | The sum total of streamline lengths for this tract (i.e. total wiring) |
|   | Code Link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L76 |
| endpoint1Density\* | The density of the endpoint mask associated with the right/superior/anterior-most (whichever is most appropriate for this tract) collection of terminations for this tract.  Computes the number of endpoints per occupied (by endpoints from this group) 1mm cubic voxel. |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L125 |
| Endpoint2Density\* | The density of the endpoint mask associated with the left/inferior/posterior-most (whichever is most appropriate for this tract) collection of terminations for this tract.  Computes the number of endpoints per occupied (by endpoints from this group) 1mm cubic voxel. |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L141 |
| AverageEndpointDistanceFromCentroid1\* | The average distance of a streamline endpoint within the right/superior/anterior-most group from the centroid of this group.  Computed as the euclidean distance from the average coordinate of this group.  Considered to be a measure of streamline endpoint dispersion. |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L133 |
| AverageEndpointDistanceFromCentroid2\* | The average distance of a streamline endpoint within the left/inferior/posterior-most group from the centroid of this group.  Computed as the euclidean distance from the average coordinate of this group.  Considered to be a measure of streamline endpoint dispersion. |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L149 |
| stdevOfEndpointDistanceFromCentroid1\* | The standard deviation of the distances of a streamline endpoint within the right/superior/anterior-most group from the centroid of this group.  Computed as the euclidean distance from the average coordinate of this group. |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L134 |
| stdevEndpointDistanceFromCentroid2\* | The standard deviation of the distances of a streamline endpoint within the left/inferior/posterior-most group from the centroid of this group.  Computed as the euclidean distance from the average coordinate of this group. |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L150 |
| MidpointDensity | The density of the midpoint mask associated for this tract.  Computes the number of midpoints per occupied (by midpoints) 1mm
# 3
 voxel. |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L157 |
| averageMidpointDistanceFromCentroid | The average distance of a streamline midpoint from the centroid of this group.  Computed as the euclidean distance from the average coordinate of this group. |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L165 |
| stDevOfMidpointDistanceFromCentroid | The standard deviation of the distances of a streamline midpoint from the centroid of this group.  Computed as the euclidean distance from the average coordinate of this group. |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L166 |
| TotalVolumeProportion | The proportion of the total white matter volume occupied by this tract.  Intended to control for variability in brain size. |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantAllWMNorm.m#L53 |
| TotalCountProportion | The proportion of the total number of streamlines associated with tract.  Intended to control for variability in input tractogram size (i.e. whole brain streamline total). |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantAllWMNorm.m#L54 |
| TotalWiringProportion | The proportion of the total streamline length accounted for by streamlines associated with this tract. |
|   | Code Link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantAllWMNorm.m#L55 |

\*endpoint membership in either the left/inferior/posterior-most (LIP) or right/superior/anterior-most (RAS) group is determined by the following process:

1. computing the primary dimension of traversal for a tract (i.e. left-right, inferior-superior, anterior-posterior) by determining which dimension exhibits the greatest displacement for the given tract.
2. Once this dimension has been determined, the relevant coordinates (x, y, or z) of the streamline&#39;s endpoints are checked to determine determine LIP or RAS membership



**image/svg**** :**

An svg image output from the quality check app ([https://doi.org/10.25663/brainlife.app.189](https://doi.org/10.25663/brainlife.app.189)) with the following plots:

| **Figure title** | **X axis quantity** | **Y axis quantity** | **Description** |
| --- | --- | --- | --- |
| &quot;Normalized WBFG &amp; NonZero Weighted Stream Count Comparison&quot; | streamline length (in mm) | whole brain proportion of the streamline count | This plot depicts the proportion of streamlines (out of all those in the whole brain fiber group) that are of a certain length. The dark blue line corresponds to the input whole brain tractogram, while the light blue line corresponds to the line of best fit using an exponential model (y=a^(b\*x)).  The relevant parameters can be noted in the grey column on the left. |
| &quot;Cumulative proportion of fibers in connectome, by length&quot; | streamline length (in mm) | total proportion of streamlines | This plot depicts the total proportion of streamlines that are equal to or less than the specified length. |
| &quot;Classified Streamline proportion Comparison:  WBFG &amp; Surviving&quot; | streamline length (in mm) | total proportion of classified streamlines | Similar to the first plot, but only computes proportions for classified streamlines.  Proportion is relative to all classified streamlines. |
| &quot;Log10 of proportion of connectome streamlines in tract&quot; | tract names | log10 of the percentage of the total number of streamlines in whole brain fiber group | For all identified tracts in the input white matter classification (WMC) structure this plot indicates the percentage (scaled in log10) of all streamlines in the whole brain fiber group that are associated with this specific tract.For tracts which have left and right variants, left is plotted in blue and right is plotted in orange.  For tracts which do not have left and right variants (i.e. are interhemispheric) the default color is blue. |
| &quot;Proportion of white matter volume occupied by tract&quot; | tract names | Portion of white matter occupied (by percent) | For all identified tracts in the input white matter classification (WMC) structure this plot indicates the percentage of the total white matter volume occupied by each respective tract. For tracts which have left and right variants, left is plotted in blue and right is plotted in orange.  For tracts which do not have left and right variants (i.e. are interhemispheric) the default color is blue. |



**&quot;raw&quot; type output**** :**

A tiered, field based .mat structure with the metrics included in the **tractmeasures.csv** , along with additional metrics.  Generated as an output from the quality check app ([https://doi.org/10.25663/brainlife.app.189](https://doi.org/10.25663/brainlife.app.189)).  Below the metrics **not** included in the **tractmeasures.csv** are described.

Note:  statistics listed immediately below are those within the field contents of results.WBFG and are specific to the associated whole brain fiber group, and are thus **computed across all streamlines in the associated**** whole brain fiber group**.  The exception is the tractStats field, which will be described in a separate table immediately following this one.

| **Fieldname (within results.WBFG)** | **Description** |
| --- | --- |
| avgefficiencyRat(average efficiency ratio) | This quantity is the _average efficiency ratio_ for all streamlines in the entire whole brain fiber group.  For a given streamline this is computed by dividing the streamline&#39;s _displacement_ (see description in tractmeasures.csv section) by that same streamline&#39;s length.  Thus this value approaches 1 as a streamline approaches being shaped like a straight line, and approaches 0 as a streamline approaches being shaped like a full circuit. |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/ConnectomeTestQ\_v2.m#L49 |
| stDevefficiencyRat(standard deviation of efficiency ratio) | This quantity is the _standard deviation of the efficiency ratio_ for all streamlines in the entire whole brain fiber group. |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L71 |
| avgAsymRat(average asymmetry ratio) | This quantity is the _average asymmetry ratio_ for all streamlines in the entire whole brain fiber group.  In essence, for a given streamline, it is the square of the differences between the efficiency ratios for the respective halves of a streamline.  Thus, as a streamline&#39;s _asymmetry ratio_ approaches the maximum of 1, it indicates that one half has an efficiency ratio of 0, and resembles a full circuit, while the other half has an efficiency ratio of 1 and resembles a straight line.  On the other hand, as a streamline&#39;s _asymmetry ratio_ approaches the minimum of 0, the difference between the two halves&#39; efficiency ratios approach 0, and are thus presumed to more closely resemble one another, at least within the domain of wiring efficiency. |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/ConnectomeTestQ\_v2.m#L52 |
| stdDevAsymRat(standard deviation of asymmetry ratio) | This quantity is the _standard deviation of the asymmetry ratio_ for all streamlines in the entire whole brain fiber group. |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L65 |
| volLengthRatio(volume length ratio) | The ratio of the total wiring length for all streamlines in the whole brain fiber group to the total white matter volume of the whole brain fiber group (i.e. in this case, simply the total volume of the white matter) |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/92c4c1aa2bedd569e696ef1476eb979567849c9f/wma\_quantTract.m#L96 |
| lengthCounts  | A 1x299 long vector wherein the ith entry corresponds to the number of streamlines such that i≤[streamline length]\&lt;i+1 |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/92c4c1aa2bedd569e696ef1476eb979567849c9f/wma\_quantTract.m#L99 |
| LengthProps | A 1x299 long vector wherein the ith entry corresponds to the proportion of the total number of streamlines such that i≤[streamline length]\&lt;i+1 |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/5453f056df5f43c6a12c57fe76eabfd7eba3705c/wma\_quantWBFG.m#L52 |
| LengthData | The computed length for each streamline in the whole brain fiber group. |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/5453f056df5f43c6a12c57fe76eabfd7eba3705c/wma\_quantWBFG.m#L62 |
| tractStats | A 1 by N cell structure, wherein each cell entry corresponds to the output of a quantitative analysis **for a specific tract**.  The ith entry in this cell structure corresponds to the tract specified in the ith entry in the classification.names field of the associated classification structure. |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantAllWMNorm.m#L46 |

Note:  statistics listed immediately below are those within the field contents of results.WBFG.tractStats{1,i}, where i corresponds the tract specified in the ith entry in the classification.names field of the associated classification structure.  The quantifications described below are specific to their associated tract.  Omitted from these descriptions are quantifications which have been described either for the **tractmeasures.csv** data object or the results.WBFG field.  In cases where the quantification has previously been described within the context of a measurement of a whole brain fiber group, the quantification is to be understood to represent the same general concept, but to characterize a specific tract in these cases.



| **Fieldname (within results.WBFG.tractStats{1,i})** | **Description** |
| --- | --- |
| endpointVolume1 | The volume of the endpoint mask associated with the right/superior/anterior-most (whichever is most appropriate for this tract) collection of terminations for this tract. |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L123 |
| endpointVolume2 | The volume of the endpoint mask associated with the left/inferior/posterior-most (whichever is most appropriate for this tract) collection of terminations for this tract. |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L139 |
| avgEndpointCoord1 | The centroid of the endpoints associated with the  right/superior/anterior-most end of this tract.  Computed as the average coordinate of this group. |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L124 |
| avgEndpointCoord2 | The centroid of the endpoints associated with the  left/inferior/posterior-most end of this tract.  Computed as the average coordinate of this group. |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L140 |
| midpointVolume | The volume of the endpoint mask associated with the midpoints of streamlines associated with this tract. |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L155 |
| avgMidpointCoord | The centroid of the midpoints of streamlines associated with this tract.  Computed as the average coordinate of this group. |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantTract.m#L156 |
| results.WBFG.tractStats{1,i}.endpointVolume1Prop | The proportion of the total white matter volume occupied by this endpoint mask associated with the right/superior/anterior-most (whichever is most appropriate for this tract) collection of terminations for this tract.  Intended to control for variability in brain size. |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantAllWMNorm.m#L57 |
| results.WBFG.tractStats{1,i}.endpointVolume2Prop | The proportion of the total white matter volume occupied by this endpoint mask associated with the left/inferior/posterior-most (whichever is most appropriate for this tract) collection of terminations for this tract.  Intended to control for variability in brain size. |
|   | Code link:https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantAllWMNorm.m#L58 |
| results.WBFG.tractStats{1,i}.midpointVolumeProp | The proportion of the total white matter volume occupied by this endpoint mask associated with the midpoints of streamlines associated with this tract.  Intended to control for variability in brain size. |
|   | Code link: https://github.com/DanNBullock/wma\_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma\_quantAllWMNorm.m#L59 |

#### Product.json

Currently not implimented

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/) and in order to load the tck, a verson of vistasoft.  

https://singularity.lbl.gov/docs-installation\
https://github.com/vistalab/vistasoft
 
