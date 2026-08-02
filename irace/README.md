# iRace Tuning for MOFJSSP Solvers

This folder contains iRace configurations for **offline algorithm configuration** (parameter tuning) of multi-objective metaheuristics applied to the Multi-Objective Flexible Job Shop Scheduling Problem (MOFJSSP).

## Supported Algorithms

| Algorithm | Scenario File | Parameters File | Target Runner |
|-----------|---------------|-----------------|---------------|
| NSGA-II   | `nsga2-scenario.txt` | `nsga2-parameters.txt` | `nsga2-tunner.sh` |
| NSGA-III  | `nsga3-scenario.txt` | `nsga3-parameters.txt` | `nsga3-tunner.sh` |
| NS-BRKGA  | `nsbrkga-scenario-stage<N>.txt` | `nsbrkga-parameters-stage<N>.txt` | `nsbrkga-tunner-stage<N>.sh` (N = 1..6) |
| MOEA/D    | `moead-scenario.txt` | `moead-parameters.txt` | `moead-tunner.sh` |
| NSPSO     | `nspso-scenario.txt` | `nspso-parameters.txt` | `nspso-tunner.sh` |
| IHS       | `ihs-scenario.txt` | `ihs-parameters.txt` | `ihs-tunner.sh` |
| MHACO     | `mhaco-scenario.txt` | `mhaco-parameters.txt` | `mhaco-tunner.sh` |

## NS-BRKGA Ablation Study

A six-stage ablation study progressively enables NS-BRKGA mechanisms to measure their individual contributions. Each stage is a full iRace tuning run with a dedicated parameter space, scenario, and target runner.

### Stage Ladder

| Stage | Features Enabled | New Parameters | Disabled |
|-------|-----------------|----------------|----------|
| **1** | Vanilla baseline — single population, fixed elite size | `population_size_factor`, `elites_percentage`, `mutation_probability`, `mutation_distribution`, `num_total_parents`, `num_elite_parents`, `bias_type`, `crossover_type` | diversity, exchange, PR, shaking, reset |
| **2** | + Dynamic elite sizing + diversity | `min_elites_percentage`, `max_elites_percentage`, `diversity_type` (replaces `elites_percentage`) | exchange, PR, shaking, reset |
| **3** | + Multi-population exchange | `num_populations`, `exchange_interval`, `num_exchange_individuals` | PR, shaking, reset |
| **4** | + Path relinking | `pr_type`, `pr_dist_func`, `pr_percentage`, `pr_interval` | shaking, reset |
| **5** | + Shaking | `shake_interval`, `shake_intensity`, `shake_distribution` | reset |
| **6** | Full NS-BRKGA | `reset_interval`, `reset_intensity` | *(all active)* |

### Stage Files

Each stage has three dedicated files:

| Stage | Parameters | Scenario | Runner |
|-------|-----------|----------|--------|
| 1 | `nsbrkga-parameters-stage1.txt` | `nsbrkga-scenario-stage1.txt` | `nsbrkga-tunner-stage1.sh` |
| 2 | `nsbrkga-parameters-stage2.txt` | `nsbrkga-scenario-stage2.txt` | `nsbrkga-tunner-stage2.sh` |
| 3 | `nsbrkga-parameters-stage3.txt` | `nsbrkga-scenario-stage3.txt` | `nsbrkga-tunner-stage3.sh` |
| 4 | `nsbrkga-parameters-stage4.txt` | `nsbrkga-scenario-stage4.txt` | `nsbrkga-tunner-stage4.sh` |
| 5 | `nsbrkga-parameters-stage5.txt` | `nsbrkga-scenario-stage5.txt` | `nsbrkga-tunner-stage5.sh` |
| 6 | `nsbrkga-parameters-stage6.txt` | `nsbrkga-scenario-stage6.txt` | `nsbrkga-tunner-stage6.sh` |

### Train/Test Instance Split

The ablation uses an explicit train/test split for iRace:

**Training (5 instances)** — `train-instances.txt`:
| Instance | Jobs | Machines | Total Operations | Role |
|----------|------|----------|-----------------|------|
| mk01 | 10 | 6 | 55 | Small baseline |
| mk04 | 15 | 8 | 90 | Medium, 8-machine |
| mk05 | 15 | 4 | 106 | Only 4-machine case |
| mk08 | 20 | 10 | 225 | Large, 10-machine |
| mk14 | 30 | 15 | 277 | Largest job count, 15 machines |

**Testing (10 instances)** — `test-instances.txt`:
mk02, mk03, mk06, mk07, mk09, mk10, mk11, mk12, mk13, mk15

### Stage 1 Runner Behavior

Stage 1 uses a synthetic `elites_percentage` parameter that the runner maps to both `--min-elites-percentage` and `--max-elites-percentage` (same value), enforcing a fixed elite size. Stages 2–6 tune `min_elites_percentage` and `max_elites_percentage` independently.

### Running the Ablation

**Run all six stages in parallel, then the held-out testing phase:**
```bash
cd irace/
./irace_runner.sh
```

**Run a single stage manually:**
```bash
cd irace/
Rscript -e "library(irace); irace::irace_cmdline(c('--scenario','nsbrkga-scenario-stage1.txt'))"
```

**Validate a stage scenario before running:**
```bash
cd irace/
irace --check --scenario nsbrkga-scenario-stage1.txt
```

### Ablation Results

After tuning, each stage produces:
- `irace-nsbrkga-stageX.Rdata` — iRace log with all tuning data
- `nsbrkga-stageX-testing.log` — Console output from testing

To inspect results in R:
```r
load("irace-nsbrkga-stage6.Rdata")
print(iraceResults$allElites[[length(iraceResults$allElites)]])
```

### Budget and Reproducibility

| Setting | Value | Source |
|---------|-------|--------|
| Runner time limit | 900 s | Matches `run.sh` benchmark |
| iRace budget per stage | `maxTime = 2160000` | Reference repository parity |
| Test elites | 5 per stage | `testNbElites` in each scenario and in `irace_runner.sh` |

---

## Folder Contents

- **`*-scenario.txt`** — iRace scenario configuration (paths, budget, log file)
- **`*-parameters.txt`** — Parameter space definition (name, switch, type, range, constraints)
- **`*-tunner.sh`** — Target runner script that iRace calls to evaluate a configuration
- **`train-instances.txt`** — Training instances for staged ablation
- **`test-instances.txt`** — Held-out test instances for staged ablation
- **`irace_runner.sh`** — Orchestration script for the full ablation workflow

## Prerequisites

1. **R** with the `irace` package installed:
   ```bash
   Rscript -e "install.packages('irace', repos='https://cloud.r-project.org')"
   ```

2. **Compiled solver binaries** in `../bin/exec/`:
   - `nsga2_solver_exec`, `nsbrkga_solver_exec`, etc.
   - `hypervolume_calculator_exec`

3. **Training and test instances** in `../instances/` matching the names in
   `train-instances.txt` and `test-instances.txt`.

## How iRace Calls the Target Runner

iRace invokes the target runner with:
```
./target-runner <config_id> <instance_id> <seed> <instance_path> <params...>
```

- **`<instance_path>`** is formed as `trainInstancesDir/instance_name` (e.g., `../instances/mk01.txt`)
- Since `maxTime` is set, the runner **must** print two values: `cost time`
  - `cost`: Negative hypervolume (minimized by iRace → maximized HV)
  - `time`: Elapsed seconds (integer)

On failure, runners return a large penalty (`Inf`) to avoid crashing iRace.

## Quick Start

Run tuning from inside the `irace/` directory:

**NSGA-II:**
```bash
Rscript -e "library(irace); irace::irace_cmdline(c('--scenario','nsga2-scenario.txt'))"
```

**NSGA-III:**
```bash
Rscript -e "library(irace); irace::irace_cmdline(c('--scenario','nsga3-scenario.txt'))"
```

**NS-BRKGA (one ablation stage, N = 1..6):**
```bash
Rscript -e "library(irace); irace::irace_cmdline(c('--scenario','nsbrkga-scenario-stage1.txt'))"
```

Optional: redirect output to a log:
```bash
Rscript -e "library(irace); irace::irace_cmdline(c('--scenario','nsga2-scenario.txt'))" 2>&1 | tee nsga2-tuning.log
```

## Notes on Parameter Files

### Format
Each parameter is defined as:
```
name  "switch"  type  (min, max)  [condition]
```
where `type` is: `i` (integer), `r` (real), `c` (categorical).

### NSGA-II Parameters
- **`population_size_factor`**: The runner multiplies this by 4 → actual `population_size` (range 100–500).
- Other params: `crossover_probability`, `crossover_distribution`, `mutation_probability`, `mutation_distribution`.

### NSGA-III Parameters
- Same five parameters as NSGA-II, plus **`divisions`** — the number of divisions per objective
  used to build the reference-point hyperplane.
- NSGA-III generates `C(m + divisions - 1, divisions)` reference points for an `m`-objective
  instance and requires **`population_size > that count`**, on top of the usual
  **`population_size` divisible by 4** (which `population_size_factor × 4` guarantees).
- The `[forbidden]` rule
  `population_size_factor * 4 <= choose(4 + divisions - 1, divisions)`
  evaluates that bound at `m = 4`, the objective count of every MOFJSSP instance, so no
  sampled configuration can be rejected.
- `nsga3-tunner.sh` always passes `--memory`, matching how `run.sh` invokes the solver, so
  tuning and the final experiments use the same algorithm configuration.
- The solver validates all of the above itself and aborts with an explicit message rather than
  running an invalid configuration.

### NS-BRKGA Parameters
- Uses the same `population_size_factor` convention.
- **Forbidden constraints** (in `[forbidden]` section):
  - `min_elites_percentage >= max_elites_percentage` — rejected
  - `num_elite_parents > num_total_parents` — rejected
  - `shake_interval >= reset_interval` — rejected

## Output Artifacts

- **`irace-*.Rdata`**: The `logFile` containing all iRace results. Load in R to inspect elite configurations:
  ```r
  load("irace-nsga2.Rdata")
  print(iraceResults$allElites[[length(iraceResults$allElites)]])
  ```

- **Temporary folders** (created during runs for Pareto files and hypervolume output; cleaned up automatically).

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `Permission denied` | Make runner executable: `chmod +x *-tunner.sh` |
| `command not found` errors | Ensure solver binaries are built in `../bin/exec/` |
| iRace reports non-numeric output | Runner must print exactly `cost time` (two numbers) |
| `No such file or directory` | Check working directory; run from inside `irace/` |
| Instance not found | Verify entries in `train-instances.txt` / `test-instances.txt` match files in `../instances/` |
