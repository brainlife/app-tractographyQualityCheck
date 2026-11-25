<h1 align="center">Tractography quality check</h1>

<p align="center">
  Quality-control statistics, a tractmeasures table and a summary figure for a whole-brain tractogram and its white matter classification.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.189"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.189-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Computes quality-control statistics and a summary figure for a whole-brain tractogram and its white matter classification (streamline count, volume, length distribution, per-tract measures) with the MATLAB wma_tools toolkit.**

A quality check application for tractography, and segmentatations. For the whole brain tractogram, provides a number of statistics associated with average streamline characteristics (i.e. count, volume occupied, avg length, length distribution). Does the same for the positively weighted streamlines of an FE structure if input. If a classification structure is input, provides a number of macrostructural statistics like stream count, volume, avg length, whole brain count/volume proportion, etc).

| | |
|---|---|
| **Inputs** | `neuro/track/tck` · `neuro/wmc` |
| **Outputs** | `generic/image/svg` · `raw` · `neuro/tractmeasures` |
| **Container** | `brainlife/mcr:r2019a` |
| **Resources** | 8 CPUs · 28 GB memory · 18 h walltime |
| **Run it** | [doi.org/10.25663/brainlife.app.189](https://doi.org/10.25663/brainlife.app.189) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `wbfg` | `neuro/track/tck` | yes | Whole brain tractography. A tractome which covers the entire white matter. |
| `classification` | `neuro/wmc` | yes | A white matter classification structure which corresponds to the input whole brain tractography entered as a track/tck. classification.index must have one entry per streamline of the tractogram, otherwise the App stops with a mismatch error. |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `image` | `generic/image/svg` | SVG figure summarising whole-brain statistics, streamline length distributions and per-tract count and volume proportions. |
| `tractmeasures` | `raw` | MATLAB results structure (tractomeResultStruc.mat) with all computed whole-brain and per-tract statistics. |
| `resultsSummary` | `neuro/tractmeasures` | tractmeasures.csv with one row for the whole-brain tractogram and one per classified tract: streamline count, volume, length mean/stdev, displacement, endpoint and midpoint statistics and proportions of the whole brain. |

<!-- brainlife-app:end -->

## Versions on brainlife.io

| Version | Inputs | Branch | Run it | Status |
|---|---|---|---|---|
| Tractography quality check | tractogram and white matter classification | [`1.4`](https://github.com/brainlife/app-tractographyQualityCheck/tree/1.4) | [doi:10.25663/brainlife.app.189](https://doi.org/10.25663/brainlife.app.189) | current |
| Tractography quality check | tractogram, optional LiFE and deprecated classification | [`master`](https://github.com/brainlife/app-tractographyQualityCheck/tree/master) | [doi:10.25663/brainlife.app.139](https://doi.org/10.25663/brainlife.app.139) | deprecated |

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.189](https://doi.org/10.25663/brainlife.app.189), choose a whole-brain [tractogram](https://brainlife.io/datatype/5907d922436ee50ffde9c549) and the [white matter classification (WMC)](https://brainlife.io/datatype/5cc1d64c44947d8aea6b2d8b) made from that same tractogram, and press **Execute**. The App computes statistics about the tractogram and each classified tract with the MATLAB [wma_tools](https://github.com/DanNBullock/wma_tools) toolkit: streamline count, volume occupied, average length and length distribution for the whole brain, and macrostructural statistics such as streamline count, volume, average length and whole-brain count and volume proportions for each tract. Use them for quality assurance of tractography and segmentation, or in subject- and group-level quantitative analyses.

The code also handles a [LiFE](https://dx.doi.org/10.1038%2Fnmeth.3098) structure (`fe`) in place of the tractogram, computing the same statistics for the positively weighted streamlines.

### Locally

The App runs compiled MATLAB code, so you can run it with minimal setup. You need [Singularity/Apptainer](https://apptainer.org/); the code runs inside the MATLAB Runtime R2019a container.

1. Clone this repository and check out the branch brainlife.io runs: `git checkout 1.4`.
2. Create `config.json` with the paths to your inputs:

   ```json
   {
       "track": "/input/track/track.tck",
       "classification": "/input/wmc/classification.mat",
       "tracts": "/input/wmc/tracts"
   }
   ```

3. Run the App:

   ```bash
   ./main
   ```

To run the MATLAB source instead, clone [wma_tools](https://github.com/DanNBullock/wma_tools) (included here as a submodule) and [vistasoft](https://github.com/vistalab/vistasoft), adjust the `addpath` statements in [`main.m`](main.m) to your setup, and run it with a `config.json` like the one above.

### Sample data

Explore the [HCP project on brainlife.io](https://brainlife.io/project/5c3caea0a6747b0036dcbf9a/) for suitable tractography and classification inputs.

## Outputs

```text
resultsSummary/tractmeasures.csv          one row for the whole-brain tractogram and one per tract (neuro/tractmeasures)
image/image.svg                           summary figure (generic/image/svg)
tractmeasures/tractomeResultStruc.mat     all computed statistics in a MATLAB structure (raw)
```

<details>
<summary><b>tractmeasures.csv</b> columns</summary>

| **Column header** | **Description** |
| --- | --- |
| structureID (formerly TractName) | The name of this tract |
|   | Code Link:  NA |
| StreamlineCount | The number of streamlines in this tract |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L75) |
| volume | The volume occupied by this tract (presented in cubic mm) |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L94) |
| averageStreamlineLength | The mean streamline length of this tract |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L79) |
| streamlineLengthStdev | The standard deviation of streamline lengths for this tract |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L80) |
| averageFullDisplacement | The average distance between streamline endpoints for this tract |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L67) |
| fullDisplacementStdev | The standard deviation of distances between streamline endpoints for this tract |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L68) |
| ExponentialFitA | The (a) parameter when fitting y=a^(b\*x) for the whole brain distribution of fiber lengths.  Only ever computed for the whole brain tractography (i.e. is empty for all non &quot;whole brain&quot; tracts) |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantWBFG.m#L67) |
| ExponentialFitB | The (b) parameter when fitting y=a^(b\*x) for the whole brain distribution of fiber lengths.  Only ever computed for the whole brain tractography (i.e. is empty for all non &quot;whole brain&quot; tracts) |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantWBFG.m#L68) |
| StreamlineLengthTotal | The sum total of streamline lengths for this tract (i.e. total wiring) |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L76) |
| endpoint1Density\* | The density of the endpoint mask associated with the right/superior/anterior-most (whichever is most appropriate for this tract) collection of terminations for this tract.  Computes the number of endpoints per occupied (by endpoints from this group) 1mm cubic voxel. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L125) |
| Endpoint2Density\* | The density of the endpoint mask associated with the left/inferior/posterior-most (whichever is most appropriate for this tract) collection of terminations for this tract.  Computes the number of endpoints per occupied (by endpoints from this group) 1mm cubic voxel. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L141) |
| AverageEndpointDistanceFromCentroid1\* | The average distance of a streamline endpoint within the right/superior/anterior-most group from the centroid of this group.  Computed as the euclidean distance from the average coordinate of this group.  Considered to be a measure of streamline endpoint dispersion. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L133) |
| AverageEndpointDistanceFromCentroid2\* | The average distance of a streamline endpoint within the left/inferior/posterior-most group from the centroid of this group.  Computed as the euclidean distance from the average coordinate of this group.  Considered to be a measure of streamline endpoint dispersion. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L149) |
| stdevOfEndpointDistanceFromCentroid1\* | The standard deviation of the distances of a streamline endpoint within the right/superior/anterior-most group from the centroid of this group.  Computed as the euclidean distance from the average coordinate of this group. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L134) |
| stdevEndpointDistanceFromCentroid2\* | The standard deviation of the distances of a streamline endpoint within the left/inferior/posterior-most group from the centroid of this group.  Computed as the euclidean distance from the average coordinate of this group. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L150) |
| MidpointDensity | The density of the midpoint mask associated for this tract.  Computes the number of midpoints per occupied (by midpoints) 1mm cubic voxel. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L157) |
| averageMidpointDistanceFromCentroid | The average distance of a streamline midpoint from the centroid of this group.  Computed as the euclidean distance from the average coordinate of this group. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L165) |
| stDevOfMidpointDistanceFromCentroid | The standard deviation of the distances of a streamline midpoint from the centroid of this group.  Computed as the euclidean distance from the average coordinate of this group. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L166) |
| TotalVolumeProportion | The proportion of the total white matter volume occupied by this tract.  Intended to control for variability in brain size. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantAllWMNorm.m#L53) |
| TotalCountProportion | The proportion of the total number of streamlines associated with tract.  Intended to control for variability in input tractogram size (i.e. whole brain streamline total). |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantAllWMNorm.m#L54) |
| TotalWiringProportion | The proportion of the total streamline length accounted for by streamlines associated with this tract. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantAllWMNorm.m#L55) |

\*endpoint membership in either the left/inferior/posterior-most (LIP) or right/superior/anterior-most (RAS) group is determined by the following process:

1. computing the primary dimension of traversal for a tract (i.e. left-right, inferior-superior, anterior-posterior) by determining which dimension exhibits the greatest displacement for the given tract.
2. Once this dimension has been determined, the relevant coordinates (x, y, or z) of the streamline&#39;s endpoints are checked to determine determine LIP or RAS membership

</details>

<details>
<summary><b>image.svg</b> plots</summary>

| **Figure title** | **X axis quantity** | **Y axis quantity** | **Description** |
| --- | --- | --- | --- |
| &quot;Normalized WBFG &amp; NonZero Weighted Stream Count Comparison&quot; | streamline length (in mm) | whole brain proportion of the streamline count | This plot depicts the proportion of streamlines (out of all those in the whole brain fiber group) that are of a certain length. The dark blue line corresponds to the input whole brain tractogram, while the light blue line corresponds to the line of best fit using an exponential model (y=a^(b\*x)).  The relevant parameters can be noted in the grey column on the left. |
| &quot;Cumulative proportion of fibers in connectome, by length&quot; | streamline length (in mm) | total proportion of streamlines | This plot depicts the total proportion of streamlines that are equal to or less than the specified length. |
| &quot;Classified Streamline proportion Comparison:  WBFG &amp; Surviving&quot; | streamline length (in mm) | total proportion of classified streamlines | Similar to the first plot, but only computes proportions for classified streamlines.  Proportion is relative to all classified streamlines. |
| &quot;Log10 of proportion of connectome streamlines in tract&quot; | tract names | log10 of the percentage of the total number of streamlines in whole brain fiber group | For all identified tracts in the input white matter classification (WMC) structure this plot indicates the percentage (scaled in log10) of all streamlines in the whole brain fiber group that are associated with this specific tract.For tracts which have left and right variants, left is plotted in blue and right is plotted in orange.  For tracts which do not have left and right variants (i.e. are interhemispheric) the default color is blue. |
| &quot;Proportion of white matter volume occupied by tract&quot; | tract names | Portion of white matter occupied (by percent) | For all identified tracts in the input white matter classification (WMC) structure this plot indicates the percentage of the total white matter volume occupied by each respective tract. For tracts which have left and right variants, left is plotted in blue and right is plotted in orange.  For tracts which do not have left and right variants (i.e. are interhemispheric) the default color is blue. |

</details>

<details>
<summary><b>tractomeResultStruc.mat</b> fields not in tractmeasures.csv</summary>

Fields of `results.WBFG` are computed across all streamlines of the whole-brain fibre group, except `tractStats`, described in the second table.

| **Fieldname (within results.WBFG)** | **Description** |
| --- | --- |
| avgefficiencyRat(average efficiency ratio) | This quantity is the _average efficiency ratio_ for all streamlines in the entire whole brain fiber group.  For a given streamline this is computed by dividing the streamline&#39;s _displacement_ (see description in tractmeasures.csv section) by that same streamline&#39;s length.  Thus this value approaches 1 as a streamline approaches being shaped like a straight line, and approaches 0 as a streamline approaches being shaped like a full circuit. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/ConnectomeTestQ_v2.m#L49) |
| stDevefficiencyRat(standard deviation of efficiency ratio) | This quantity is the _standard deviation of the efficiency ratio_ for all streamlines in the entire whole brain fiber group. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L71) |
| avgAsymRat(average asymmetry ratio) | This quantity is the _average asymmetry ratio_ for all streamlines in the entire whole brain fiber group.  In essence, for a given streamline, it is the square of the differences between the efficiency ratios for the respective halves of a streamline.  Thus, as a streamline&#39;s _asymmetry ratio_ approaches the maximum of 1, it indicates that one half has an efficiency ratio of 0, and resembles a full circuit, while the other half has an efficiency ratio of 1 and resembles a straight line.  On the other hand, as a streamline's _asymmetry ratio_ approaches the minimum of 0, the difference between the two halves' efficiency ratios approach 0, and are thus presumed to more closely resemble one another, at least within the domain of wiring efficiency. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/ConnectomeTestQ_v2.m#L52) |
| stdDevAsymRat(standard deviation of asymmetry ratio) | This quantity is the _standard deviation of the asymmetry ratio_ for all streamlines in the entire whole brain fiber group. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L65) |
| volLengthRatio(volume length ratio) | The ratio of the total wiring length for all streamlines in the whole brain fiber group to the total white matter volume of the whole brain fiber group (i.e. in this case, simply the total volume of the white matter) |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/92c4c1aa2bedd569e696ef1476eb979567849c9f/wma_quantTract.m#L96) |
| lengthCounts  | A 1x299 long vector wherein the ith entry corresponds to the number of streamlines such that i≤[streamline length]<i+1 |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/92c4c1aa2bedd569e696ef1476eb979567849c9f/wma_quantTract.m#L99) |
| LengthProps | A 1x299 long vector wherein the ith entry corresponds to the proportion of the total number of streamlines such that i≤[streamline length]<i+1 |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/5453f056df5f43c6a12c57fe76eabfd7eba3705c/wma_quantWBFG.m#L52) |
| LengthData | The computed length for each streamline in the whole brain fiber group. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/5453f056df5f43c6a12c57fe76eabfd7eba3705c/wma_quantWBFG.m#L62) |
| tractStats | A 1 by N cell structure, wherein each cell entry corresponds to the output of a quantitative analysis **for a specific tract**.  The ith entry in this cell structure corresponds to the tract specified in the ith entry in the classification.names field of the associated classification structure. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantAllWMNorm.m#L46) |

Fields of `results.WBFG.tractStats{1,i}` describe the tract named in the ith entry of `classification.names`. Quantities already described above characterise the specific tract here.

| **Fieldname (within results.WBFG.tractStats{1,i})** | **Description** |
| --- | --- |
| endpointVolume1 | The volume of the endpoint mask associated with the right/superior/anterior-most (whichever is most appropriate for this tract) collection of terminations for this tract. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L123) |
| endpointVolume2 | The volume of the endpoint mask associated with the left/inferior/posterior-most (whichever is most appropriate for this tract) collection of terminations for this tract. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L139) |
| avgEndpointCoord1 | The centroid of the endpoints associated with the  right/superior/anterior-most end of this tract.  Computed as the average coordinate of this group. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L124) |
| avgEndpointCoord2 | The centroid of the endpoints associated with the  left/inferior/posterior-most end of this tract.  Computed as the average coordinate of this group. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L140) |
| midpointVolume | The volume of the endpoint mask associated with the midpoints of streamlines associated with this tract. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L155) |
| avgMidpointCoord | The centroid of the midpoints of streamlines associated with this tract.  Computed as the average coordinate of this group. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantTract.m#L156) |
| results.WBFG.tractStats{1,i}.endpointVolume1Prop | The proportion of the total white matter volume occupied by this endpoint mask associated with the right/superior/anterior-most (whichever is most appropriate for this tract) collection of terminations for this tract.  Intended to control for variability in brain size. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantAllWMNorm.m#L57) |
| results.WBFG.tractStats{1,i}.endpointVolume2Prop | The proportion of the total white matter volume occupied by this endpoint mask associated with the left/inferior/posterior-most (whichever is most appropriate for this tract) collection of terminations for this tract.  Intended to control for variability in brain size. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantAllWMNorm.m#L58) |
| results.WBFG.tractStats{1,i}.midpointVolumeProp | The proportion of the total white matter volume occupied by this endpoint mask associated with the midpoints of streamlines associated with this tract.  Intended to control for variability in brain size. |
|   | [Code Link](https://github.com/DanNBullock/wma_tools/blob/498706fb662a0af8ad431f297d8e2fd548fcca56/Analysis/wma_quantAllWMNorm.m#L59) |

</details>

## Troubleshooting

- **`mismatch between classification structure and input fibergroup`**: the classification was made from a different tractogram (different streamline count). Use the classification generated from this exact tractogram.

## Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Tractography quality check. brainlife.io App. [doi:10.25663/brainlife.app.189](https://doi.org/10.25663/brainlife.app.189)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)
- Bullock et al. Associative white matter connecting the dorsal and ventral posterior human cortex. *Brain Structure and Function* 224:2631-2660 (2019). [doi:10.1007/s00429-019-01907-8](https://doi.org/10.1007/s00429-019-01907-8)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)

## Authors

- Franco Pestilli (project director)
- Daniel Bullock ([@DanNBullock](https://github.com/DanNBullock))

**Contributors:** Soichi Hayashi ([@soichih](https://github.com/soichih)), Brad Caron

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## License

[MIT](LICENSE).
