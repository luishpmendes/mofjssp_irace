#!/bin/bash

id="27"

mkdir -p old/$id

mkdir -p old/$id/best_solutions_snapshots
cp best_solutions_snapshots/*.mp4 old/$id/best_solutions_snapshots

mkdir -p old/$id/hvr
cp hvr/*.png old/$id/hvr

mkdir -p old/$id/hvr_snapshots
cp hvr_snapshots/*.png old/$id/hvr_snapshots
cp hvr_snapshots/*.mp4 old/$id/hvr_snapshots

mkdir -p old/$id/nigd_plus
cp nigd_plus/*.png old/$id/nigd_plus

mkdir -p old/$id/nigd_plus_snapshots
cp nigd_plus_snapshots/*.png old/$id/nigd_plus_snapshots
cp nigd_plus_snapshots/*.mp4 old/$id/nigd_plus_snapshots

mkdir -p old/$id/metrics
cp metrics/* old/$id/metrics

mkdir -p old/$id/metrics_snapshots
cp metrics_snapshots/* old/$id/metrics_snapshots

mkdir -p old/$id/num_elites_snapshots
cp num_elites_snapshots/*.png old/$id/num_elites_snapshots

mkdir -p old/$id/num_fronts_snapshots
cp num_fronts_snapshots/*.png old/$id/num_fronts_snapshots

mkdir -p old/$id/num_non_dominated_snapshots
cp num_non_dominated_snapshots/*.png old/$id/num_non_dominated_snapshots

mkdir -p old/$id/pareto
cp pareto/*.png old/$id/pareto

mkdir -p old/$id/populations_snapshots
cp populations_snapshots/*.mp4 old/$id/populations_snapshots

mkdir -p old/$id/statistics
cp statistics/* old/$id/statistics

cp metrics_stats.txt old/$id


rm -rf best_solutions_snapshots
git rm -rf best_solutions_snapshots

rm -rf hvr
git rm -rf hvr

rm -rf hvr_snapshots
git rm -rf hvr_snapshots

rm -rf nigd_plus
git rm -rf nigd_plus

rm -rf nigd_plus_snapshots
git rm -rf nigd_plus_snapshots

rm -rf num_elites_snapshots
git rm -rf num_elites_snapshots

rm -rf num_fronts_snapshots
git rm -rf num_fronts_snapshots

rm -rf num_non_dominated_snapshots
git rm -rf num_non_dominated_snapshots

rm -rf pareto
git rm -rf pareto

rm -rf populations_snapshots
git rm -rf populations_snapshots

rm -rf solutions
git rm -rf solutions

git rm metrics_stats.txt

git rm log*.txt
