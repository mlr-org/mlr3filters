do_package_checks(error_on = "warning")

get_stage("install") %>%
  # install ranger for README
  add_step(step_install_cran("ranger")) %>%
  add_step(step_install_github("mlr-org/mlr3pkgdowntemplate"))

if (ci_on_ghactions()) {
  # creates pkgdown site and pushes to gh-pages branch
  # only for the runner with the "BUILD_PKGDOWN" env var set
  get_stage("install") %>%
    add_step(step_install_github("mlr-org/mlr3pkgdowntemplate"))
  do_pkgdown()
}

get_stage("after_success") %>%
  add_code_step(system("curl -s https://raw.githubusercontent.com/mlr-org/mlr3orga/master/trigger-mlr3book.sh | bash")) # nolint
