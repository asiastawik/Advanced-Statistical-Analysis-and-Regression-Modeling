# MATLAB Report: Advanced Statistical Analysis and Regression Modeling

This repository contains MATLAB scripts and functions developed for a series of statistical and regression analysis tasks. The report involves non-linear and linear regression modeling, BIC calculation, variable analysis using t-tests, and regression with backward stepwise selection. Additionally, it includes data visualization and model diagnostics using various statistical tests.

## Project Tasks Overview

### Task 2.1: Non-Linear Model and LS Loss Function
- **Objective**: Develop a MATLAB function to compute the LS (Least Squares) loss function for a non-linear model
- **Functionality**:
  - Implement a function to find vector `a` that minimizes the LS loss, ensuring that each \( a_i \) falls within the range (-2, 2).

### Task 2.2: Linear Regression Preparation and BIC Calculation 
- **Subtask 1**: Create a MATLAB function `[x, y] = autoregressive(y, lags)` to prepare inputs for an autoregressive model. The function must handle any input lag values.
- **Subtask 2**: Implement a function to compute the BIC (Bayesian Information Criterion) where `n` is the sample size, and `k` is the number of parameters.
- **Model Selection**: Find the optimal model with three variables by testing all combinations of lags from 1 to 7 using the `nchoosek` function. The model with the lowest BIC is selected as the best.

### Task 2.3: Linear Regression and Variable Analysis
- **Objective**: Analyze a linear regression model
- **Statistical Analysis**:
  - Conduct a t-test to identify irrelevant variables.
  - Impose restrictions for irrelevant variables and set `beta`' to represent an average price of $10000 per square meter.
- **Wald Test**:
  - Perform the Wald test to verify the restrictions and interpret the results.

### Task 2.4*: Additional Analysis Using POLEX Data
- **Data Source**: The dataset `POLEX.csv` contains electricity price (`Pt`), electricity load (`Lt`), renewable energy generation (`Rt`), EUA price (`Et`), and natural gas price (`Nt`). The analysis is restricted to a subset corresponding to the first letter of the user's surname.
- **Data Visualization**:
  - Plot the price series with:
    - Title set to the month and year of the data.
    - Y-axis labeled as 'Price [$]'.
    - X-axis labeled as 'Date'.
- **Model Construction**:
  - Construct an autoregressive model.
  - Create a matrix `X` that includes lagged price data along with `Lt`, `Rt`, `Et`, and `Nt`.
  - Join the matrices to form an 11-column `X` matrix.
- **Regression and Analysis**:
  - Run linear regression with the full model.
  - Conduct t-tests to identify irrelevant variables and apply the Wald, LR, and LM tests to validate restrictions.
- **Backward Stepwise Regression**:
  - Start with the full model and exclude the variable with the highest p-value (if > 5%).
  - Repeat the process until all variables have p-values ≤ 5%.
  - Display the excluded variable's identifier at each step and compute information criteria (AIC or BIC).
- **Model Comparison**:
  - Compare information criteria at each step and assess if the final model is optimal based on IC.

## Programming Language
- This analysis was conducted entirely in **MATLAB**, using its robust capabilities for statistical computing, data visualization, and model testing.
