# validation_script.R
# Quick validation script to test key code examples from the book
# Run this to verify that all required packages are installed and working

cat("=== SMALL-SAMPLE QUANTITATIVE ANALYSIS BOOK ===\n")
cat("=== VALIDATION SCRIPT ===\n\n")

# Check for required packages
required_packages <- c(
  "tidyverse", "rstatix", "boot", "exact2x2", 
  "logistf", "gt", "performance", "psych", 
  "DescTools"
)

cat("Checking for required packages...\n")
missing_packages <- c()

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    missing_packages <- c(missing_packages, pkg)
    cat("  [X]", pkg, "- NOT INSTALLED\n")
  } else {
    cat("  [✓]", pkg, "\n")
  }
}

if (length(missing_packages) > 0) {
  cat("\nMissing packages detected. Install them with:\n")
  cat("install.packages(c(", paste0('"', missing_packages, '"', collapse = ", "), "))\n\n")
  stop("Please install missing packages before proceeding.")
} else {
  cat("\nAll required packages are installed!\n\n")
}

# Check for optional packages
cat("Checking for optional packages...\n")
if (requireNamespace("brms", quietly = TRUE)) {
  cat("  [✓] brms (Bayesian regression)\n")
} else {
  cat("  [~] brms - not installed (optional, required for Bayesian examples)\n")
}

if (requireNamespace("mice", quietly = TRUE)) {
  cat("  [✓] mice (multiple imputation)\n")
} else {
  cat("  [~] mice - not installed (optional, required for missing data examples)\n")
}

cat("\n")

# Check for datasets
cat("Checking for generated datasets...\n")
datasets <- c("mini_marketing.csv", "service_quality.csv", "process_change.csv")
missing_data <- c()

for (ds in datasets) {
  path <- file.path("data", ds)
  if (file.exists(path)) {
    cat("  [✓]", ds, "\n")
  } else {
    cat("  [X]", ds, "- NOT FOUND\n")
    missing_data <- c(missing_data, ds)
  }
}

if (length(missing_data) > 0) {
  cat("\nDatasets not found. Generate them with:\n")
  cat('source("R/make_datasets.R")\n\n')
} else {
  cat("\nAll datasets found!\n\n")
}

# Test key functions from each chapter
cat("=== TESTING KEY EXAMPLES ===\n\n")

library(tidyverse)

# Test Chapter 1: Mann-Whitney U test
cat("Chapter 1: Mann-Whitney U Test\n")
suppressMessages({
  library(rstatix)
  set.seed(2025)
  branch_a <- c(7, 8, 6, 7, 9, 8)
  branch_b <- c(5, 6, 7, 5, 6, 5)
  test_data <- tibble(value = c(branch_a, branch_b), 
                      group = rep(c("A", "B"), each = 6))
  result <- wilcox_test(test_data, value ~ group)
  cat("  p-value:", round(result$p, 3), "\n")
  cat("  [✓] Test passed\n\n")
})

# Test Chapter 3: Fisher's exact test
cat("Chapter 3: Fisher's Exact Test\n")
suppressMessages({
  table_data <- matrix(c(8, 3, 2, 7), nrow = 2, byrow = TRUE)
  result <- fisher.test(table_data)
  cat("  Odds ratio:", round(result$estimate, 2), "\n")
  cat("  p-value:", round(result$p.value, 3), "\n")
  cat("  [✓] Test passed\n\n")
})

# Test Chapter 3: Exact binomial test
cat("Chapter 3: Exact Binomial Test\n")
suppressMessages({
  result <- binom.test(x = 13, n = 15, p = 0.70)
  cat("  p-value:", round(result$p.value, 3), "\n")
  cat("  [✓] Test passed\n\n")
})

# Test Chapter 3: Bootstrap CI
cat("Chapter 3: Bootstrap Confidence Interval\n")
suppressMessages({
  library(boot)
  set.seed(2025)
  recovery_times <- c(12, 15, 14, 18, 16, 13, 17, 19, 14, 15)
  median_fun <- function(data, indices) { median(data[indices]) }
  boot_result <- boot(data = recovery_times, statistic = median_fun, R = 1000)
  ci <- boot.ci(boot_result, conf = 0.95, type = "perc")
  cat("  Sample median:", median(recovery_times), "\n")
  cat("  95% CI:", round(ci$percent[4:5], 2), "\n")
  cat("  [✓] Test passed\n\n")
})

# Test Chapter 4: Wilcoxon signed-rank
cat("Chapter 4: Wilcoxon Signed-Rank Test\n")
suppressMessages({
  before <- c(65, 70, 68, 72, 75, 69)
  after <- c(60, 65, 64, 68, 70, 63)
  result <- wilcox.test(before, after, paired = TRUE)
  cat("  p-value:", round(result$p.value, 3), "\n")
  cat("  [✓] Test passed\n\n")
})

# Test Chapter 5: Firth logistic regression
cat("Chapter 5: Firth-Penalised Logistic Regression\n")
suppressMessages({
  library(logistf)
  set.seed(2025)
  dat <- data.frame(
    y = c(1, 1, 1, 1, 0, 0, 0, 0, 1, 0),
    x = c(2, 3, 3, 4, 1, 1, 2, 2, 3, 1)
  )
  fit <- logistf(y ~ x, data = dat)
  cat("  Coefficient for x:", round(fit$coefficients[2], 3), "\n")
  cat("  [✓] Test passed\n\n")
})

# Test Chapter 6: Cronbach's alpha
cat("Chapter 6: Cronbach's Alpha\n")
suppressMessages({
  library(psych)
  set.seed(2025)
  items <- data.frame(
    item1 = sample(1:5, 20, replace = TRUE),
    item2 = sample(1:5, 20, replace = TRUE),
    item3 = sample(1:5, 20, replace = TRUE)
  )
  result <- alpha(items)
  cat("  Alpha:", round(result$total$raw_alpha, 3), "\n")
  cat("  [✓] Test passed\n\n")
})

# Test Chapter 8: Exact Poisson test
cat("Chapter 8: Exact Poisson Test\n")
suppressMessages({
  result <- poisson.test(x = 15, T = 5, r = 2)
  cat("  p-value:", round(result$p.value, 3), "\n")
  cat("  Rate estimate:", round(result$estimate, 2), "\n")
  cat("  [✓] Test passed\n\n")
})

# Test helper functions
cat("=== TESTING HELPER FUNCTIONS ===\n\n")

source("R/smalln_recipes.R")

cat("Helper: mw_test()\n")
suppressMessages({
  set.seed(2025)
  x <- c(7, 8, 6, 7, 9, 8)
  y <- c(5, 6, 7, 5, 6, 5)
  result <- mw_test(x, y)
  cat("  p-value:", round(result$p.value, 3), "\n")
  cat("  [✓] Function works\n\n")
})

cat("Helper: exact_2x2()\n")
suppressMessages({
  result <- exact_2x2(a = 8, b = 2, c = 3, d = 7)
  cat("  p-value:", round(result$p.value, 3), "\n")
  cat("  [✓] Function works\n\n")
})

cat("Helper: boot_median_ci()\n")
suppressMessages({
  set.seed(2025)
  x <- c(12, 15, 14, 18, 16, 13, 17, 19, 14, 15)
  result <- boot_median_ci(x, R = 500)
  cat("  Median:", result$sample_median, "\n")
  cat("  [✓] Function works\n\n")
})

# Summary
cat("=== VALIDATION COMPLETE ===\n\n")
cat("All key examples executed successfully!\n")
cat("The book is ready to use.\n\n")
cat("Next steps:\n")
cat("  1. Generate datasets: source('R/make_datasets.R')\n")
cat("  2. Preview book: quarto preview\n")
cat("  3. Render book: quarto render\n\n")
