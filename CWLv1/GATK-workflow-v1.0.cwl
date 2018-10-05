#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

inputs:
  reference: File
  reads: File[]
  output_markDuplicates: string
  metricsFile_markDuplicates: string
  readSorted_markDuplicates: boolean
  removeDuplicates_markDuplicates: boolean
  createIndex_markDuplicates: boolean
  output_RealignTargetCreator: string
  reference: File
  known_variant_db: File[]
  output_IndelRealigner: string
  output_BaseRecalibrator: string
  covariate: string[]
  output_PrintReads: string
  output_HaplotypeCaller: string
  dbsnp: File
    
outputs:
  unsorted_alignments:
    type: File
    outputSource: align/alignments
    
  unsorted_alignments_bam:
    type: File
    outputSource: sam-to-bam/binary_alignments
    
  sorted-alignments:
    type: File
    outputSource: sort-alignments/sorted_alignments
    
  mark_Duplicates:
    type: File
    outputSource: markDuplicates/markDups_output
    
  realign_Target:
    type: File
    outputSource: realignTarget/output_realignTarget
    
  indel_Realigner:
    type: File
    outputSource: indelRealigner/output_indelRealigner
    
  base_Recalibrator:
    type: File
    outputSource: baseRecalibrator/output_baseRecalibrator
    
  print_Reads:
    type: File
    outputSource: printReads/output_printReads
    
  haplotype_Caller:
    type: File
    outputSource: haplotypeCaller/output_haplotypeCaller

steps:
  align:
    run: bwa-mem.cwl 
    in:
      reference: reference
      reads: reads
    out: [alignments]
    
  sam-to-bam:
    run: samtools-sam-to-bam.cwl
    in:
      input: align/alignments
    out: [binary_alignments]
    
  sort-alignments:
    run: samtools-sort.cwl
    in:
      input: sam-to-bam/binary_alignments    
    out: [sorted_alignments]
    
  markDuplicates:
    run: picard-MarkDuplicates.cwl
    in:
      outputFileName_markDups: output_markDuplicates
      inputFileName_markDups: sort-alignments/sorted_alignments
      metricsFile: metricsFile_markDuplicates
      readSorted: readSorted_markDuplicates
      removeDuplicates: removeDuplicates_markDuplicates
      createIndex: createIndex_markDuplicates
      
    out: [markDups_output]
    
  realignTarget:
    run: GATK-RealignTargetCreator.cwl
    in:
      outputfile_realignTarget: output_RealignTargetCreator
      inputBam_realign: markDuplicates/markDups_output
      reference: reference
      known: known_variant_db
      
    out: [output_realignTarget]
  
  indelRealigner:
    run: GATK-IndelRealigner.cwl
    in:
      outputfile_indelRealigner: output_IndelRealigner
      inputBam_realign: markDuplicates/markDups_output
      intervals: realignTarget/output_realignTarget
      reference: reference
      known: known_variant_db
    
    out: [output_indelRealigner]
    
  baseRecalibrator:
    run: GATK-BaseRecalibrator.cwl
    in:
      outputfile_BaseRecalibrator: output_BaseRecalibrator
      inputBam_BaseRecalibrator: indelRealigner/output_indelRealigner
      reference: reference
      covariate: covariate
      knownSites: known_variant_db
      
    out: [output_baseRecalibrator]
    
  printReads:
    run: GATK-PrintReads.cwl
    in:
      outputfile_printReads: output_PrintReads
      inputBam_printReads: indelRealigner/output_indelRealigner
      reference: reference
      input_baseRecalibrator: baseRecalibrator/output_baseRecalibrator
      
    out: [output_printReads] 
    
  haplotypeCaller:
    run: GATK-HaplotypeCaller.cwl
    in:
      outputfile_HaplotypeCaller: output_HaplotypeCaller
      inputBam_HaplotypeCaller: printReads/output_printReads
      reference: reference 
      dbsnp: dbsnp
      
    out: [output_haplotypeCaller]
