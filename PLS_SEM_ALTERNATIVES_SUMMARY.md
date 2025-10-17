# PLS-SEM Alternatives Implementation Summary

**Date**: January 2025  
**Decision**: Rejected PLS-SEM inclusion; implemented 4 appropriate alternatives for n = 50-100

---

## Background: Why NOT PLS-SEM?

User asked: "What will be the verdict of this book if we include pls-sem?"

**Analysis Conclusion**: PLS-SEM is **inappropriate** for this book because:

1. **Contradicts Book Philosophy**: Book explicitly states "SEM requires n ≥ 200-400" (Chapter 6, line 2875) and warns "Do NOT force these analyses with inadequate sample sizes"

2. **Sample Size Reality**: Despite marketing as "small-sample friendly," PLS-SEM realistically needs:
   - n ≥ 100 for reliability (minimum)
   - n ≥ 150-300 for stable results
   - 10× rule (n = 10 × largest number of predictors) often insufficient

3. **High Misuse Risk**: Students would use PLS-SEM with n = 30-50, get unreliable results, and publish flawed findings

4. **Better Alternatives Exist**: Penalized regression, reliability analysis, and composite scores already in book

**User Decision**: "Good. Implement the recommendations" → Approved 4-task alternative plan

---

## Implementation: 4 Tasks Completed

### ✅ Task 1: Ridge/Lasso/Elastic Net Regression (Chapter 5)

**Location**: `part-c-analysis-methods.qmd`, inserted between Lab Practical 5.1 (line 1818) and Self-Assessment Quiz (line 1829)

**Lines Added**: ~600 lines

**Content**:
1. **Theory Section**:
   - When standard regression fails (multicollinearity, p > n)
   - Ridge regression (L2 penalty): shrinks coefficients, handles correlated predictors
   - Lasso regression (L1 penalty): variable selection, sparse solutions
   - Elastic net: combines ridge + lasso

2. **Practical Implementation**:
   - `glmnet` package demonstration
   - Cross-validation for lambda selection
   - Standardization of predictors
   - Ridge (alpha = 0), Lasso (alpha = 1), Elastic Net (alpha = 0.5)

3. **Worked Example**: Employee retention (n = 60, 8 predictors)
   - Training/test split
   - cv.glmnet() for optimal lambda
   - Coefficient extraction and interpretation
   - Comparison: Ridge vs. Lasso vs. Elastic Net

4. **Guidelines**:
   - **Ridge**: Use when all predictors important, multicollinearity present (n ≥ 40)
   - **Lasso**: Use for variable selection, sparse models (n ≥ 50)
   - **Elastic Net**: Use when both variable selection and correlated predictors (n ≥ 50)

5. **Sample Size Recommendations**:
   - Ridge: n ≥ 40 (most flexible)
   - Lasso: n ≥ 50 (less stable at very small n)
   - Elastic Net: n ≥ 50
   - All: p/n ratio should be < 0.5 for stability

**Impact**: Addresses the core problem PLS-SEM users face—multiple predictors with small n. Penalized regression is honest, appropriate for n = 50-100, and has strong theoretical foundation.

---

### ✅ Task 2: Simple Mediation Analysis (Part E, Project 5)

**Location**: `part-e-worked-projects.qmd`, added Project 5 after Project 4 (line 1064)

**Lines Added**: ~350 lines

**Dataset Created**: `mediation_example.csv` (n = 100, 7 variables)
- **Design**: Growth mindset intervention study
- **Variables**: intervention (0/1), self_efficacy (1-10), exam_score (0-100), age, gender, prior_gpa
- **Key Feature**: Temporal ordering (Intervention → Self-Efficacy Week 6 → Exam Week 8)

**Content**:
1. **Research Context**:
   - University psychology pilot: growth mindset intervention for struggling stats students
   - Primary question: Does intervention improve exam scores?
   - Mechanistic question: **How?** Via increased self-efficacy?
   - Mediation hypothesis: Intervention → Self-Efficacy → Exam Score

2. **Baron & Kenny Approach**:
   - Path c (Total Effect): X → Y (b = 15.3, p < .001)
   - Path a: X → M (b = 2.7, p < .001)
   - Path b: M → Y, controlling X (b = 4.5, p < .001)
   - Path c' (Direct Effect): X → Y, controlling M (b = 3.2, p = .043)
   - **Conclusion**: Partial mediation (c' reduced from 15.3 to 3.2)

3. **Modern Bootstrap Approach**:
   - `mediation` package with 5000 bootstrap iterations
   - **ACME (Indirect Effect)**: 12.1 points (95% CI [10.2, 14.0], p < .001)
   - **ADE (Direct Effect)**: 3.2 points (95% CI [0.1, 6.3], p = .043)
   - **Proportion Mediated**: 79% (self-efficacy accounts for 79% of total effect)

4. **Sensitivity Analysis**:
   - Tests robustness to unmeasured confounding (ρ parameter)
   - Result: Mediation holds until ρ ≈ 0.5-0.6 (very strong confounding)
   - Conclusion: Finding is **robust**

5. **Covariate-Adjusted Models**:
   - Controlled for prior_gpa, age, gender
   - Results remain stable (ACME ≈ 12.0, ADE ≈ 3.3, 78% mediated)

6. **Path Diagram Visualization**:
   - ggplot2-based diagram showing paths a, b, c' with coefficients
   - Significance stars, effect size annotations

7. **Discussion**:
   - **Limitations**: Single mediator, unmeasured confounding, generalizability
   - **Recommendations**: Longitudinal design, multiple mediators, multi-site trial (n ≥ 300)
   - **Methodological Takeaways**: 7 best practices for mediation analysis

8. **Sample Size Guidance**:
   - n ≥ 80-100 minimum for bootstrap
   - n ≥ 150 for multiple mediators or moderated mediation

**Impact**: Provides students with appropriate method for "how/why" questions. Mediation at n = 100 is defensible (unlike SEM/CFA which need n ≥ 200). Emphasizes caution: "consistent with mediation" ≠ causal proof.

---

### ✅ Task 3: SEM Sample Size Sidebar (Chapter 6)

**Location**: `part-c-analysis-methods.qmd`, replaced "Analyses That Require Larger Samples" section (line 2870)

**Lines Added**: ~200 lines (1-page collapsible callout)

**Content**:
1. **Updated Warning Box**:
   - Added PLS-SEM to list (despite "small-sample friendly" claims, needs n ≥ 100)
   - Explicit: "Do NOT force these analyses with inadequate sample sizes"

2. **Collapsible Callout**: "Why Structural Equation Modeling (SEM) Requires Large Samples"
   - **Question Addressed**: "Can I use SEM, CFA, or PLS-SEM with my small sample (n < 100)?"
   - **Short Answer**: **No.**

3. **Sample Size Table**:
   | Method | Minimum n | Realistic n | Why? |
   |--------|-----------|-------------|------|
   | CFA | 150 | 200-300 | Stable factor loadings, fit indices |
   | SEM | 200 | 300-500 | Complex paths, multiple latent variables |
   | PLS-SEM | 100 | 150-300 | Despite marketing, needs 100+ for reliability |
   | Multi-Group SEM | 200/group | 300/group | Measurement invariance testing |

4. **What Happens If You Ignore These Requirements?** (5 failure modes)
   - ❌ Unstable parameter estimates (loadings fluctuate wildly)
   - ❌ Non-convergent solutions (Heywood cases, negative variances)
   - ❌ Unreliable fit indices (χ², CFI, TLI, RMSEA meaningless)
   - ❌ Overfit models (perfect sample fit, fails to generalize)
   - ❌ False confidence (software produces output = garbage in, garbage out)

5. **Small-Sample Alternatives Table** (n < 100):
   | SEM Goal | Small-Sample Alternative | Chapter | Minimum n |
   |----------|-------------------------|---------|-----------|
   | Assess reliability | Cronbach's α, McDonald's ω | Ch 6 | 30-50 |
   | Validate items | Item-total correlations | Ch 6 | 30-50 |
   | Reduce dimensions | **Composite scores** | Ch 6 | 20+ |
   | Test relationships | Regression with composites | Ch 5 | 30-50 |
   | Multiple predictors | Ridge/lasso/elastic net | Ch 5 Lab 5.2 | 50-100 |
   | Mediation | Simple mediation + bootstrap | Part E Project 5 | 80-100 |
   | Latent correlations | Polychoric correlations | Ch 6 | 50+ |

6. **Example**: Replacing SEM with Composite-Score Analysis
   - Proposed SEM: Job_Satisfaction (5 items) → Performance (4 items) → Turnover_Intent (3 items), n = 60
   - Alternative: Create composites via `rowMeans()`, use standard regression
   - **Advantages**: Works with n = 60, interpretable, robust, honest
   - **Limitations to Acknowledge**: Measurement error, no complex factor structures

7. **Software Warning**:
   - SmartPLS, AMOS, Mplus will run with n = 50
   - They will produce output (estimates, p-values, fit indices, path diagrams)
   - **This does NOT mean results are trustworthy**
   - Software cannot judge adequacy—**you must**

8. **Recommended Reading** (for future large-sample studies, n ≥ 200):
   - Kline (2016) *Principles and Practice of SEM*
   - Brown (2015) *CFA for Applied Research*
   - Hair et al. (2022) *PLS-SEM Primer*
   - Hoyle (2023) *Handbook of SEM*

9. **Bottom Line**:
   - For n = 10-100, use methods in this book (appropriate, robust, honest, defensible)
   - Save SEM for when you have n ≥ 200
   - Until then, composite scores + regression serve you well

**Impact**: Prevents misuse by clearly explaining WHY SEM requires large samples and WHAT to do instead. Protects students from wasting time on inappropriate analyses. Positions book's methods as principled alternatives, not inferior substitutes.

---

### ✅ Task 4: Update Package Lists and References

#### A. `index.qmd` Package List (Lines 85-103)

**Packages Added**:
- **glmnet**: ridge, lasso, and elastic net regression
- **mediation**: simple mediation analysis with bootstrap CIs
- **patchwork**: combining plots

**Updated Installation Code**:
```r
install.packages(c("tidyverse", "rstatix", "boot", "exact2x2", 
                   "logistf", "glmnet", "mediation", "gt", 
                   "performance", "psych", "DescTools", "patchwork",
                   "brms"))
```

#### B. `references.bib` Citations Added

**Ridge/Lasso/Elastic Net**:
1. **hastie2009**: Hastie, Tibshirani, Friedman (2009). *The Elements of Statistical Learning* (2nd ed.). Springer.
   - Comprehensive SEM textbook reference (Ch 3: Ridge/Lasso theory)

2. **friedman2010**: Friedman, Hastie, Tibshirani (2010). "Regularization Paths for Generalized Linear Models via Coordinate Descent." *Journal of Statistical Software*, 33(1), 1-22.
   - glmnet package paper (computational methods)

**Mediation Analysis**:
3. **baron1986**: Baron & Kenny (1986). "The Moderator–Mediator Variable Distinction." *Journal of Personality and Social Psychology*, 51(6), 1173-1182.
   - Classic Baron & Kenny approach

4. **tingley2014**: Tingley et al. (2014). "mediation: R Package for Causal Mediation Analysis." *Journal of Statistical Software*, 59(5), 1-38.
   - mediation package documentation

5. **hayes2022**: Hayes (2022). *Introduction to Mediation, Moderation, and Conditional Process Analysis* (3rd ed.). Guilford Press.
   - Comprehensive mediation/PROCESS guide

6. **mackinnon2008**: MacKinnon (2008). *Introduction to Statistical Mediation Analysis*. Routledge.
   - Technical treatment of mediation theory

7. **preacher2008**: Preacher & Hayes (2008). "Asymptotic and Resampling Strategies for Assessing Indirect Effects." *Behavior Research Methods*, 40(3), 879-891.
   - Bootstrap methods for mediation

**Total New Citations**: 7 entries

#### C. `part-f-technical-appendices.qmd` Dataset Documentation

**Added**: `mediation_example.csv` (n = 100) in Psychology/Behavioral Sciences section

**Content**:
- **Purpose**: Demonstrate simple mediation (X → M → Y)
- **Variables**: intervention, self_efficacy, exam_score, age, gender, prior_gpa
- **Key Features**: Temporal ordering, strong indirect effect (79% mediated)
- **Methods**: Baron & Kenny, bootstrap CIs, sensitivity analysis
- **Sample Size**: n ≥ 80-100 for adequate power
- **Used In**: Part E, Project 5

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| **Total Lines Added** | ~1,200 lines |
| **Files Modified** | 4 files |
| **New Datasets** | 1 (mediation_example.csv, n=100) |
| **New Chapters/Sections** | 0 (enhancements to existing) |
| **New Packages** | 3 (glmnet, mediation, patchwork) |
| **New Citations** | 7 references |
| **Implementation Time** | ~3 hours |

---

## Files Modified

### 1. `chapters/part-c-analysis-methods.qmd`
- **Line 1818** (after Lab Practical 5.1): Inserted ~600 lines of ridge/lasso/elastic net content
- **Line 2870** (Analyses That Require Larger Samples): Replaced with ~200 lines including SEM sidebar
- **Total Change**: +800 lines

### 2. `chapters/part-e-worked-projects.qmd`
- **Line 1064** (after Project 4): Inserted ~350 lines for Project 5 (mediation analysis)
- **Conclusion section**: Updated to mention 5 projects, added mediation to method list
- **Total Change**: +350 lines

### 3. `index.qmd`
- **Lines 85-103**: Updated package list (added glmnet, mediation, patchwork)
- **Installation code**: Updated with new packages
- **Total Change**: +3 packages

### 4. `chapters/part-f-technical-appendices.qmd`
- **Line 770** (after education datasets): Inserted mediation_example.csv documentation (~50 lines)
- **Total Change**: +50 lines

### 5. `references.bib`
- **Line 80** (after Shan 2018): Inserted 7 new citations (Hastie, Friedman, Baron, Tingley, Hayes, MacKinnon, Preacher)
- **Total Change**: +7 references

### 6. `data/mediation_example.csv`
- **New file**: 101 lines (header + 100 observations)
- 7 variables: participant_id, intervention, self_efficacy, exam_score, age, gender, prior_gpa

---

## Key Methodological Additions

### 1. Penalized Regression (Ridge/Lasso/Elastic Net)
- **When to Use**: Multiple predictors (p), limited observations (n), multicollinearity
- **Sample Size**: Ridge (n ≥ 40), Lasso (n ≥ 50), Elastic Net (n ≥ 50)
- **Advantages**: Handles p ≈ n, reduces overfitting, automatic variable selection (lasso)
- **Package**: glmnet (fast, well-documented, cross-validation built-in)

### 2. Simple Mediation Analysis
- **When to Use**: Understanding **how/why** X affects Y (mechanism testing)
- **Sample Size**: n ≥ 80-100 (bootstrap requires adequate n for stable CIs)
- **Approaches**: Baron & Kenny (classic) + Bootstrap (modern, recommended)
- **Package**: mediation (bootstrap CIs, sensitivity analysis)
- **Cautions**: Single mediator only (not multiple mediators), temporal ordering required, unmeasured confounding threat

### 3. SEM Sample Size Sidebar
- **Purpose**: Prevent misuse of CFA/SEM/PLS-SEM with small samples
- **Key Message**: "For n < 100, use composite scores + regression, NOT SEM"
- **Alternatives Provided**: 8 small-sample alternatives mapped to SEM goals
- **Outcome**: Students understand WHY SEM needs large n, WHAT to do instead

---

## Pedagogical Benefits

### 1. Fills Critical Gap
- **Before**: Book lacked methods for "many predictors, small n" scenarios
- **After**: Ridge/lasso/elastic net provide principled solution for n = 50-100

### 2. Addresses "How/Why" Questions
- **Before**: Book focused on "does X affect Y?" (bivariate comparisons, regression)
- **After**: Mediation analysis allows "how does X affect Y?" (mechanism testing)

### 3. Prevents Common Mistakes
- **Problem**: Students try SEM/PLS-SEM with n = 50, get unreliable results
- **Solution**: SEM sidebar clearly explains why NOT to do this + provides alternatives

### 4. Maintains Book Philosophy
- **Core Principle**: "Use methods that actually work at stated sample sizes"
- **All Additions**: Ridge/lasso (n ≥ 40-50), Mediation (n ≥ 80-100), SEM alternatives (composite scores at n ≥ 20)
- **Honesty**: Transparent about limitations, appropriate sample sizes, when to scale up

### 5. Expands Applicability
- **New Use Cases**: Multiple regression with multicollinearity, variable selection, mechanism testing, theory building
- **Domains**: All 4 (education, health, business, social sciences) benefit from these methods

---

## Student Learning Outcomes

After completing these sections, students will be able to:

### Ridge/Lasso/Elastic Net (Ch 5)
1. **Identify** when standard regression fails (multicollinearity, p > n)
2. **Choose** between ridge, lasso, and elastic net based on research goals
3. **Implement** penalized regression using glmnet with cross-validation
4. **Interpret** shrunken coefficients and explain regularization
5. **Report** results with appropriate caveats about variable selection stability

### Simple Mediation (Part E, Project 5)
1. **Formulate** mediation hypotheses (X → M → Y)
2. **Conduct** Baron & Kenny analysis (paths a, b, c, c')
3. **Estimate** indirect effects using bootstrap confidence intervals
4. **Assess** sensitivity to unmeasured confounding
5. **Report** mediation results with proportion mediated, total/direct/indirect effects
6. **Avoid** causal language unless warranted by study design

### SEM Sample Size Awareness (Ch 6)
1. **Recognize** when SEM/CFA/PLS-SEM are inappropriate (n < 100-200)
2. **Explain** why small samples produce unstable SEM results
3. **Apply** composite score alternatives for n < 100
4. **Plan** future large-sample studies (n ≥ 200) for SEM validation

---

## Integration with Existing Content

### Part C (Analysis Methods)
- **Chapter 5 Enhancement**: Ridge/lasso/elastic net follows naturally after Firth and Bayesian regression (all handle small n challenges)
- **Chapter 6 Enhancement**: SEM sidebar complements reliability analysis (both about latent constructs/measurement)

### Part E (Worked Projects)
- **Project 5 Integration**: Mediation project follows same structure as Projects 1-4 (context, data, analysis, discussion, takeaways)
- **Progression**: Projects 1-4 focus on "does X affect Y?"; Project 5 adds "how does X affect Y?"

### Part F (Technical Appendices)
- **Dataset Documentation**: mediation_example.csv documented alongside education, health, business datasets
- **Consistent Format**: Same structure (purpose, variables, key features, methods, sample size)

---

## Comparison: What Was NOT Added (PLS-SEM)

| Criterion | PLS-SEM | Ridge/Lasso/Mediation |
|-----------|---------|----------------------|
| **Sample Size Reality** | n ≥ 100-150 (despite "small" claims) | Ridge (n ≥ 40), Lasso (n ≥ 50), Mediation (n ≥ 80) |
| **Philosophical Fit** | ❌ Contradicts book's honesty about n | ✅ Transparent about requirements |
| **Misuse Risk** | ❌ High (students would use at n=30) | ✅ Low (clear sample size guidance) |
| **Theoretical Basis** | ⚠️ Weaker than covariance-based SEM | ✅ Strong (penalized regression = well-established) |
| **Output Stability** | ❌ Unstable at n<100 | ✅ Stable at stated sample sizes |
| **Learning Curve** | ⚠️ Moderate-High (latent variables) | ✅ Moderate (builds on regression) |
| **Publication Acceptance** | ⚠️ Controversial in some fields | ✅ Widely accepted |

**Conclusion**: Ridge/lasso/mediation provide **better small-sample solutions** than PLS-SEM would have, while maintaining the book's integrity.

---

## Testing and Validation

### Code Reproducibility
- ✅ All new code chunks tested in fresh R session
- ✅ Packages load correctly (glmnet, mediation, patchwork)
- ✅ mediation_example.csv generates correctly (n=100, 7 variables)
- ✅ Cross-validation converges (cv.glmnet produces stable lambda)
- ✅ Bootstrap mediation completes (5000 iterations, ~5 seconds)

### Pedagogical Clarity
- ✅ Ridge/lasso section follows logical progression (theory → code → example → guidelines)
- ✅ Mediation project includes all standard elements (context, data, analysis, discussion, takeaways)
- ✅ SEM sidebar uses callout boxes, tables, bullet points for scannability
- ✅ Language matches book style (British English, academic but accessible)

### Integration Checks
- ✅ New content flows naturally from existing chapters
- ✅ Cross-references work (e.g., "see Part E, Project 5" from Ch 5)
- ✅ Package list updated (index.qmd, references.bib)
- ✅ Dataset documented (part-f-technical-appendices.qmd)

---

## Future Enhancements (Optional)

### Phase 2 Possibilities (If User Requests)
1. **Multiple Mediation**: Extend Project 5 to test 2-3 mediators simultaneously
2. **Moderated Mediation**: Add interaction terms (e.g., does mediation differ by gender?)
3. **Cross-Validation Chapter**: Expand LOOCV (Ch 5) into full CV section (k-fold, stratified)
4. **Shipping/Logistics Domain**: Add 3 datasets, 1 worked project (estimated 25-35 hours)
5. **Interactive Shiny Apps**: Create web apps for ridge/lasso tuning, mediation sensitivity analysis

### Current State: **COMPLETE**
All 4 tasks finished. Book now provides comprehensive small-sample methods for:
- Single predictors (regression, t-tests, exact tests) ✅
- Multiple predictors (ridge/lasso/elastic net) ✅
- Mechanism testing (simple mediation) ✅
- Measurement (reliability, composite scores) ✅
- Clarity on what NOT to do (SEM sidebar) ✅

---

## Key Takeaways

### What Changed
1. **Expanded multivariate capabilities**: Ridge/lasso/elastic net for n = 40-100 with multiple predictors
2. **Added mechanism testing**: Simple mediation for n ≥ 80-100 (how/why questions)
3. **Prevented SEM misuse**: Clear guidance on why SEM needs n ≥ 200, what to do instead
4. **Updated infrastructure**: 3 new packages, 7 new citations, 1 new dataset, 1,200+ lines

### What Didn't Change
1. **Book philosophy**: Still focused on honest, appropriate methods for n = 10-100
2. **Target audience**: Still graduate students, applied researchers in education/health/business/social sciences
3. **Style**: Still British English, reproducible code, transparent limitations
4. **Core methods**: Fisher's exact, Mann-Whitney, Wilcoxon, Firth, bootstrap still central

### Impact
- **Strengthened**: Book now handles broader range of small-sample scenarios
- **Clarified**: SEM sidebar prevents common mistakes, guides future large-sample planning
- **Maintained**: Integrity preserved—all additions work at stated sample sizes, no false promises

---

**Recommendation**: Book is now **complete** for initial publication. Optional Phase 2 enhancements (multiple mediation, shipping/logistics domain) can be added in future editions if demand exists.

**Status**: ✅ All 4 tasks complete. Ready for final review and Quarto rendering.
