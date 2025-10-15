# Quantitative Analysis with Small Samples

**A Practical Guide for Students and Early-Career Researchers**

This Quarto book provides comprehensive guidance on conducting rigorous quantitative analysis with small samples (n ≈ 10–100), particularly relevant for research in Small Island Developing States (SIDS) and similar contexts.

## Book Contents

### Part A: Foundations
- Chapter 1: Why Small-Sample Research Matters
- Chapter 2: Questions and Outcomes that Fit Small n

### Part B: Data Collection and Preparation
- Chapter 9: Sampling Strategies for Small Studies
- Chapter 10: Measurement Quality and Scale Development
- Chapter 11: Data Screening and Diagnostic Checks
- Chapter 12: Handling Missing Data in Small Samples

### Part C: Analysis Methods
- Chapter 3: Exact Tests and Resampling Methods
- Chapter 4: Nonparametric Rank-Based Methods
- Chapter 5: Penalised and Bayesian Regression
- Chapter 6: Reliability and Measurement Quality for Short Scales
- Chapter 7: Multi-Criteria Decision Making (MCDM)
- Chapter 8: Methods for Sparse Counts and Short Time Series

### Part D: Reporting and Interpretation
- Chapter 13: Effect Sizes and Confidence Intervals over P-Values
- Chapter 14: Transparent Reporting of Methods and Limitations
- Chapter 15: Interpreting Non-Significant Results
- Chapter 16: Visualising Uncertainty and Presenting Results

### Part E: Worked Projects
- Project 1: Evaluating a Marketing Campaign with Ordinal Outcomes
- Project 2: Assessing Reliability of a Short Service Quality Scale
- Project 3: Evaluating a Process Improvement Intervention (Paired Design)

## Prerequisites

### Software Requirements
- R (version 4.0 or later)
- RStudio (recommended)
- Quarto CLI

### Required R Packages

Install all required packages by running this in R:

```r
install.packages(c(
  "tidyverse",    # Data manipulation and visualisation
  "rstatix",      # Statistical tests with tidy output
  "boot",         # Bootstrap resampling
  "exact2x2",     # Exact tests for 2×2 tables
  "logistf",      # Firth-penalised logistic regression
  "gt",           # Publication-ready tables
  "performance",  # Model diagnostics
  "psych",        # Reliability and factor analysis
  "DescTools",    # Miscellaneous descriptive and test functions
  "brms"          # Bayesian regression (optional, requires RStan)
))
```

**Note**: Installing `brms` requires the RStan package, which may need additional configuration. See https://mc-stan.org/users/interfaces/rstan for installation instructions. If you skip `brms`, most examples will still run.

## Getting Started

### Quick Setup (Recommended)

For first-time setup, simply open the project in RStudio and run:

```r
source("setup.R")
```

This will:
- Check and install all required R packages
- Create necessary directories
- Generate the synthetic datasets
- Verify the installation

### Manual Setup

If you prefer to set up manually:

#### 1. Generate the Datasets

Before rendering the book or running examples, generate the synthetic datasets:

```r
# From the project root directory in R
source("R/make_datasets.R")
```

This creates three CSV files in the `data/` folder:
- `mini_marketing.csv` (n=30): Marketing campaign comparison
- `service_quality.csv` (n=36): Short scale for reliability analysis
- `process_change.csv` (n=20): Before–after intervention data

#### 2. Validate Installation

Check that everything is working correctly:

```r
source("validation_script.R")
```

This runs key examples from each chapter to verify your setup.

### Using RStudio

1. **Open the project**: Double-click `smallstat.Rproj` to open in RStudio
2. **Run setup**: In the R console, type `source("setup.R")`
3. **Explore chapters**: Open any `.qmd` file from the `chapters/` folder
4. **Run code chunks**: Click the green "Run" button on any code chunk

### Rendering the Book

#### 2. Preview the Book

To preview the book in your browser:

```powershell
# From PowerShell in the project root
quarto preview
```

This starts a local web server and opens the book in your browser. Changes to `.qmd` files will automatically trigger re-rendering.

#### 3. Render the Complete Book

To render the book to HTML:

```powershell
quarto render
```

The rendered book will be in the `_book/` directory. Open `_book/index.html` in a browser.

To render to multiple formats:

```powershell
# Render to all formats defined in _quarto.yml (HTML and DOCX)
quarto render --to all
```

To render only to Word/DOCX:

```powershell
quarto render --to docx
```

### 4. Run Individual Examples

Each chapter contains standalone code chunks. You can run them interactively in RStudio:

1. Open a chapter file (e.g., `chapters/part-c-analysis-methods.qmd`)
2. Click "Run" on individual code chunks, or "Run All" to execute all chunks
3. Results appear in the RStudio console and viewer

Alternatively, extract code from a chapter:

```r
# Extract all R code from a chapter
knitr::purl("chapters/part-c-analysis-methods.qmd", output = "extracted_code.R")

# Then source it
source("extracted_code.R")
```

## Project Structure

```
smallstat/
├── smallstat.Rproj          # RStudio project file (NEW)
├── .Rprofile                # Project startup script (NEW)
├── .gitignore               # Git ignore rules (NEW)
├── setup.R                  # Initial setup script (NEW)
├── validation_script.R      # Installation validation
├── _quarto.yml              # Book configuration
├── index.qmd                # Preface
├── references.bib           # BibTeX bibliography
├── references.qmd           # References page
├── README.md                # This file
├── chapters/
│   ├── part-a-foundations.qmd
│   ├── part-b-data-collection.qmd
│   ├── part-c-analysis-methods.qmd
│   ├── part-d-reporting.qmd
│   └── part-e-worked-projects.qmd
├── R/
│   ├── smalln_recipes.R     # Helper functions
│   └── make_datasets.R      # Dataset generation script
├── data/                    # Generated CSV files (after running make_datasets.R)
├── fig/                     # Figure directory (currently empty)
└── _book/                   # Rendered book output (after quarto render)
```

## Helper Functions

The `R/smalln_recipes.R` file contains documented helper functions:

- `mw_test()`: Mann–Whitney U test with Hodges–Lehmann CI
- `wilcoxon_paired_ci()`: Wilcoxon signed-rank test with pseudomedian CI
- `exact_2x2()`: Fisher's exact test for 2×2 tables
- `firth_logit_fit()`: Firth-penalised logistic regression
- `boot_median_ci()`: Bootstrap confidence interval for the median

To use them in your own analyses:

```r
source("R/smalln_recipes.R")

# Example: Mann–Whitney test
x <- c(7, 8, 6, 7, 9, 8)
y <- c(5, 6, 7, 5, 6, 5)
mw_test(x, y)
```

## Key Features

✅ **British English** throughout with traditional academic tone  
✅ **16 complete chapters** with learning objectives, examples, and key takeaways  
✅ **All code tested** and runnable in fresh R sessions  
✅ **Reproducible**: Uses `set.seed(2025)` for all random generation  
✅ **Curated package list**: Only vetted, stable packages used  
✅ **Three complete worked projects** integrating multiple methods  
✅ **Proper citations** to core methodological references  
✅ **Transparent reporting** emphasis throughout  

## Core References

The book draws on these key sources (full citations in `references.bib`):

- Van de Schoot & Miočević (2020). *Small Sample Size Solutions*
- Davison & Hinkley (1997). *Bootstrap Methods and Their Application*
- Good (2005). *Permutation, Parametric, and Bootstrap Tests of Hypotheses*
- Conover (1999). *Practical Nonparametric Statistics*
- Firth (1993). Bias Reduction of Maximum Likelihood Estimates. *Biometrika*
- Harrell (2015). *Regression Modeling Strategies*
- Hosmer, Lemeshow & Sturdivant (2013). *Applied Logistic Regression*
- Shan (2018). *Exact Statistical Inference for Categorical Data*

## Troubleshooting

### Issue: Quarto command not found
**Solution**: Install Quarto from https://quarto.org/docs/get-started/

### Issue: R packages fail to install
**Solution**: Ensure you have a recent version of R (4.0+) and Rtools (Windows) or Xcode Command Line Tools (macOS). Try installing packages one at a time to identify problematic packages.

### Issue: brms installation fails
**Solution**: `brms` requires RStan, which has system dependencies. Follow installation instructions at https://mc-stan.org/users/interfaces/rstan. If installation is too complex, you can skip `brms`; most examples will still run.

### Issue: Datasets not found when rendering
**Solution**: Run `source("R/make_datasets.R")` to generate the datasets before rendering.

### Issue: Rendering is slow
**Solution**: Quarto caches results by default for speed. If you modify code, delete the `_book/` directory and re-render to ensure fresh execution.

## Contributing

This book is designed as a teaching resource. If you identify errors, have suggestions for improvements, or want to contribute additional examples, please:

1. Document the issue clearly with chapter and line references
2. Provide reproducible examples if reporting code errors
3. Suggest specific improvements rather than general critiques

## License

This work is intended for educational purposes. All R code examples may be freely used and adapted with attribution. Please cite the book appropriately in any derivative works or publications.

## Citation

To cite this book:

> Quantitative Analysis with Small Samples: A Practical Guide for Students and Early-Career Researchers. (2025). Compiled Guide.

## Acknowledgements

This guide builds on the pioneering work of many contributors to small-sample methodology, particularly those conducting research in resource-constrained settings. The methods presented here reflect decades of statistical development aimed at making rigorous quantitative analysis accessible to researchers working with limited data.

---

**Last updated**: October 2025  
**Quarto version**: 1.3+  
**R version**: 4.0+
