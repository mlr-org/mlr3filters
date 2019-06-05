do_package_checks(error_on = "error")

# for md table in README
get_stage("install") %>%
  add_step(step_install_cran("kableExtra"))

if (ci_has_env("BUILD_PKGDOWN")) {
  do_pkgdown(orphan = TRUE)
}
