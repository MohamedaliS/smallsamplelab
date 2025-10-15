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
# Dataset 4: hospital_readmissions.csv
# n = 25, binary outcome with rare events for Firth logistic regression
# -------------------------------------------------------------------------
hospital_data <- tibble(
  patient_id = 1:25,
  age = sample(45:85, 25, replace = TRUE),
  comorbidities = sample(0:4, 25, replace = TRUE),
  length_of_stay = sample(2:10, 25, replace = TRUE),
  readmitted_30d = c(1,1,1,0,1,0,0,0,1,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0)
)

write_csv(hospital_data, "data/hospital_readmissions.csv")
cat("Created data/hospital_readmissions.csv (n =", nrow(hospital_data), ")\n")


# -------------------------------------------------------------------------
# Dataset 5: employee_engagement.csv
# n = 36, five-item Likert scale with one reverse-coded item for reliability
# -------------------------------------------------------------------------
latent_engagement <- rnorm(n_respondents, mean = 4, sd = 1)

engagement_data <- tibble(
  employee_id = 1:n_respondents,
  department = sample(c("Sales", "IT", "HR"), n_respondents, replace = TRUE),
  q1_satisfaction = round(pmin(7, pmax(1, latent_engagement + rnorm(n_respondents, 0, 0.9)))),
  q2_commitment = round(pmin(7, pmax(1, latent_engagement + rnorm(n_respondents, 0, 0.8)))),
  q3_advocacy = round(pmin(7, pmax(1, latent_engagement + rnorm(n_respondents, 0, 0.9)))),
  q4_turnover_intent = round(pmin(7, pmax(1, 8 - latent_engagement + rnorm(n_respondents, 0, 1.0)))),
  q5_performance = round(pmin(7, pmax(1, latent_engagement + rnorm(n_respondents, 0, 1.1))))
)

write_csv(engagement_data, "data/employee_engagement.csv")
cat("Created data/employee_engagement.csv (n =", nrow(engagement_data), ")\n")


# -------------------------------------------------------------------------
# Dataset 6: ab_test_sparse.csv
# n = 40, sparse conversions for Fisher's exact test practice
# -------------------------------------------------------------------------
ab_test_data <- tibble(
  user_id = 1:40,
  variant = rep(c("A", "B"), each = 20),
  converted = c(rep(0, 17), rep(1, 3), rep(0, 18), rep(1, 2))
)

write_csv(ab_test_data, "data/ab_test_sparse.csv")
cat("Created data/ab_test_sparse.csv (n =", nrow(ab_test_data), ")\n")


# -------------------------------------------------------------------------
# Dataset 7: anxiety_study.csv
# n = 40 (20 per group), small effect mindfulness intervention example
# -------------------------------------------------------------------------
n_group <- 20
n_total <- 2 * n_group

condition <- rep(c("Mindfulness", "Control"), each = n_group)
baseline_anxiety <- round(rnorm(n_total, mean = 50, sd = 8), 1)
regular_meditation <- sample(c("Yes", "No"), n_total, replace = TRUE, prob = c(0.15, 0.85))
prior_experience <- sample(c("None", "Limited", "Extensive"), n_total, replace = TRUE,
                           prob = c(0.45, 0.4, 0.15))

anxiety_reduction <- ifelse(
  condition == "Mindfulness",
  rnorm(n_total, mean = 6, sd = 4),
  rnorm(n_total, mean = 2, sd = 4)
)

test_anxiety <- round(pmax(baseline_anxiety - anxiety_reduction, 20), 1)

anxiety_study <- tibble(
  participant_id = 1:n_total,
  condition = condition,
  baseline_anxiety = baseline_anxiety,
  test_anxiety = test_anxiety,
  regular_meditation = regular_meditation,
  prior_experience = prior_experience
)

write_csv(anxiety_study, "data/anxiety_study.csv")
cat("Created data/anxiety_study.csv (n =", nrow(anxiety_study), ")\n")


# -------------------------------------------------------------------------
# Dataset 8: reliability_exercise.csv
# n = 25, three correlated Likert-style items (1–5)
# -------------------------------------------------------------------------
n_items <- 25
latent_trait <- rnorm(n_items, mean = 4, sd = 0.6)

reliability_items <- tibble(
  item1 = pmin(5, pmax(1, round(latent_trait + rnorm(n_items, 0, 0.5)))),
  item2 = pmin(5, pmax(1, round(latent_trait + rnorm(n_items, 0, 0.5)))),
  item3 = pmin(5, pmax(1, round(latent_trait + rnorm(n_items, 0, 0.6))))
)

write_csv(reliability_items, "data/reliability_exercise.csv")
cat("Created data/reliability_exercise.csv (n =", nrow(reliability_items), ")\n")


# -------------------------------------------------------------------------
# Dataset 9: quiz2_data.csv
# n = 24, ordinal outcome for classroom exercises (12 per group)
# -------------------------------------------------------------------------
quiz_group <- rep(c("Control", "Intervention"), each = 12)
satisfaction_levels <- c(1, 2, 3, 4, 5)

quiz2_data <- tibble(
  participant_id = seq_along(quiz_group),
  group = quiz_group,
  satisfaction = ifelse(
    quiz_group == "Intervention",
    sample(satisfaction_levels, length(quiz_group), replace = TRUE, prob = c(0.05, 0.15, 0.3, 0.35, 0.15)),
    sample(satisfaction_levels, length(quiz_group), replace = TRUE, prob = c(0.15, 0.3, 0.3, 0.2, 0.05))
  )
)

write_csv(quiz2_data, "data/quiz2_data.csv")
cat("Created data/quiz2_data.csv (n =", nrow(quiz2_data), ")\n")


# -------------------------------------------------------------------------
# Summary
# -------------------------------------------------------------------------
cat("\nAll datasets generated successfully.\n")
cat("Use read_csv('data/<filename>.csv') to load them in your analysis scripts.\n")
