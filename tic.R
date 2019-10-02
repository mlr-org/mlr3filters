do_package_checks(error_on = "warning")

# install ranger for README
get_stage("install") %>%
  add_step(step_install_cran("ranger"))

if (ci_on_travis()) {
  do_pkgdown(orphan = TRUE, install = TRUE)
}

get_stage("after_success") %>%
  add_code_step(system("curl -s https://raw.githubusercontent.com/mlr-org/mlr3orga/master/trigger-mlr3book.sh | bash"))
