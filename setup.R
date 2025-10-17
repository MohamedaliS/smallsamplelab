# setup.R
# Initial setup script for the Small Sample Quantitative Analysis Book
# Run this script once after cloning/downloading the project

cat("==========================================================\n")
cat("  Small Sample Quantitative Analysis Book - Setup\n")
cat("==========================================================\n\n")

# Function to check and install packages
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) {
    cat("Installing missing packages:", paste(new_packages, collapse = ", "), "\n")
    install.packages(new_packages, dependencies = TRUE)
  } else {
    cat("✓ All packages already installed\n")
  }
}

# Required packages
required_packages <- c(
  "tidyverse",    # Data manipulation and visualisation
  "rstatix",      # Statistical tests with tidy output
  "boot",         # Bootstrap resampling
  "exact2x2",     # Exact tests for 2×2 tables
  "logistf",      # Firth-penalised logistic regression
  "gt",           # Publication-ready tables
  "performance",  # Model diagnostics
  "psych",        # Reliability and factor analysis
  "DescTools"     # Miscellaneous descriptive and test functions
)

cat("\n1. Checking and installing required packages...\n")
install_if_missing(required_packages)

# Optional packages
cat("\n2. Checking optional packages...\n")

optional_packages <- list(
  brms = "Bayesian regression (requires RStan, can be complex to install)",
  rstanarm = "Bayesian regression (lighter Stan interface; precompiled models)",
  mice = "Multiple imputation for missing data",
  pwr = "Power analysis calculations"
)

for (pkg in names(optional_packages)) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat("  ✓", pkg, "- installed\n")
  } else {
    cat("  ○", pkg, "- not installed (", optional_packages[[pkg]], ")\n")
  }
}

cat("\nTo install optional packages:\n")
 cat('  install.packages(c("mice", "pwr"))\n')
 cat('  install.packages("rstanarm")  # Lighter Stan interface; often easier for examples\n')
 cat('  install.packages("brms")  # Requires RStan - see: https://mc-stan.org/\n\n')

# Create necessary directories
cat("3. Creating project directories...\n")
dirs_to_create <- c("data", "fig", "chapters", "R", "_book")
for (dir in dirs_to_create) {
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
    cat("  Created:", dir, "\n")
  } else {
    cat("  ✓", dir, "already exists\n")
  }
}

# Generate datasets
cat("\n4. Generating synthetic datasets...\n")
if (file.exists("R/make_datasets.R")) {
  source("R/make_datasets.R")
  cat("  ✓ Datasets generated in data/ folder\n")
} else {
  cat("  ⚠ R/make_datasets.R not found\n")
}

# Verify setup
cat("\n5. Verifying setup...\n")
datasets <- c("mini_marketing.csv", "service_quality.csv", "process_change.csv")
all_present <- TRUE
for (ds in datasets) {
  path <- file.path("data", ds)
  if (file.exists(path)) {
    cat("  ✓", ds, "\n")
  } else {
    cat("  ✗", ds, "- not found\n")
    all_present <- FALSE
  }
}

# Final instructions
cat("\n==========================================================\n")
if (all_present) {
  cat("✅ Setup complete! You're ready to use the book.\n\n")
  cat("Next steps:\n")
  cat("  • Open smallstat.Rproj in RStudio\n")
  cat("  • Run validation: source('validation_script.R')\n")
  cat("  • Render book: In Terminal, run 'quarto render'\n")
  cat("  • Preview book: In Terminal, run 'quarto preview'\n")
} else {
  cat("⚠️  Setup incomplete. Please check the errors above.\n")
}
cat("==========================================================\n\n")

cat("For help, see README.md\n")
