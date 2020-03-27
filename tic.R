do_package_checks(error_on = "warning")

# install ranger for README
get_stage("install") %>%
  add_step(step_install_cran("ranger")) %>%
  add_step(step_install_github("mlr-org/mlr3pkgdowntemplate"))

do_pkgdown()

if (Sys.info()["sysname"] == "Linux") {
  do_readme_rmd()
}

if (ci_has_env("LINTR")) {
  get_stage("after_success") %>%
    add_code_step(lintr::lint_package())
}

get_stage("after_success") %>%
  add_code_step(system("curl -s https://raw.githubusercontent.com/mlr-org/mlr3orga/master/trigger-mlr3book.sh | bash"))
