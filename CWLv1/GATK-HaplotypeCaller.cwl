#!/usr/bin/env cwl-runner

#$namespaces:
#  dct: http://purl.org/dc/terms/
#  foaf: http://xmlns.com/foaf/0.1/
#  doap: http://usefulinc.com/ns/doap#
#  adms: http://www.w3.org/ns/adms#
#  dcat: http://www.w3.org/ns/dcat#
#
#$schemas:
#- http://dublincore.org/2012/06/14/dcterms.rdf
#- http://xmlns.com/foaf/spec/20140114.rdf
#- http://usefulinc.com/ns/doap#
#- http://www.w3.org/ns/adms#
#- http://www.w3.org/ns/dcat.rdf
#
cwlVersion: v1.0
class: CommandLineTool

#adms:includedAsset:
#  doap:name: GATK
#  doap:description: 'The Genome Analysis Toolkit or GATK is a software package for
#    analysis of high-throughput sequencing data, developed by the Data Science and
#    Data Engineering group at the Broad Institute.  The toolkit offers a wide variety
#    of tools, with a primary focus on variant discovery and genotyping as well as
#    strong emphasis on data quality assurance. Its robust architecture, powerful processing
#    engine and high-performance computing features make it capable of taking on projects
#    of any size. http://broadinstitute.github.io/picard/command-line-overview.html#MergeSamFiles
#
#    '
#  doap:homepage: https://www.broadinstitute.org/gatk/
#  doap:repository:
#  - class: doap:GitRepository
#    doap:location: https://github.com/broadgsa/gatk.git
#  doap:release:
#  - class: doap:Version
#    doap:revision: '3.4'
#  doap:license: mixed licensing model
#  doap:category: commandline tool
#  doap:programming-language: JAVA
#  doap:developer:
#  - class: foaf:Organization
#    foaf:name: Broad Institute
#doap:name: GATK-IndelRealigner.cwl
#dcat:downloadURL: https://github.com/common-workflow-language/workflows/blob/master/tools/GATK-IndelRealigner.cwl
#dct:creator:
#- class: foaf:Organization
#  foaf:name: THE UNIVERSITY OF MELBOURNE
#  foaf:member:
#  - class: foaf:Person
#    id: farah@student.unimelb.edu.au
#    foaf:name: Farah Zaib Khan
#    foaf:mbox: mailto:farahk@student.unimelb.edu.au
#  - class: foaf:Person
#    id: kanwal@student.unimelb.edu.au
#    foaf:name: Sehrish Kanwal
#    foaf:mbox: mailto:skanwal@student.unimelb.edu.au
#doap:maintainer:
#- class: foaf:Organization
#  foaf:name: THE UNIVERSITY OF MELBOURNE
#  foaf:member:
#  - class: foaf:Person
#    id: farahk@student.unimelb.edu.au
#    foaf:name: Farah Zaib Khan
#    foaf:mbox: mailto:farahk@student.unimelb.edu.au
#  - class: foaf:Person
#    id: skanwal@student.unimelb.edu.au
#    foaf:name: Sehrish Kanwal
#    foaf:mbox: mailto:skanwal@student.unimelb.edu.au
requirements:
#- $import: envvar-global.yml
- $import: GATK-docker.yml


inputs: # position 0, for java args, 1 for the jar, 2 for the tool itself
  max_alternate_alleles:
    type: int?
    inputBinding:
      position: 2
      prefix: --max_alternate_alleles
    doc: Maximum number of alternate alleles to genotype
  reference:
    type: File
    inputBinding:
      position: 2
      prefix: -R
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict
  activeProbabilityThreshold:
    type: double?
    inputBinding:
      position: 2
      prefix: --activeProbabilityThreshold
    doc: Threshold for the probability of a profile state being active.
  alleles:
    type: string[]?
    inputBinding:
      position: 2

    doc: The set of alleles at which to genotype when --genotyping_mode is GENOTYPE_GIVEN_ALLELES
  outputfile_HaplotypeCaller:
    type: string?
    inputBinding:
      position: 2
      prefix: -o
    doc: name of the output file from HaplotypeCaller
  stand_emit_conf:
    type: double?
    inputBinding:
      position: 2
      prefix: --standard_min_confidence_threshold_for_emitting
    doc: The minimum phred-scaled confidence threshold at which variants should be
      emitted (and filtered with LowQual if less than the calling threshold)
  kmerSize:
    type: int[]?
    inputBinding:
      position: 2

    doc: Kmer size to use in the read threading assembler
  minDanglingBranchLength:
    type: int?
    inputBinding:
      position: 2
      prefix: --minDanglingBranchLength
    doc: Minimum length of a dangling branch to attempt recovery
  bandPassSigma:
    type: double?
    inputBinding:
      position: 2
      prefix: --consensus
    doc: The sigma of the band pass filter Gaussian kernel; if not provided defaults
      to Walker annotated default
  maxReadsInRegionPerSample:
    type: int?
    inputBinding:
      position: 2
      prefix: --maxReadsInRegionPerSample
    doc: Maximum reads in an active region
  dontIncreaseKmerSizesForCycles:
    type: boolean?
    inputBinding:
      position: 2
      prefix: --dontIncreaseKmerSizesForCycles
    doc: Disable iterating over kmer sizes when graph cycles are detected
  dbsnp:
    type: File
    inputBinding:
      position: 2
      prefix: --dbsnp
    doc: latest_dbsnp.vcf set of known indels
  globalMAPQ:
    type: int?
    inputBinding:
      position: 2
      prefix: --phredScaledGlobalReadMismappingRate
    doc: The global assumed mismapping rate for reads
  java_arg:
    type: string
    default: -Xmx4g
    inputBinding:
      position: 0

  min_base_quality_score:
    type: int?
    inputBinding:
      position: 2
      prefix: --min_base_quality_score
    doc: Minimum base quality required to consider a base for calling
  excludeAnnotation:
    type: string[]?
    inputBinding:
      position: 2

    doc: One or more specific annotations to exclude
  allowNonUniqueKmersInRef:
    type: boolean?
    inputBinding:
      position: 2
      prefix: --allowNonUniqueKmersInRef
    doc: Allow graphs that have non-unique kmers in the reference
  group:
    type: string[]?
    inputBinding:
      position: 2

    doc: Input prior for calls
  pcr_indel_model:
    type: string?
    inputBinding:
      position: 2
      prefix: --pcr_indel_model
    doc: The PCR indel model to use
  bamOutput:
    type: File?
    inputBinding:
      position: 2
      prefix: --bamOutput
    doc: File to which assembled haplotypes should be written
  stand_call_conf:
    type: double?
    inputBinding:
      position: 2
      prefix: --standard_min_confidence_threshold_for_calling
    doc: The minimum phred-scaled confidence threshold at which variants should be
      called
  activeRegionExtension:
    type: int?
    inputBinding:
      position: 2
      prefix: --activeRegionExtension
    doc: The active region extension; if not provided defaults to Walker annotated
      default
  activeRegionOut:
    type: File?
    inputBinding:
      position: 2
      prefix: --activeRegionOut
    doc: Output the active region to this IGV formatted file
  useAllelesTrigger:
    type: boolean?
    inputBinding:
      position: 2
      prefix: --useAllelesTrigger
    doc: Use additional trigger on variants found in an external alleles file
  forceActive:
    type: boolean?
    inputBinding:
      position: 2
      prefix: --forceActive
    doc: If provided, all bases will be tagged as active
  sample_name:
    type: string?
    inputBinding:
      position: 2
      prefix: --sample_name
    doc: Use additional trigger on variants found in an external alleles file
  useFilteredReadsForAnnotations:
    type: boolean?
    inputBinding:
      position: 2
      prefix: --useFilteredReadsForAnnotations
    doc: Use the contamination-filtered read maps for the purposes of annotating variants
  disableOptimizations:
    type: boolean?
    inputBinding:
      position: 2
      prefix: --disableOptimizations
    doc: Dont skip calculations in ActiveRegions with no variants
  minPruning:
    type: int?
    inputBinding:
      position: 2
      prefix: --minPruning
    doc: Minimum support to not prune paths in the graph
  activeRegionMaxSize:
    type: int?
    inputBinding:
      position: 2
      prefix: --activeRegionMaxSize
    doc: The active region maximum size; if not provided defaults to Walker annotated
      default
  output_mode:
    type: string?
    inputBinding:
      position: 2
      prefix: --output_mode
    doc: The PCR indel model to use
  annotateNDA:
    type: boolean?
    inputBinding:
      position: 2
      prefix: --annotateNDA
    doc: If provided, we will annotate records with the number of alternate alleles
      that were discovered (but not necessarily genotyped) at a given site
  ERCIS:
    type: int?
    inputBinding:
      position: 2
      prefix: --indelSizeToEliminateInRefModel
    doc: The size of an indel to check for in the reference model
  GVCFGQBands:
    type: int[]?
    inputBinding:
      position: 2

    doc: Input prior for calls
  allSitePLs:
    type: boolean?
    inputBinding:
      position: 2
      prefix: --allSitePLs
    doc: Annotate all sites with PLs
  numPruningSamples:
    type: int?
    inputBinding:
      position: 2
      prefix: --numPruningSamples
    doc: Number of samples that must pass the minPruning threshold
  gcpHMM:
    type: int?
    inputBinding:
      position: 2
      prefix: --gcpHMM
    doc: Flat gap continuation penalty for use in the Pair HMM
  contamination:
    type: File?
    inputBinding:
      position: 2
      prefix: --contamination_fraction_to_filter
    doc: Tab-separated File containing fraction of contamination in sequencing data
      (per sample) to aggressively remove. Format should be "" (Contamination is double)
      per line; No header.
  graphOutput:
    type: File?
    inputBinding:
      position: 2
      prefix: --graphOutput
    doc: Write debug assembly graph information to this file
  dontTrimActiveRegions:
    type: boolean?
    inputBinding:
      position: 2
      prefix: --dontTrimActiveRegions
    doc: If specified, we will not trim down the active region from the full region
      (active + extension) to just the active interval for genotyping
  annotation:
    type: string[]?
    inputBinding:
      position: 2

    doc: One or more specific annotations to apply to variant calls
  bamWriterType:
    type: string?
    inputBinding:
      position: 2
      prefix: --bamWriterType
    doc: Which haplotypes should be written to the BAM.
  genotyping_mode:
    type: string?
    inputBinding:
      position: 2
      prefix: --genotyping_mode
    doc: The --genotyping_mode argument is an enumerated type (GenotypingOutputMode),
      which can have one of the following values
  activityProfileOut:
    type: File?
    inputBinding:
      position: 2
      prefix: --activityProfileOut
    doc: Output the raw activity profile results in IGV format
  input_prior:
    type: double[]?
    inputBinding:
      position: 2

    doc: Input prior for calls
  inputBam_HaplotypeCaller:
    type: File
    inputBinding:
      position: 2
      prefix: -I
    secondaryFiles:
    - ^.bai
    doc: bam file produced after printReads
  indel_heterozygosity:
    type: double?
    inputBinding:
      position: 2
      prefix: --indel_heterozygosity
    doc: Heterozygosity for indel calling
  emitRefConfidence:
    type: string?
    inputBinding:
      position: 2
      prefix: --emitRefConfidence
    doc: Mode for emitting reference confidence scores
  consensus:
    type: boolean?
    inputBinding:
      position: 2
      prefix: --consensus
    doc: Print out very verbose debug information about each triggering active region
  heterozygosity:
    type: double?
    inputBinding:
      position: 2
      prefix: --heterozygosity
    doc: Heterozygosity for indel calling
  minReadsPerAlignmentStart:
    type: int?
    inputBinding:
      position: 2
      prefix: --minReadsPerAlignmentStart
    doc: Minimum number of reads sharing the same alignment start for each genomic
      location in an active region
  sample_ploidy:
    type: int?
    inputBinding:
      position: 2
      prefix: --sample_ploidy
    doc: Use additional trigger on variants found in an external alleles file
  debug:
    type: boolean?
    inputBinding:
      position: 2
      prefix: --debug
    doc: Print out very verbose debug information about each triggering active region
  doNotRunPhysicalPhasing:
    type: boolean?
    inputBinding:
      position: 2
      prefix: --doNotRunPhysicalPhasing
    doc: As of GATK 3.3, HaplotypeCaller outputs physical (read-based) information
      (see version 3.3 release notes and documentation for details). This argument
      disables that behavior.
  comp:
    type: string[]?
    inputBinding:
      position: 2

    doc: comp binds reference ordered data. This argument supports ROD files of the
      following types BCF2, VCF, VCF3
  maxNumHaplotypesInPopulation:
    type: int?
    inputBinding:
      position: 2
      prefix: --maxNumHaplotypesInPopulation
    doc: Maximum number of haplotypes to consider for your population
outputs:
  output_haplotypeCaller:
    type: File
    outputBinding:
      glob: $(inputs.outputfile_HaplotypeCaller)

arguments:
- valueFrom: /tmp/job_tmp
  position: 0
  separate: false
  prefix: -Djava.io.tmpdir=
- valueFrom: /home/biodocker/bin/GenomeAnalysisTK-2.8-1-g932cd3a/GenomeAnalysisTK.jar
  position: 1
  prefix: -jar
- valueFrom: HaplotypeCaller
  position: 2
  prefix: -T
baseCommand: [java]
doc: |
  GATK-RealignTargetCreator.cwl is developed for CWL consortium
  Call germline SNPs and indels via local re-assembly of haplotypes


