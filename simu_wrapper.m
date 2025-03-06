
%% 1) Agent-Based simulation. To do so, rerun the simulation in A for eta=7 and compute the mean streak (i.e. length of period with no fight) for each area

% Default Setup

% Number of OCGs operating in the model
N_ocgs = 10; 

% Number of areas available for occupation. Note: the model requires that N_l >= N_ocgs
N_l = 10; 

% Fight cost paid by OCGs when overlapping on the same area
c = 5; 

% Vector of area values (ordered from top to bottom). Equivalent to benefit produced by occupying an area. 
U_l = [173 125 100 76 63 51 42 35 29 26]; 

% Number of simulation periods
t_end = 80000; 

% Intensity of exploration Eta. This can be a value or an interval
eta_vec = 10 %[0:0.1:35]; 

% Run the simulation
% The simulation will generate the following set of statistics:

    % Outputs:
    %   F                    - Fight occurrences at each location over time (t_end x N_l)
    %   avgF_vec             - Average number of fights per location across simulations (numel(eta_vec) x N_l)
    %   avgtau_vec           - Average number of visits per area (i.e. concentration level) across simulations (numel(eta_vec) x N_l)
    %   mean_streaks        - Matrix tracking consecutive periods an OCG controls a location (numel(eta_vec) x N_l)
    %   inc                  - Matrix recording which OCG controls a given location at each time step (t_end x N_l)


[F, avgF_vec, avgtau_vec, mean_streaks, inc] = simu_drug_markets(U_l,c, t_end, eta_vec,N_ocgs,N_l);  





 


%% 2) Generate Figure 4 (Main Text)

% The below figure has been generated using the default setup of Point (1)

scaler = 15; % used to scale the plot axis

avgF_vec_means = avgF_vec ;
avgtau_vec_means = avgtau_vec ;

% X-axis range (Areas are re-ordered from lowest-value to highest-value)

x = [10 9 8 7 6 5 4 3 2 1];

% Select a specific eta parameter

eta = 10;

eta_scale = eta*10; % to map the eta into eta_vec

% Plot the first figure
figure;

% Set the figure background color to white
set(gcf, 'Color', 'w');

% Plot the left y-axis (Fights) in red without error bars
yyaxis left
hold on
plot(x, avgF_vec_means, 'r--o', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Dashed line

plot(x,  mean_streaks./scaler, 'k--o', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % Dashed line

ylabel(' ', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'YColor', 'r'); % Set y-axis color to red
set(gca, "XLim", [0.95,3.09]);
set(gca, "YLim", [0,1]);
set(gca, 'YTickLabel', []);
set(gca, 'YColor', 'k'); % Keep the axis line visible (neutral color)
hold off


% Plot the right y-axis (Occupation) in blue
yyaxis right
plot(x, avgtau_vec_means, 'b--o', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', 'b'); % Dashed line
ylabel(' ', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'YColor', 'b'); % Set y-axis color to blue
set(gca, 'YTickLabel', []);
set(gca, 'YColor', 'none'); % Remove y-axis color

% Replace x-axis labels with u_1, u_2, u_3
xticks([1 2 3 4 5 6 7 8 9 10]);
xticklabels({'u_{10}', 'u_9', 'u_8', 'u_7', 'u_6', 'u_5', 'u_4', 'u_3', 'u_2', 'u_{1}'}); % Replace x-axis tick labels
xlabel(''); % Remove x-axis label
set(gca, 'YColor', 'k'); % Keep the axis line visible (neutral color)

% Add legend
legend({'Frequency of Violence', 'Mean Streak', 'Concentration Level'}, 'Location', 'north', 'FontSize', 12);

% Adjust properties for the axes and figure
set(gca, 'FontSize', 14, 'FontWeight', 'bold', 'Box', 'off');
set(gca, 'Color', 'w'); % Set the axes background color to white
set(gca, "XLim", [0.95,10.09]);
set(gca, "YLim", [0,3.1]);
hold off


    % Print the picture
    fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'c://Users/giova/Dropbox/Sydney/ACU/Research/Property Rights/fights_10_disaggregated_fig4','-dpdf')