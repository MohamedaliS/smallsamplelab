# .Rprofile for Small Sample Quantitative Analysis Book Project
# This file runs automatically when the project is opened in RStudio

.First <- function() {
  cat("\n")
  cat("=======================================================\n")
  cat("  Quantitative Analysis with Small Samples\n")
  cat("  A Practical Guide for Students and Researchers\n")
  cat("=======================================================\n\n")
  
  # Check for required packages
  required_pkgs <- c("tidyverse", "rstatix", "boot", "exact2x2", 
                     "logistf", "gt", "performance", "psych", "DescTools")
  
  missing_pkgs <- required_pkgs[!sapply(required_pkgs, requireNamespace, quietly = TRUE)]
  
  if (length(missing_pkgs) > 0) {
    cat("⚠️  Missing required packages:\n")
    cat("   ", paste(missing_pkgs, collapse = ", "), "\n\n")
    cat("Install them with:\n")
    cat('install.packages(c("', paste(missing_pkgs, collapse = '", "'), '"))\n\n', sep = "")
  } else {
    cat("✅ All required packages are installed!\n\n")
  }
  
  # Check for datasets
  if (!dir.exists("data") || length(list.files("data", pattern = "\\.csv$")) == 0) {
    cat("📊 Datasets not yet generated.\n")
    cat("   Run: source('R/make_datasets.R')\n\n")
  } else {
    cat("✅ Datasets found in data/ folder\n\n")
  }
  
  cat("Quick Start Commands:\n")
  cat("  source('R/make_datasets.R')    # Generate datasets\n")
  cat("  source('validation_script.R')  # Test installation\n")
  cat("  source('R/smalln_recipes.R')   # Load helper functions\n\n")
  
  cat("Render the book (in Terminal):\n")
  cat("  quarto render                  # Full render\n")
  cat("  quarto preview                 # Live preview\n\n")
}

# Set default options
options(
  repos = c(CRAN = "https://cloud.r-project.org/"),
  scipen = 6,
  digits = 4,
  stringsAsFactors = FALSE,
  width = 80
)

# Suppress startup messages for cleaner output
suppressPackageStartupMessages({
  # Load commonly used packages if available
  if (requireNamespace("tidyverse", quietly = TRUE)) {
    library(tidyverse)
  }
})
