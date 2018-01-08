while IFS=$'\t' read vcf sample; do
echo $vcf
echo $sample
tabix -R tabixregiontest.txt -h $vcf > /mnt/d/output/$sample.tabix.vcf
bcftools norm -d any /mnt/d/output/$sample.tabix.vcf -o /mnt/d/output/$sample.bcftools.vcf
sed -i -e "s/$sample/$sample.phased/g" /mnt/d/output/$sample.bcftools.vcf
#java -jar /mnt/c/Linux/PhasingAstrolabe/Beagle/conform-gt.jar gt=/mnt/d/output/$sample.bcftools.vcf chrom=12:21283272-21392123 ref=/mnt/c/Linux/PhasingAstrolabe/Beagle/slco1b1.ref.vcf match=POS out=/mnt/d/output/$sample.conform
java -jar /mnt/c/Linux/PhasingAstrolabe/Beagle/beagle.08Jun17.d8b.jar gt=/mnt/d/output/$sample.bcftools.vcf ref=/mnt/c/Linux/PhasingAstrolabe/Beagle/slco1b1.ref.vcf map=/mnt/c/Linux/PhasingAstrolabe/Beagle/plink.chr12.GRCh37.map out=/mnt/d/output/$sample.phased chrom=12:21283272-21392123 impute=false
bgzip -d /mnt/d/output/$sample.phased.vcf.gz

python3.6 /mnt/c/Linux/PhasingAstrolabe/bin/PhasingAstrolabe.py -vcf /mnt/d/output/$sample.phased.vcf -out /mnt/d/output/$sample.haplotype

done < /mnt/c/Linux/Samples.txt