#   This is the most basic QSUB file needed for this cluster.
#   Further examples can be found under /share/apps/examples
#   Most software is NOT in your PATH but under /share/apps
#
#   For further info please read http://hpc.cs.ucl.ac.uk
#   For cluster help email cluster-support@cs.ucl.ac.uk
#
#   NOTE hash dollar is a scheduler directive not a comment.


# These are flags you must include - Two memory and one runtime.
# Runtime is either seconds or hours:min:sec

#$ -l tmem=2G
#$ -l h_vmem=2G
#$ -l h_rt=24:0:0 

#These are optional flags but you probably want them in all jobs

#$ -S /bin/bash
#$ -t 1-100
####### -j y
#$ -N polegon
#$ -o /home/sisodiya/out/std2/singer2

### Script to generate POLEGON trees files from SINGER inferred trees output for each iteration of each rep for a given set of selection/recombination/mutation/timing parameters

#respecifying rep number/job number
uptaskid=$((${SGE_TASK_ID}))
#uptaskid=$((${SGE_TASK_ID} + 500))

#source appropriate version of python for polegon (requires tskit module)
source /share/apps/source_files/python/python-3.8.5.source

#specifying parameters, (batch options are '_' and '_extra_'), and (rat is recombination/mutation rate)
batch=_extra_
rec=7
mut=8
rat=10
mut2=1e-$mut
sel=0.01
gen=160000

#run polegon on singer output for each of 100 iterations, use standard polegon settings for each iteration
#rm to remove the composite files for each polegon iteration

for i in {0..99}; do
    /share/apps/polegon-0.1.3/polegon_master -m $mut2 -input /SAN/ugi/balancing_trees/singer/data/OD_N20k_r1e-${rec}_grid0.01${batch}m1e-${mut}/s${sel}_${gen}/r${uptaskid}/output_s${sel}-${sel}_h0_r${uptaskid}_c${gen}_spl100.out.inftr_$i -output /SAN/ugi/balancing_trees/singer/data/OD_N20k_r1e-${rec}_grid0.01${batch}m1e-${mut}/s${sel}_${gen}/r${uptaskid}/output_s${sel}-${sel}_h0_r${uptaskid}_c${gen}_spl100.out.inftr_$i.pgon -num_samples 100 -thin 10 -scaling_rep 5
    rm /SAN/ugi/balancing_trees/singer/data/OD_N20k_r1e-${rec}_grid0.01${batch}m1e-${mut}/s${sel}_${gen}/r${uptaskid}/output_s${sel}-${sel}_h0_r${uptaskid}_c${gen}_spl100.out.inftr_${i}_nodes.txt
    rm /SAN/ugi/balancing_trees/singer/data/OD_N20k_r1e-${rec}_grid0.01${batch}m1e-${mut}/s${sel}_${gen}/r${uptaskid}/output_s${sel}-${sel}_h0_r${uptaskid}_c${gen}_spl100.out.inftr_${i}_branches.txt
    rm /SAN/ugi/balancing_trees/singer/data/OD_N20k_r1e-${rec}_grid0.01${batch}m1e-${mut}/s${sel}_${gen}/r${uptaskid}/output_s${sel}-${sel}_h0_r${uptaskid}_c${gen}_spl100.out.inftr_${i}_muts.txt
    rm /SAN/ugi/balancing_trees/singer/data/OD_N20k_r1e-${rec}_grid0.01${batch}m1e-${mut}/s${sel}_${gen}/r${uptaskid}/output_s${sel}-${sel}_h0_r${uptaskid}_c${gen}_spl100.out.inftr_${i}_new_nodes.txt
done




