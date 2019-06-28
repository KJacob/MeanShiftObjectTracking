function rho = Bhattacharya( q_dist, p_dist )
%BHATTACHARYA The coefficient for two distributions
%   q_dist: The q distribution
%   p_dist: The p distribution

rho = q_dist .* p_dist;
rho = sqrt(rho);
rho = sum(rho);

end

