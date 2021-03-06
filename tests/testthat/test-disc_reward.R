library(testthat)
library(phasty)

test_that(
  'test of all the error and warnings in discrete phase-type function', {

    # [W] No init_probs provided
    expect_warning(reward_phase_type(
      phase_type(subint_mat = matrix(c(0.4, 0, 0,
                                       0.24, 0.4, 0,
                                       0.12, 0.2, 0.5), ncol = 3)),
                             reward = c(1, 0, 4)))

    # [E] negative reward
    expect_error(reward_phase_type(
      phase_type(subint_mat = matrix(c(0.4, 0, 0,
                                       0.24, 0.4, 0,
                                       0.12, 0.2, 0.5), ncol = 3),
                 init_probs = c(1, 0, 0)),
      reward = c(-1, 0, 4)))

    # [E] Too large reward vector
    expect_error(reward_phase_type(
      phase_type(subint_mat = matrix(c(0.4, 0, 0,
                                       0.24, 0.4, 0,
                                       0.12, 0.2, 0.5), ncol = 3),
                 init_probs = c(1, 0, 0)),
      reward = c(1, 0, 0, 4)))

    # [E] Too small reward vector
    expect_error(reward_phase_type(
      phase_type(subint_mat = matrix(c(0.4, 0, 0,
                                       0.24, 0.4, 0,
                                       0.12, 0.2, 0.5), ncol = 3),
                 init_probs = c(1, 0, 0)),
      reward = c(1, 0)))

    # [E] Decimal reward
    expect_error(reward_phase_type(
      phase_type(subint_mat = matrix(c(0.4, 0, 0,
                                       0.24, 0.4, 0,
                                       0.12, 0.2, 0.5), ncol = 3),
                 init_probs = c(1, 0, 0)),
      reward = c(1.5, 0, 4)))

    # [E] NULL reward provided
    expect_error(reward_phase_type(
      phase_type(subint_mat = matrix(c(0.4, 0, 0,
                                       0.24, 0.4, 0,
                                       0.12, 0.2, 0.5), ncol = 3),
                 init_probs = c(1, 0, 0)),
      reward = NULL))

    # [E] No reward provided
    expect_error(reward_phase_type(
      phase_type(subint_mat = matrix(c(0.4, 0, 0,
                                       0.24, 0.4, 0,
                                       0.12, 0.2, 0.5), ncol = 3),
                 init_probs = c(1, 0, 0))))

    # [E] No phase-type provided
    expect_error(reward_phase_type(reward = c(1, 0, 0)))

  })

