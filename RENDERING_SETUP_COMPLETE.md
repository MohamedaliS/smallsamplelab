# Debug and Rendering Setup - Completion Summary

## Overview
This document summarizes the changes made to enable temporarily disabled sections and bootstrap code in the Small Sample Quantitative Analysis book project.

## Changes Completed

### 1. Enabled Part F (Technical Appendices)
**File**: `_quarto.yml` (lines 28-30)

**Before**:
```yaml
# - part: "Part F: Technical Appendices"
#   chapters:
#     - chapters/part-f-technical-appendices.qmd
```

**After**:
```yaml
- part: "Part F: Technical Appendices"
  chapters:
    - chapters/part-f-technical-appendices.qmd
```

**Impact**: Part F is now included in the book rendering and will appear in all output formats.

---

### 2. Added PDF Format Support
**File**: `_quarto.yml` (lines 41-54)

**Added**:
```yaml
format:
  html:
    theme: cosmo
    toc: true
    toc-depth: 3
    number-sections: true
    code-fold: false
    code-tools: true
    self-contained: false
  pdf:
    toc: true
    toc-depth: 3
    number-sections: true
    colorlinks: true
  docx:
    toc: true
    number-sections: true
    highlight-style: github
```

**Impact**: Book can now be rendered to PDF format (requires LaTeX/TinyTeX installation).

---

### 3. Enabled Bootstrap Code in Lab 2
**File**: `chapters/part-g-lab-practicals.qmd`

**Modified 5 code chunks** by removing `#| eval: false`:

1. **Lab 2, Step 3** (line ~429): Manual bootstrap method
   ```r
   n_boot <- 5000
   boot_medians <- numeric(n_boot)
   for (i in 1:n_boot) {
     boot_sample <- sample(vit_d, size = length(vit_d), replace = TRUE)
     boot_medians[i] <- median(boot_sample)
   }
   ```

2. **Lab 2, Step 4** (line ~465): Percentile bootstrap CI
   ```r
   ci_lower_boot <- quantile(boot_medians, 0.025)
   ci_upper_boot <- quantile(boot_medians, 0.975)
   ```

3. **Lab 2, Step 5** (line ~484): boot package BCa CI
   ```r
   boot_result <- boot(vit_d, statistic = median_func, R = 5000)
   boot.ci(boot_result, type = c("perc", "bca"))
   ```

4. **Lab 2, Step 7** (line ~538): Diagnostic checks
   ```r
   unique_samples <- length(unique(boot_medians))
   se_median_boot <- sd(boot_medians)
   bias <- mean(boot_medians) - median(vit_d)
   ```

5. **Lab 2, Step 8** (line ~564): Publication-ready figure
   ```r
   # Box plot with bootstrap CI overlay
   ggplot(aes(x = "", y = vit_d)) + geom_boxplot() + ...
   ```

**Impact**: All bootstrap code now executes when rendering, demonstrating bootstrap resampling, confidence intervals, and diagnostics.

---

### 4. Package Fallback System
**New File**: `R/package_fallbacks.R`

Created a comprehensive fallback system for packages that may not be available in all environments:

- **exact2x2** → Falls back to base R `fisher.test()`
- **logistf** → Falls back to standard `glm()` (without Firth correction)
- **gt** → Falls back to `knitr::kable()` for tables
- **naniar** → Custom implementations of missing data summaries
- **DescTools** → Base R equivalents
- **effsize** → Uses `effectsize` package if available

**Impact**: Book can render even when some specialized packages are unavailable, with informative messages about limitations.

---

### 5. Conditional Package Loading
**Files Modified**: Multiple chapter files

Added conditional loading patterns like:
```r
if (requireNamespace("naniar", quietly = TRUE)) {
  library(naniar)
  mcar_test(study_data)
} else {
  cat("Note: naniar package not available.\n")
  # Provide alternative or graceful degradation
}
```

**Impact**: Chapters handle missing packages gracefully without halting rendering.

---

## How to Render the Book

### Full Render (All Formats)
```bash
quarto render
```

This will generate:
- `_book/index.html` (HTML version)
- `_book/Quantitative-Analysis-with-Small-Samples.pdf` (PDF version - requires LaTeX)
- `_book/Quantitative-Analysis-with-Small-Samples.docx` (Word version)

### Render Specific Formats
```bash
quarto render --to html    # HTML only
quarto render --to pdf     # PDF only (requires LaTeX)
quarto render --to docx    # DOCX only
```

### Live Preview
```bash
quarto preview
```
Opens a browser with live-reloading preview.

---

## Prerequisites

### Essential
- R (4.0+)
- Quarto (1.3+)
- Core R packages: `tidyverse`, `knitr`, `rmarkdown`, `boot`, `mice`, `psych`, `rstatix`

### For PDF Rendering
```bash
quarto install tinytex
```

### Recommended R Packages
For full functionality, install these packages:
```r
install.packages(c(
  "exact2x2",   # Exact tests
  "logistf",    # Firth logistic regression
  "gt",         # Publication tables
  "naniar",     # Missing data visualization
  "DescTools",  # Descriptive statistics
  "effsize",    # Effect sizes
  "glmnet",     # Regularized regression
  "car",        # Diagnostics
  "pwr",        # Power analysis
  "brms"        # Bayesian models (optional)
))
```

---

## Verification

### Test Bootstrap Code
```r
# In R console
source("R/package_fallbacks.R")
source("chapters/part-g-lab-practicals.qmd")  # Or render the chapter
```

### Check Configuration
```bash
quarto check
```

### View Enabled Sections
```r
# In R, read the YAML
yaml::read_yaml("_quarto.yml")$book$chapters
```

---

## Summary of Enabled Features

| Feature | Status | Location |
|---------|--------|----------|
| Part F (Technical Appendices) | ✅ Enabled | `_quarto.yml` line 28-30 |
| PDF Format | ✅ Enabled | `_quarto.yml` line 47-50 |
| Bootstrap Step 3 | ✅ Enabled | `part-g-lab-practicals.qmd` line ~429 |
| Bootstrap Step 4 | ✅ Enabled | `part-g-lab-practicals.qmd` line ~465 |
| Bootstrap Step 5 | ✅ Enabled | `part-g-lab-practicals.qmd` line ~484 |
| Bootstrap Step 7 | ✅ Enabled | `part-g-lab-practicals.qmd` line ~538 |
| Bootstrap Step 8 | ✅ Enabled | `part-g-lab-practicals.qmd` line ~564 |
| Package Fallbacks | ✅ Created | `R/package_fallbacks.R` |

---

## Notes

1. **Bootstrap Code**: All 5 bootstrap code chunks in Lab 2 are now active and will execute during rendering, demonstrating:
   - Manual bootstrap resampling
   - Percentile confidence intervals
   - BCa (bias-corrected accelerated) confidence intervals
   - Bootstrap diagnostics (bias, standard error)
   - Publication-quality visualizations

2. **Part F Content**: The Technical Appendices section includes:
   - Pre-registration templates
   - Detailed R code examples
   - Practice exercises
   - Additional statistical background

3. **PDF Rendering**: Requires LaTeX. If you encounter LaTeX errors, ensure TinyTeX is installed:
   ```bash
   quarto install tinytex
   ```

4. **Package Availability**: The fallback system ensures the book renders even with missing packages, though some features may have reduced functionality.

---

## Troubleshooting

### Issue: Bootstrap code doesn't execute
**Solution**: Check that `#| eval: false` has been removed from the code chunks in `part-g-lab-practicals.qmd`.

### Issue: Part F doesn't appear
**Solution**: Verify lines 28-30 in `_quarto.yml` are uncommented.

### Issue: PDF rendering fails
**Solution**: Install LaTeX via `quarto install tinytex` or install a LaTeX distribution (TeX Live, MiKTeX).

### Issue: Missing package errors
**Solution**: Install missing packages or rely on the fallback system. Check `R/package_fallbacks.R` for alternatives.

---

## Contact

For issues or questions about these changes, refer to:
- `_quarto.yml` for book structure
- `R/package_fallbacks.R` for package handling
- `chapters/part-g-lab-practicals.qmd` for bootstrap code

All changes are version-controlled and can be reviewed in the Git history.
