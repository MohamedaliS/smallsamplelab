# Package availability checks and fallback functions
# This script provides graceful handling for optional packages

# Check if a package is available and load it
safe_library <- function(package_name) {
  if (requireNamespace(package_name, quietly = TRUE)) {
    library(package_name, character.only = TRUE)
    return(TRUE)
  } else {
    message(sprintf("Package '%s' not available. Some functions may be limited.", package_name))
    return(FALSE)
  }
}

# Create stub packages for missing ones to allow library() to work
create_stub_package <- function(pkg_name, functions_list) {
  if (!requireNamespace(pkg_name, quietly = TRUE)) {
    # Create a minimal package environment
    pkg_env <- new.env(parent = emptyenv())
    
    # Add functions to the environment
    for (func_name in names(functions_list)) {
      assign(func_name, functions_list[[func_name]], envir = pkg_env)
    }
    
    # Attach to search path so library() will work
    pkg_full_name <- paste0("package:", pkg_name)
    if (!pkg_full_name %in% search()) {
      attach(pkg_env, name = pkg_full_name)
    }
    
    message(sprintf("Created stub environment for '%s' package with fallback functions", pkg_name))
  }
}

# Stub for exact2x2
create_stub_package("exact2x2", list(
  exact2x2 = function(x, alternative = "two.sided", midp = FALSE, ...) {
    message("Using base R fisher.test() as exact2x2 package is not available")
    if (midp) {
      message("Note: midp=TRUE is not supported in fisher.test(); using standard p-value")
    }
    # Remove midp from arguments passed to fisher.test
    result <- stats::fisher.test(x, alternative = alternative, ...)
    return(result)
  }
))

# Stub for logistf
create_stub_package("logistf", list(
  logistf = function(formula, data, ...) {
    message("logistf package not available. Using standard glm() instead.")
    message("Note: This does not apply Firth's bias correction for small samples.")
    result <- glm(formula, data = data, family = binomial, ...)
    result$method <- "glm (Firth correction not applied - logistf unavailable)"
    return(result)
  }
))

# Stub for gt
create_stub_package("gt", list(
  gt = function(data, ...) {
    message("gt package not available. Returning knitr::kable() output instead.")
    return(knitr::kable(data, ...))
  },
  tab_header = function(data, title = NULL, subtitle = NULL, ...) {
    attr(data, "title") <- title
    attr(data, "subtitle") <- subtitle
    return(data)
  },
  fmt_number = function(data, ...) {
    return(data)
  },
  cols_label = function(data, ...) {
    return(data)
  }
))

# Stub for naniar
create_stub_package("naniar", list(
  mcar_test = function(data) {
    message("naniar::mcar_test not available. Showing missing data summary instead:")
    cat("\nMissing data summary:\n")
    missing_summary <- data.frame(
      variable = names(data),
      n_miss = colSums(is.na(data)),
      pct_miss = round(100 * colMeans(is.na(data)), 2)
    )
    missing_summary <- missing_summary[order(-missing_summary$n_miss), ]
    print(missing_summary)
    invisible(NULL)
  },
  
  miss_var_summary = function(data) {
    missing_df <- data.frame(
      variable = names(data),
      n_miss = colSums(is.na(data)),
      pct_miss = round(100 * colMeans(is.na(data)), 2)
    )
    missing_df <- missing_df[order(-missing_df$n_miss), ]
    return(missing_df)
  },
  
  gg_miss_var = function(data, ...) {
    message("naniar::gg_miss_var not available. Showing text summary instead.")
    print(miss_var_summary(data))
    invisible(NULL)
  },
  
  vis_miss = function(data, ...) {
    message("naniar::vis_miss not available. Showing summary instead:")
    print(miss_var_summary(data))
    invisible(NULL)
  }
))

# Stub for DescTools
create_stub_package("DescTools", list(
  Desc = function(...) {
    message("DescTools::Desc not available. Using base R summary() instead.")
    return(summary(...))
  },
  CramerV = function(x, y = NULL, ...) {
    message("DescTools::CramerV not available. Returning NA.")
    return(NA)
  }
))

cat("Package fallbacks loaded. Missing packages will use base R alternatives.\n")

