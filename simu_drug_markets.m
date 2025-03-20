function [F, avgF_vec, avgtau_vec, mean_streaks, inc] = simu_drug_markets(U_l, c, t_end, eta_vec, N_ocgs, N_l)

    % SIMU_DRUG_MARKETS simulates drug market competition among organized crime groups (OCGs) over multiple time periods.
    %
    % Inputs:
    %   U_l      - Base utility of a location for OCGs
    %   c        - Cost parameter affecting exploration decisions
    %   t_end    - Number of time periods for simulation
    %   eta_vec  - Vector of exploration intensities
    %   N_ocgs   - Number of OCGs
    %   N_l      - Number of locations
    %
    % Outputs:
    %   F                    - Fight occurrences at each location over time (t_end x N_l)
    %   avgF_vec             - Average number of fights per location across simulations (numel(eta_vec) x N_l)
    %   avgtau_vec           - Average number of visits per area (i.e. concentration level) across simulations (numel(eta_vec) x N_l)
    %   mean_streaks        - Matrix tracking consecutive periods an OCG controls a location (numel(eta_vec) x N_l)
    %   inc                  - Matrix recording which OCG controls a given location at each time step (t_end x N_l)
 

P_0 = ones(1, N_l).*(1/N_l); %  initial probability that location is homogeneous across OCGs
 

% Parametric space exploration vectors (needed later)

avgF_vec = zeros(numel(eta_vec),N_l);
stdF_vec = zeros(numel(eta_vec),N_l);
avgtau_vec = zeros(numel(eta_vec),N_l);
sumF_vec = zeros(numel(eta_vec),N_l);


% Parametric exploration of parameter eta begin here:


for K = 1:numel(eta_vec)


    eta = eta_vec(K); % pick eta from the eta vector

    % Turfs setup

    % Preallocate time-dependent vectors

    P = zeros(t_end,N_l);
    D = zeros(t_end,N_l);
    F = zeros(t_end,N_l);
    tau = zeros(t_end,N_ocgs); % this is the visit counter
    avgF = zeros(t_end,N_l);
    inc = zeros(t_end,N_l);
    count_streaks = zeros(t_end,N_l);

    % Agent Based Simulation starts

    for t = 1:t_end

        % Show progress (remove to increase speed)

if mod(t, 10000) == 0
    progress = (t / t_end) * 100;
    fprintf("Simulation progress: %.2f%% (eta = %.2f)\n", progress, eta);
end


        % Intra-period loop starts

        if t > 1

            if sum(sum( D(1:(t-1), :) )) > 0 % this is to cope with a situation where OCGs don't go out in period t=1 and hence priors are not generated

                P(t,:) = 1 - sum( D(1:(t-1), :) , 1 )./(t-1); % this is a matrix where rows are periods (most recent at the bottom) and columns are places

            else % else, if no OCG went out in the previous period and there is no probability apart from the initial prior (only happens at t=2), hence stick to the initial probability

                P(t,:) = P_0;

            end % end condition on prior prob

            % The below computes Q as a matrix where columns are locations and rows are OCGs.
            % The activators (T1 == t-1) identify OCGs that visited places in t-1 or earlier. The activators (P == 0 or 1) identify corner cases.
            % The derivation of Q is split in two branches (T1 == t-1) and (T1 < t-1) to follow the design of a more general version of the model. However, the splitting has no implications in this version.  
            % Note: the below uses matlab-logic which is formally inconsistent. Example: (1 - P) is a (scalar - matrix) operation, however, this is correctly understood by Matlab as (matrix of 1 - matrix)

            Q = (T1 == t-1).* ( ...
                (P(t,:) == 1).*1 + (P(t,:) == 0).*0 + ...
                (P(t,:) > 0 & P(t,:) < 1).*( P(t,:).*(  1 - exp(- (t - T1 )./(1-  P(t,:))) ) + (1 - Z1).*exp( - (t - T1 )./(1 - P(t,:))    )           ) ) + ...
                (T1 < t-1).* ( ...   
                (P(t,:) == 1).*1 + (P(t,:) == 0).*0 + ...
                (P(t,:) > 0 & P(t,:) < 1).*( P(t,:).*(  1 - exp(- (t - T1 )./(1-  P(t,:))) ) + (1 - Z1).*exp( - (t - T1 )./(1 - P(t,:))    )           ) );


            % pre-generate a random vector unique for each combination of area/OCG/period

            % random_utility_ocgs = rand(N_ocgs,1).*ones(N_ocgs); % this is constant for each ocg
            random_utility_ocgs = rand(N_ocgs,N_l);
 

            % Compute the endogeneous preference structure for each OCG. Notice that V is a N_ocg x N_l matrix

            V = (Q == 0 ).*(   U_l - c./random_utility_ocgs  )  + ( Q > 0 ).*( U_l - c./Q  ) ;

            % Pre-generate matrices T  and Z (which will be modified during the exploration)

            T = T1;
            Z = Z1;


            % Decide which OCG goes first, second etc.

            visit_order = randperm(N_ocgs);
 

            for i=1:N_ocgs


                if rand <=  eta/(1+ eta)  % OCG i will go out exploring places according to her preference structure, update occupation vectors

                    % Map the value of all areas into an exploration sequence 

                    ocg_idx = visit_order(i); % pick the OCG
                    V_ocg_shocked = V(ocg_idx,:) + rand(1, N_l)./1000000 ; % Introduce a tiny randomization for tie-break if any tie exists in the preference vector 
                    ocg_visit_location_ordered = sort(V_ocg_shocked,'descend');  % order the preferences from top to worst ranked area.
                    [~, ~,ocg_visit_location_idx] = intersect(ocg_visit_location_ordered,V_ocg_shocked,'stable'); % this tells the column location in the V matrix of ordered locations

                    % Once OCG i decided the order, OCG begins the exploration

                    k = 1; % reset operator for the area exploration


                    while  D(t,ocg_visit_location_idx(k) ) == 1 % as long as areas are occupied, update vectors and keep the exploration going

                        % Individual-specific updates:

                        T(ocg_idx,ocg_visit_location_idx(k)) = t; % update last visit vector
                        Z(ocg_idx,ocg_visit_location_idx(k)) = 1; % place observed taken by somebody else

                        % Place-specific updates

                        D(t,ocg_visit_location_idx(k) )  = 1; % place is taken, flag it
                        F(t,ocg_visit_location_idx(k)) =   1; % fight for the turf (dummy, not incremental)
                        tau(t, ocg_visit_location_idx(k)) = tau(t, ocg_visit_location_idx(k)) + 1;  % Update the flow of OCGs visiting location L in that specific moment

                        k = k + 1; % explore next-up location

                    end % end ocg i update of clashing turf

                    % The OCG settles in the first non-contended turf

                    T(ocg_idx,ocg_visit_location_idx(k)) = t; % update last visit vector
                    Z(ocg_idx,ocg_visit_location_idx(k)) = 0; % place will be left empty
                    D(t,ocg_visit_location_idx(k) ) = 1; % but at the same time, place was taken by OCG i 
                    tau(t, ocg_visit_location_idx(k)) = tau(t, ocg_visit_location_idx(k)) + 1;  % Update the flow of OCGs visiting location L in that specific moment
                    
                    inc(t, ocg_visit_location_idx(k)) = ocg_idx; % record the group label becoming incumbent for area ocg_visit_location_idx(k)

                    % % % % % Streak computation 
 
                    if inc(t, ocg_visit_location_idx(k)) == inc(t-1, ocg_visit_location_idx(k))

                        J = find(count_streaks(:, ocg_visit_location_idx(k))> 0, 1, 'last');
                        if isempty(J)
                            J = 1;
                        end
                        count_streaks(J, ocg_visit_location_idx(k)) = count_streaks(J, ocg_visit_location_idx(k)) + 1;

                    else 

                        J = find(count_streaks(:, ocg_visit_location_idx(k))> 0, 1, 'last') + 1;
                        if isempty(J)
                            J = 1;
                        end
                        count_streaks(J, ocg_visit_location_idx(k)) =  1;


                    end % end adding streaks
 

                else % if eta not high enough, OCG i doesn't venture out

                end % end OCG i's exploration


            end % end all OCG period action.


        elseif t == 1  % if it's period 1, generate priors and trackers

            Z = zeros(N_ocgs, N_l);
            P(1,:) = P_0;
            T = zeros(N_ocgs, N_l); % time ticks last OCG visit to turfs


        end  % END INTRA-PERIOD LOOP

        % Compute statistics
        % Average number of fights per turf

        if t > 1
            avgF(t,:) = mean(F(1:t-1,:)); % this one can be speeded up massively
        end

        % Update recursive vectors for T, Z

        T1 = T;
        Z1 = Z;



    end % end time simulation

    avgF_vec(K,:) = mean(F);
    stdF_vec(K,:) = std(F);
    sumF_vec(K,:) = sum(F);

    avgtau_vec(K,:) = mean(tau);

% Compute the streak vector from the streak time series matrix. A zero value in the matrix implies that stability has been attained for the corresponding area (i.e. one OCG only targets that area). 
% Therefore, to compute the streak vector, non-zero values only from the matrix are considered 

for i=1:N_l
    mean_streaks(K,i) = mean(nonzeros(count_streaks(:,i))); 
end 

end % end parameter exploration




end



