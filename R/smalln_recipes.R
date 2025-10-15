# smalln_recipes.R
# Helper functions for small-sample quantitative analysis
# All functions include minimal documentation and examples

#' Mann–Whitney U Test with Hodges–Lehmann Confidence Interval
#'
#' Performs a Mann–Whitney U test (Wilcoxon rank-sum test) and returns
#' the Hodges–Lehmann estimate of the location shift with a confidence interval.
#'
#' @param x Numeric vector for group 1
#' @param y Numeric vector for group 2
#' @param conf.level Confidence level (default 0.95)
#' @return A list with test statistic, p-value, Hodges–Lehmann estimate, and CI
#' @examples
#' set.seed(2025)
#' x <- c(7, 8, 6, 7, 9, 8)
#' y <- c(5, 6, 7, 5, 6, 5)
#' mw_test(x, y)
mw_test <- function(x, y, conf.level = 0.95) {
  test_result <- wilcox.test(x, y, conf.int = TRUE, conf.level = conf.level)
  
  list(
    statistic = test_result$statistic,
    p.value = test_result$p.value,
    estimate = test_result$estimate,
    conf.int = test_result$conf.int,
    method = "Mann–Whitney U test with Hodges–Lehmann CI"
  )
}


#' Wilcoxon Signed-Rank Test with Pseudomedian Confidence Interval
#'
#' Performs a Wilcoxon signed-rank test for paired samples and returns
#' the pseudomedian (Hodges–Lehmann estimate of the median difference) with CI.
#'
#' @param x Numeric vector of pre-treatment or first measurement
#' @param y Numeric vector of post-treatment or second measurement (same length as x)
#' @param conf.level Confidence level (default 0.95)
#' @return A list with test statistic, p-value, pseudomedian estimate, and CI
#' @examples
#' set.seed(2025)
#' before <- c(110, 120, 115, 130, 125, 118)
#' after <- c(105, 115, 110, 125, 120, 112)
#' wilcoxon_paired_ci(before, after)
wilcoxon_paired_ci <- function(x, y, conf.level = 0.95) {
  if (length(x) != length(y)) {
    stop("x and y must have the same length for paired test")
  }
  
  test_result <- wilcox.test(x, y, paired = TRUE, conf.int = TRUE, conf.level = conf.level)
  
  list(
    statistic = test_result$statistic,
    p.value = test_result$p.value,
    estimate = test_result$estimate,
    conf.int = test_result$conf.int,
    method = "Wilcoxon signed-rank test with pseudomedian CI"
  )
}


#' Exact Test for 2×2 Contingency Table
#'
#' Wrapper around Fisher's exact test for 2×2 tables, with options
#' for one-sided or two-sided tests.
#'
#' @param a Count in cell (1,1)
#' @param b Count in cell (1,2)
#' @param c Count in cell (2,1)
#' @param d Count in cell (2,2)
#' @param alternative "two.sided", "greater", or "less"
#' @return A list with p-value, odds ratio estimate, and CI
#' @examples
#' # Example: treatment vs control, success vs failure
#' exact_2x2(a = 8, b = 2, c = 3, d = 7)
exact_2x2 <- function(a, b, c, d, alternative = "two.sided") {
  mat <- matrix(c(a, b, c, d), nrow = 2, byrow = TRUE)
  test_result <- fisher.test(mat, alternative = alternative)
  
  list(
    p.value = test_result$p.value,
    odds_ratio = test_result$estimate,
    conf.int = test_result$conf.int,
    method = "Fisher's exact test for 2×2 table"
  )
}


#' Firth-Penalised Logistic Regression
#'
#' Fits a logistic regression model using Firth's bias-reduction method,
#' which is useful when sample size is small or when separation occurs.
#'
#' @param formula A formula object (e.g., outcome ~ predictor1 + predictor2)
#' @param data A data frame
#' @return A fitted logistf object with penalised coefficients
#' @examples
#' library(logistf)
#' set.seed(2025)
#' dat <- data.frame(
#'   y = c(1, 1, 1, 1, 0, 0, 0, 0, 1, 0),
#'   x = c(2, 3, 3, 4, 1, 1, 2, 2, 3, 1)
#' )
#' firth_logit_fit(y ~ x, data = dat)
firth_logit_fit <- function(formula, data) {
  if (!requireNamespace("logistf", quietly = TRUE)) {
    stop("Package 'logistf' is required. Install it with install.packages('logistf')")
  }
  
  fit <- logistf::logistf(formula, data = data)
  fit
}


#' Bootstrap Confidence Interval for the Median
#'
#' Computes a percentile bootstrap confidence interval for the median of a vector.
#'
#' @param x Numeric vector
#' @param conf.level Confidence level (default 0.95)
#' @param R Number of bootstrap replicates (default 2000)
#' @return A list with the sample median and bootstrap CI
#' @examples
#' set.seed(2025)
#' x <- c(12, 15, 14, 18, 16, 13, 17, 19, 14, 15)
#' boot_median_ci(x, R = 1000)
boot_median_ci <- function(x, conf.level = 0.95, R = 2000) {
  if (!requireNamespace("boot", quietly = TRUE)) {
    stop("Package 'boot' is required. Install it with install.packages('boot')")
  }
  
  set.seed(2025)  # for reproducibility within function
  
  median_fun <- function(data, indices) {
    median(data[indices])
  }
  
  boot_result <- boot::boot(data = x, statistic = median_fun, R = R)
  ci <- boot::boot.ci(boot_result, conf = conf.level, type = "perc")
  
  list(
    sample_median = median(x),
    boot_ci = ci$percent[4:5],
    method = "Percentile bootstrap CI for median"
  )
}


# End of smalln_recipes.R
