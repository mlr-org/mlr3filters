do_package_checks(error_on = "warning")

# install ranger for README
get_stage("install") %>%
  add_step(step_install_cran("ranger")) %>%
  add_step(step_install_github("mlr-org/mlr3pkgdowntemplate"))

if (ci_on_ghactions() && ci_has_env("BUILD_PKGDOWN")) {
  # creates pkgdown site and pushes to gh-pages branch
  # only for the runner with the "BUILD_PKGDOWN" env var set
  get_stage("install") %>%
    add_step(step_install_github("mlr-org/mlr3pkgdowntemplate"))
  do_pkgdown()
}

if (Sys.info()["sysname"] == "Linux" && ci_get_branch() == "master") {
  do_readme_rmd()
}

get_stage("after_success") %>%
  add_code_step(system("curl -s https://raw.githubusercontent.com/mlr-org/mlr3orga/master/trigger-mlr3book.sh | bash")) # nolint
