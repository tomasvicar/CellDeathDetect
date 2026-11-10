# Annotation codebook for Zenodo 10.5281/zenodo.2601562

Prepared in November 2026 from the original annotation workbooks. It was not written at the time of annotation. Numeric codes are defined in the Zenodo record; the meaning of the original annotation terms is derived from how they were used.

## `death_frame`

One-based frame index on the deposited image stacks. Annotation used the shortened sequences. The time of death was marked from the propidium iodide signal. The annotation tool (a MATLAB script) allowed values outside the recorded range to be stored, so values can lie beyond the end or before the start of a recording. We consider this the origin of the 13 values above the stack length. Such a value may mark an event visible at the end of the sequence and should not be read as an exact event frame.

## Numeric codes in `death_type`

| Code | Meaning |
|---|---|
| 1 | apoptosis |
| 2 | necrosis (primary lytic cell death in the final paper) |
| 3 | ambiguous/surviving; a pooled class that is not limited to surviving cells |

## Original annotation terms

| Term | Meaning | Deposited as |
|---|---|---|
| `apo`, `apo!` | apoptosis | type 1 when a frame was given, otherwise type 3 |
| `ncr`, `necr` | necrotic/lytic cell death | type 2 |
| `apo/ncr`, `ncr/apo` | death at the given frame, type undecided | type 3 with a frame |
| `ziv` | alive | type 3, normally without a frame |
| `torzo` | cell fragment or partial mask | type 3 without a frame |
| `chyba`, `chyba sgmnt`, `chybna sgmn` | error, usually in segmentation | type 3 without a frame |
| `nevim` | unknown | type 3 without a frame |
| `nepraskla` | membrane rupture not observed | noted alongside the annotation |

A blank entry does not mean that the cell was alive.

Type 3 alone does not define a survival or censoring status; a missing frame should not automatically be treated as a right-censored survivor.

Type 3 is not only "surviving". A type 3 record with a numeric `death_frame` is, apart from one record annotated as alive (PNT1A_do_4, cell 49), a death with a known position whose type could not be identified.
