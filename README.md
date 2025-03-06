# Agent-Based Simulation of Drug Market Competition

## Overview
This repository contains MATLAB code for simulating drug market competition among Organized Crime Groups (OCGs). The simulation models territorial control, conflicts over areas, and the effect of exploration intensity on violence and stability in the market. Additionally, it includes code to generate Figure 4 from the main text, which visualizes the frequency of violence, mean streak duration, and concentration levels across different locations.

## Contents
- **`simu_drug_markets.m`**: The core function that runs the agent-based simulation.
- **Simulation script**: Calls `simu_drug_markets.m` to run the model and compute key statistics.
- **Figure generation script**: Uses the simulation results to generate Figure 4, displaying violence, stability, and concentration levels across areas.

---

## 1. Agent-Based Simulation
### **Purpose**
The simulation models how multiple OCGs interact in a competitive environment over a set of locations. It captures:
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

This function iterates over multiple time periods, tracking fights, territorial shifts, and OCG behavior.

---

## 2. Generating Figure 4
### **Purpose**
This script uses the results from the agent-based simulation to visualize the relationship between:
- The frequency of violence (red line)
- The mean streak length (black line)
- The concentration level of OCGs in each area (blue line)

### **Plot Components**
- **X-axis**: Areas, ordered from lowest to highest value.
- **Left Y-axis (Red)**: Frequency of fights.
- **Right Y-axis (Blue)**: Concentration level of OCGs.
- **Dashed Black Line**: Mean streak length (periods of stable control).

### **Running the Figure Generation Code**
1. Ensure the simulation has been run with `eta = 10`.
2. Execute the following script:
   ```matlab
   % Define the scaling factor for mean streak
   scaler = 15;
   
   % Select the desired exploration intensity (eta)
   eta = 10;
   eta_scale = eta * 10;
   
   % Define x-axis ordering (reordering locations from lowest to highest value)
   x = [10 9 8 7 6 5 4 3 2 1];
   
   % Plot the figure
   figure;
   set(gcf, 'Color', 'w');
   
   yyaxis left;
   hold on;
   plot(x, avgF_vec, 'r--o', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', 'r');
   plot(x, mean_streaks ./ scaler, 'k--o', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', 'k');
   hold off;
   
   yyaxis right;
   plot(x, avgtau_vec, 'b--o', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', 'b');
   
   % Customize axes and legend
   xlabel('Areas');
   legend({'Frequency of Violence', 'Mean Streak', 'Concentration Level'}, 'Location', 'north', 'FontSize', 12);
   
   % Save the figure as a PDF
   print(gcf, 'fights_10_disaggregated_fig4', '-dpdf');
   ```

This will generate Figure 4, helping visualize how OCG behavior changes across different areas.

---

## **Citing This Work**
If you use this code in your research, please cite accordingly.

For questions or contributions, feel free to open an issue or submit a pull request.

📌 **Author**: Andrea Giovannetti
