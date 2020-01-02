context("test-easyuse")
test_that("effects input causes error", {
  expect_error(easyuse::get_van_vals(1))
})
