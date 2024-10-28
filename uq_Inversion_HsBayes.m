%% INVERSION: DISTRIBUTION MEAN
% 
% In this code, the Bayesian analysis of
% significant wave height (Hs)is performed.
%
% The code is developed by Soheil Radfar
%
% For questions and permissions, please contact:
% (soheil.radfar92@gmail.com)

%% 1 - INITIALIZE UQLAB
%
% Clear all variables from the workspace, set the random number generator
% for reproducible results, and initialize the UQLab framework:
clearvars
rng(100,'twister')
uqlab

%% 2 - FORWARD MODEL
%
% Define the forward model as a UQLab MODEL object:

ModelOpts.mString = 'X';
ModelOpts.isVectorized = true;
myForwardModel = uq_createModel(ModelOpts);

%% 3 - CUSTOM LIKELIHOOD FUNCTION
% The Bayesian inversion module expects two arguments |params| and |y|
% for the user-defined likelihood functions that correspond to the model
% parameters and the data, respectively.
% Create a function handle to the function |uq_customLogLikelihood|
% as a wrapper with the two arguments:
myLogLikelihood = @(params,y) uq_GEVLogLik(params,y);
% The custom likelihood is selected based on the prior distribution of the variable

%% 4 - MEASUREMENT DATA
%
% The available observed for Hs is stored in the |myData|

AllData = xlsread('HTW.xlsx');
y1 = AllData(:,1);

myData.y = y1;
myData.Name = 'Significant Wave Height';

%% 5 - PRIOR DISTRIBUTION OF THE MODEL PARAMETERS
% Specify these distributions as a UQLab INPUT object:

PriorOpts.Marginals(1).Name = 'k'; % Shape parameter
PriorOpts.Marginals(1).Type = 'Uniform';
PriorOpts.Marginals(1).Parameters = [0.4 0.6]; % (-) [Mean S.D.]

PriorOpts.Marginals(2).Name = 'sigma'; % Scale parameter
PriorOpts.Marginals(2).Type = 'Uniform';
PriorOpts.Marginals(2).Parameters = [0.16 0.20]; % (-)

PriorOpts.Marginals(3).Name = 'mu'; % Location parameter
PriorOpts.Marginals(3).Type = 'Uniform';
PriorOpts.Marginals(3).Parameters = [1.8 2.0]; % (-)

myPriorDist = uq_createInput(PriorOpts);

%% 6 - DISCREPANCY MODEL
%

SigmaOpts.Marginals.Name = 'Sigma2';
SigmaOpts.Marginals.Type = 'Uniform';
SigmaOpts.Marginals.Parameters = [0 0.01]; % (m^2) [Mean Variance] for discrepancy of measurements
mySigmaDist = uq_createInput(SigmaOpts);

%%
% Assign these distributions to the discrepancy model options:
    
DiscrepancyOpts.Type = 'Gaussian';
DiscrepancyOpts.Prior = mySigmaDist;

%% 7 - BAYESIAN ANALYSIS
%
% The options of the Bayesian analysis are specified with the following
% structure:
% To sample directly from the posterior distribution,
% the affine invariant ensemble algorithm is employed for this example,
% using $100$ parallel chains, each with $200$ iterations:
Solver.Type = 'MCMC';
Solver.MCMC.Sampler = 'AIES';
Solver.MCMC.NChains = 100;
Solver.MCMC.Steps = 200;

%%
% Visually display the progress of the MCMC during iterations for
% parameters $c_{\mathrm{max}}$ and $\alpha$ (parameter |1| and |3|,
% respectively) and update the plots every $20$ iterations: 
Solver.MCMC.Visualize.Parameters = [1 2 3];
Solver.MCMC.Visualize.Interval = 20;

BayesOpts.Type = 'Inversion';
BayesOpts.Data = myData;
BayesOpts.Discrepancy = DiscrepancyOpts;
BayesOpts.Prior = myPriorDist;
BayesOpts.LogLikelihood = myLogLikelihood;
BayesOpts.Solver = Solver;

%%
% Run the Bayesian inversion analysis:
myBayesianAnalysis = uq_createAnalysis(BayesOpts);

% Print out a report of the results:
uq_print(myBayesianAnalysis)

%%
% Create a graphical representation of the results:
uq_postProcessInversion(myBayesianAnalysis, 'burnIn', 0.3,... % Burn-in period in MCMC
    'pointEstimate', {'MAP','Mean'},... % Estimation of Maximum a Posteriori (MAP)
    'gelmanRubin', 'true'); % Gelman-Rubin metric to check convergence

	% Create a graphical representation of the results:
uq_display(myBayesianAnalysis)