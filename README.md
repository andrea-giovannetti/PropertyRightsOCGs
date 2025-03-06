# Replication code for Figure 4, Rozzi, R., Giovannetti, A., Pin, A. and Campana, P. Endogenous Property Rights over Drug Markets: Theory and Evidence from Merseyside, U.K.

## Overview
This repository contains MATLAB code for generating Figure 4, Rozzi, R., Giovannetti, A., Pin, A. and Campana, P. Endogenous Property Rights over Drug Markets: Theory and Evidence from Merseyside, U.K. The script is made of two components: `simu_drug_markets.m` and `Figure4.m`. By running `Figure4.m`, an Agent-Based model (ABM) contained in the function  `simu_drug_markets.m` is automatically called to generate artificial data. The script uses the artificial data to generate Figure 4 of the main paper. The purpose of the ABM model is to explore the effects in terms of conflicts over areas, density of OCGs across areas and OCG turnover for a range of values of the exploration intensity parameter eta (described in the main text). Figure 4 visualizes the frequency of violence, mean streak duration, and concentration levels across different locations.

## Contents
- **`simu_drug_markets.m`**: The core function that runs the agent-based simulation. 
- **Figure4.m**: First, it calls `simu_drug_markets.m` to run the model and compute key statistics. Second, it uses the simulation results to generate Figure 4, displaying violence, stability, and concentration levels across areas.

---

## 1. Agent-Based Simulation
### **Purpose**
The simulation models how multiple OCGs interact in a competitive environment over a set of locations. The model tracks:
- How OCGs explore and occupy territories.
- The frequency of violent conflicts when multiple OCGs target the same location.
- The duration of stable control over a location (mean streak length).
- The overall concentration level of OCGs across areas.

### **Key Parameters**
| Parameter        | Description |
|-----------------|-------------|
| `N_ocgs`       | Number of OCGs in the simulation |
| `N_l`          | Number of locations available for occupation (must be ≥ `N_ocgs`) |
| `c`            | Cost of conflict when OCGs overlap on the same area |
| `U_l`          | Vector representing the value of each area |
| `t_end`        | Total number of simulation periods |
| `eta_vec`      | Exploration intensity parameter (controls how likely OCGs are to explore new areas) |

### **Outputs**
The simulation produces several key outputs:
- `F`: Fight occurrences at each location over time.
- `avgF_vec`: Average number of fights per location.
- `avgtau_vec`: Average number of visits per area, representing concentration levels.
- `mean_streaks`: Tracks the duration of continuous OCG control over a location.
- `inc`: Records which OCG controls each location at each time step.

### **Running the Simulation**
The simulation can be executed by calling:
```matlab
[F, avgF_vec, avgtau_vec, mean_streaks, inc] = simu_drug_markets(U_l, c, t_end, eta_vec, N_ocgs, N_l);
```

This function iterates over `t_end` time periods, tracking fights, territorial shifts, and OCG behavior.

---

## 2. Generating Figure 4
### **Purpose**
This script uses the results from the agent-based simulation to visualize the relationship between:
- The frequency of violence (red line)
- The mean streak length (black line)
- The concentration level of OCGs in each area (blue line)
 
### **To generate Figure 4**
1. Simply download the two codes and run `simu_drug_markets.m` with default parameters.
  

## **Citing This Work**
If you use this code in your research, please cite Rozzi, R., Giovannetti, A., Pin, A. and Campana, P. Endogenous Property Rights over Drug Markets: Theory and Evidence from Merseyside, U.K.

For questions or contributions, feel free to open an issue or submit a pull request.
