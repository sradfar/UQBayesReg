# UQBayesReg
MATLAB code for Bayesian regression analysis of significant wave height (Hs) using UQLab.

This repository contains MATLAB code for performing Bayesian regression analysis of significant wave height (Hs) using the UQLab framework. The analysis includes defining a forward model, setting prior distributions, specifying a custom likelihood function, and running a Markov Chain Monte Carlo (MCMC) simulation to estimate model parameters.

## Features

- **Forward Model Definition**: Uses UQLab to define the forward model for significant wave height (Hs).
- **Custom Likelihood Function**: Implements a custom likelihood function based on a generalized extreme value (GEV) distribution.
- **Prior Distributions**: Defines uniform priors for model parameters (shape, scale, location).
- **MCMC Sampling**: Uses the Affine Invariant Ensemble Sampler (AIES) for MCMC sampling.
- **Graphical Post-Processing**: Provides visualizations to analyze convergence and parameter estimation.

## Usage Instructions

1. **Initialize UQLab**: Ensure that UQLab is installed and initialized in MATLAB before running the code.

   uqlab

2. **Load the Data**: Load observed significant wave height (Hs) data from an Excel file (`HTW.xlsx`) into the `myData` variable.

3. **Set Model Parameters**:
   - **Forward Model**: Defines a simple model where `X` represents the model output.
   - **Prior Distributions**: Specifies uniform priors for shape (`k`), scale (`sigma`), and location (`mu`) parameters.
   - **Discrepancy Model**: Sets a Gaussian discrepancy model to account for measurement error.

4. **Run Bayesian Analysis**:
   - Specifies MCMC settings: 100 chains, 200 steps each.
   - Enables visual updates of the MCMC progress every 20 iterations.
   - Performs Bayesian inversion using the UQLab `uq_createAnalysis` function.

5. **Post-Process Results**:
   - Outputs a summary report of the Bayesian analysis.
   - Displays graphical representations of the results, including Gelman-Rubin diagnostics and parameter estimates.

## Code Structure

- **Initialization**: Clears variables, sets random number generator for reproducibility, and initializes UQLab.
- **Forward Model**: Defines the forward model in UQLab.
- **Custom Likelihood Function**: Defines a GEV-based likelihood function for Bayesian inversion.
- **Data Loading**: Reads significant wave height (Hs) data from `HTW.xlsx`.
- **Prior Distribution Setup**: Specifies uniform prior distributions for model parameters.
- **Discrepancy Model**: Defines the Gaussian discrepancy model.
- **MCMC Settings**: Configures the MCMC algorithm for Bayesian sampling.
- **Bayesian Analysis Execution**: Runs the analysis and prints results.
- **Post-Processing**: Visualizes convergence and parameter estimates.

## Example Output

Running the code will generate the following outputs:
- A printed report summarizing parameter estimates and diagnostics.
- Graphical representations of the MCMC chains, Gelman-Rubin metrics, and posterior distributions.

## Requirements

- **MATLAB**: This code is written for MATLAB.
- **UQLab**: UQLab framework is required for Bayesian inversion and MCMC sampling. [UQLab Installation Guide](https://www.uqlab.com/installation).

## Developer

Developed by **Soheil Radfar**  
Email: [soheil.radfar92@gmail.com](mailto:soheil.radfar92@gmail.com)

## License

This project is licensed under the MIT License.
