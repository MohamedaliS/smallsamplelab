# make_datasets.R
# Generate synthetic datasets for small-sample quantitative analysis examples
# Run this script once to create CSVs in the data/ folder

library(tidyverse)

# Create data directory if it doesn't exist
if (!dir.exists("data")) {
  dir.create("data", recursive = TRUE)
}

set.seed(2025)

# -------------------------------------------------------------------------
# Dataset 1: mini_marketing.csv
# n ≈ 30, ordinal outcome (customer satisfaction rating 1–5)
# Two groups: email campaign vs social media campaign
# -------------------------------------------------------------------------
n_email <- 15
n_social <- 15

satisfaction_email <- sample(2:5, n_email, replace = TRUE, prob = c(0.2, 0.3, 0.3, 0.2))
satisfaction_social <- sample(1:4, n_social, replace = TRUE, prob = c(0.1, 0.3, 0.4, 0.2))

mini_marketing <- tibble(
  id = 1:(n_email + n_social),
  campaign = rep(c("Email", "Social"), c(n_email, n_social)),
  satisfaction = c(satisfaction_email, satisfaction_social),
  age_group = sample(c("18-34", "35-54", "55+"), n_email + n_social, replace = TRUE),
  prior_purchase = sample(c("Yes", "No"), n_email + n_social, replace = TRUE, prob = c(0.6, 0.4))
)

write_csv(mini_marketing, "data/mini_marketing.csv")
cat("Created data/mini_marketing.csv (n =", nrow(mini_marketing), ")\n")


# -------------------------------------------------------------------------
# Dataset 2: service_quality.csv
# n ≈ 36, short 3-item scale (each item 1–7 Likert)
# Use case: reliability analysis, internal consistency
# -------------------------------------------------------------------------
n_respondents <- 36

# Simulate correlated responses (assume moderate reliability)
latent_quality <- rnorm(n_respondents, mean = 5, sd = 1.2)
item1 <- round(pmin(7, pmax(1, latent_quality + rnorm(n_respondents, 0, 0.8))))
item2 <- round(pmin(7, pmax(1, latent_quality + rnorm(n_respondents, 0, 0.8))))
item3 <- round(pmin(7, pmax(1, latent_quality + rnorm(n_respondents, 0, 0.9))))

service_quality <- tibble(
  respondent_id = 1:n_respondents,
  branch = sample(c("North", "South", "East"), n_respondents, replace = TRUE),
  q1_responsiveness = item1,
  q2_professionalism = item2,
  q3_clarity = item3
)

write_csv(service_quality, "data/service_quality.csv")
cat("Created data/service_quality.csv (n =", nrow(service_quality), ")\n")


# -------------------------------------------------------------------------
# Dataset 3: process_change.csv
# n ≈ 20, paired before–after design
# Outcome: a small count KPI (e.g., defects per batch, customer complaints per week)
# -------------------------------------------------------------------------
n_units <- 20

# Simulate before and after counts (Poisson-like, after has lower rate)
before_count <- rpois(n_units, lambda = 4.5)
after_count <- rpois(n_units, lambda = 3.0)

# Ensure at least some variation
before_count <- pmax(before_count, 1)
after_count[after_count == 0] <- sample(0:2, sum(after_count == 0), replace = TRUE)

process_change <- tibble(
  unit_id = 1:n_units,
  department = sample(c("Production", "Logistics", "QA"), n_units, replace = TRUE),
  before = before_count,
  after = after_count,
  change = after - before
)

write_csv(process_change, "data/process_change.csv")
cat("Created data/process_change.csv (n =", nrow(process_change), ")\n")


# -------------------------------------------------------------------------
# Summary
# -------------------------------------------------------------------------
cat("\nAll datasets generated successfully.\n")
cat("Use read_csv('data/<filename>.csv') to load them in your analysis scripts.\n")
