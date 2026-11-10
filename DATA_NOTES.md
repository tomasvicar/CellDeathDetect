# Notes on the data

Notes on Zenodo record 10.5281/zenodo.2601562.

- The original acquisitions were trimmed before annotation and processing: the first 9 and the last 5 frames were removed, because the cells were still settling at the start of imaging and because of missing frames at the end. DU145 bp_1 therefore contains acquired frames 10–475 of 480. The trimming can be seen in the tracking code on the `tracking` branch. All subsequent annotation and processing used these shortened sequences, which are the deposited image stacks.
- `death_frame` values in the `labels_*.xlsx` workbooks are one-based indices on the deposited stacks. The annotation tool (a MATLAB script) allowed values outside the recorded range to be stored, so values can lie beyond the end or before the start of a recording. We consider this the origin of 473 for DU145 bp_1, cell 39, and of the 13 values above the stack length among the 2155 records. Such a value may mark an event visible at the end of the sequence and should not be read as an exact event frame.
- Apart from this trimming, no frames were omitted, reordered or time-reversed in the deposited sequences. In acquisitions recorded in two parts, no frames were dropped at the join, although the interval between the parts differs from the usual 3 minutes (approximately 2.5 to 13.5 minutes).
