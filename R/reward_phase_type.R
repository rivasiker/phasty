#' Transformation of Phase-Type Distributions via Rewards
#'
#' Transform a variable following a phase-type distribution according to a
#' non-negative reward vector.
#'
#' @usage reward_phase_type(phase_type, reward, round_zero = NULL)
#'
#' @param phase_type an object of class \code{cont_phase_type} or
#'  \code{disc_phase_type}.
#'
#' @param reward a vector of the same length as the number of
#' states. The vector should contains non negative values and only integer for
#' discrete phase-type class.
#' For \code{disc_phase_type} object, it could also be a matrix with as many
#' rows as states and as many columns as the maximum values of reward plus one.
#' Also in this case, each cell of the matrix should be probabilities and the
#' sum of the rows should sum up to one.
#'
#' @param round_zero  is a positive integer or \code{NULL}, if it is a positive
#' integer, all the values in the subintensity matrix and initial probabilities
#' will be truncate at the corresponding decimal. It can be useful if
#' the computational approximation of some values leads the row
#' sums of the subintensity  matrix to be higher than 1 or smaller than 0 for
#' discrete cases, or higher than 0 for continuous cases.
#'
#' @return
#' An object of class \code{disc_phase_type} or \code{cont_phase_type}.
#' Be aware that if the input is a multivariate phase_type the output will be
#' univariate.
#'
#' @details
#' For the reward transformation for continuous phase-type distribution, the
#' transformation will be performed as presented in the book of Bladt and
#' Nielsen (2017).
#'
#' For the discrete phase_type distribution is based on the PhD of Navarro and
#' the *in prep.* manuscript of Andersen *et al.*
#'
#' Every state of the subintensity matrix should have a reward, in the case of
#' continuous phase-type, this reward should be a vector with non negative
#' values of a size equal to the number of states.
#'
#' For the discrete phase-type, the reward could be also a vector but containing
#' only non-negatives integer.
#' Also it can be me a matrix, in that case the matrix should have as many rows
#' as the number of states, and the column 1 to j+1 corresponds to reward of
#' 0 to j. Each cell corresponding that entering in the state i, the probability
#' that we attribute to this state a reward j corresponds to the value of the
#' matrix in row i and column j+1.
#'
#' @author C. Guetemme, A. Hobolth
#'
#' @references
#' Bladt, M., & Nielsen, B. F. (2017). *Matrix-exponential distributions in applied probability* (Vol. 81). New York: Springer.
#' Campillo Navarro, A. (2019). *Order statistics and multivariate discrete phase-type distributions*. DTU Compute. DTU Compute PHD-2018, Vol.. 492
#' Andersen, L. *et al.* (*in prep.*)
#'
#' @seealso \code{\link{phase_type}}
#'
#' @examples
#' ##===========================##
#' ## For continuous phase-type ##
#' ##===========================##
#'
#' subint_mat <- matrix(c(-3, 1, 1,
#'                       2, -3, 0,
#'                       1, 1, -3), ncol = 3)
#' init_probs <- c(0.9, 0.1, 0)
#' ph <- phase_type(subint_mat, init_probs)
#' reward <- c(0.5, 0, 4)
#'
#' reward_phase_type(ph, reward)
#'
#' ##=========================##
#' ## For discrete phase-type ##
#' ##=========================##
#'
#' subint_mat <- matrix(c(0.4, 0, 0,
#'                       0.24, 0.4, 0,
#'                       0.12, 0.2, 0.5), ncol = 3)
#' init_probs <- c(0.9, 0.1, 0)
#' ph <- phase_type(subint_mat, init_probs)
#'
#' reward <- c(1, 0, 4)
#'
#' reward_phase_type(ph, reward)
#'
#' #---
#'
#' subint_mat <- matrix(c(0.4, 0, 0.5,
#'                       0.2, 0.24, 0,
#'                       0.4, 0.6, 0.2), ncol = 3)
#' init_probs <- c(0.9, 0.1, 0)
#'
#' ph <- phase_type(subint_mat, init_probs)
#'
#' reward <- matrix(c(0, 0.2, 1,
#'                    0.5, 0, 0,
#'                    0.5, 0.6, 0,
#'                    0, 0, 0,
#'                    0, 0.2, 0), ncol = 5)
#'
#' reward_phase_type(ph, reward)
#'
#'
#' @export

reward_phase_type <- function(phase_type, reward, round_zero = NULL){

  ##=====================##
  ## Discrete phase-type ##
  ##=====================##

  # If discrete will apply the reward transformation
  # found in the PhD of Navarro (2019)

  if (class(phase_type) == 'disc_phase_type' ||
      class(phase_type) == 'mult_disc_phase_type'){

    init_probs <- phase_type$init_probs
    subint_mat <- phase_type$subint_mat

    n <- length(init_probs)

    if (is.matrix(reward)) {
      if (nrow(reward) == 1){
        reward  <- as.vector(reward)
      } else if (nrow(reward) != n){
        stop('Wrong dimensions, Rewards should be a vector or a matrix of',
             'n rows')
      } else {
        if (! all(rowSums(reward) == 1)){
          stop('The row sums for the reward matrix should be equal to 1')
        }

        if (! all(reward >= 0) || ! all(reward <= 1)){
          stop('The reward matrix should only contains probabilities')
        }

        for (i in which(reward[, 1] > 0 & reward[, 1] < 1)){

          new_subint_mat <- subint_mat
          new_subint_mat[, i] <- new_subint_mat[, i] * sum(reward[i, -1])
          new_subint_mat <- cbind(new_subint_mat, subint_mat[,i] * reward[i, 1])
          subint_mat <- rbind(new_subint_mat, new_subint_mat[i,])

          reward <- rbind(reward, c(reward[i, 1], rep(0, ncol(reward) - 1)))
          reward[i, 1] <- 0

          init_probs <- c(init_probs, init_probs[i] * reward[nrow(reward), 1])
          init_probs[i] <- init_probs[i] * (1 - reward[nrow(reward), 1])
        }

        reward <- reward / rowSums(reward)
        n <- length(init_probs)
        reward_mat <- col(reward) - 1
        reward_max <- apply(reward_mat * as.numeric(reward > 0), 1, max)
      }

    }
    if (is.vector(reward)) {
      if (length(reward) != n){
        stop('The reward vector has wrong dimensions (should be of the ',
             'same size that the inital probabilities).')
      }

      if (sum(reward < 0) != 0){
        stop('The reward vector should only contain non-negative values.')
      }

      if (sum(reward) != sum(round(reward))){
        stop('The reward vector should only contain integers.')
      }

      reward_max <- reward
      reward <- matrix(0, ncol = max(reward) + 1,
                       nrow = n)
      for (i in 1:n){
        reward[i, reward_max[i] + 1] <-  1
      }
    }

    # Initialisation of the set of all T_tilde matrices
    # i.e. all the rewarded submatrices to go from i to j
    T_tilde_ij <- rep(list(as.list(1:n)), n)
    size <- reward_max + as.numeric(reward_max == 0)
    # Building of each T_tilde_ij matrix
    for (i in 1:n) {
      for (j in 1:n) {
        matij <- matrix(0, nrow = size[i], ncol = size[j])
        if (i == j) {
          matij[-size[i], -1] <- diag(1, size[i] - 1)
        }
        if (sum(reward[j, 2:(max(reward_max)+1)]) > 0){
          matij[size[i], 1:size[j]] <- subint_mat[i, j] *
            reward[j, (size[j] + 1):2]
        } else {
          matij[size[i], 1] <- subint_mat[i, j]
        }

        T_tilde_ij[[i]][[j]] <- matij
      }
    }

    abs_pos_p <- c(0, cumsum(size * (as.numeric(reward_max > 0)))) + 1
    abs_pos_z <- c(0, cumsum(size * (as.numeric(reward_max == 0)))) + 1

    # vector of state w/ positive-zero reward
    p <- which(reward_max > 0)
    z <- which(reward_max == 0)

    if (length(z) > 0){
      T_tilde_states <- list(list(p, p), list(p, z), list(z, p), list(z, z))

      # list containing T++, T+0, T0+ and T00
      T_tilde <- list('pp' = 0, 'zp' = 0, 'pz' = 0, 'zz' = 0)
    } else {
      T_tilde_states <- list(list(p, p))
      T_tilde <- list('pp' = 0)
    }

    count <- 1 # To count the number of pass in the loop
    for (i in T_tilde_states){

      # Will give all the combinations of elements from
      # T++, T+0, T0+ and T00 (respectively each loop iteration)
      combn <- as.matrix(expand.grid(i[[1]],i[[2]]))

      # initialisation of the submatrix
      T_tilde[[count]] <- matrix(0, ncol = sum(size[i[[1]]]),
                                 nrow = sum(size[i[[2]]]))

      # Get the position of each elements
      suppressWarnings(ifelse(all(i[[1]] == p),
                              pos_row <- abs_pos_p, pos_row <- abs_pos_z))
      suppressWarnings(ifelse(all(i[[2]] == p),
                              pos_col <- abs_pos_p, pos_col <- abs_pos_z))

      # for each combinations, add the corresponding matrix given by
      # T_tilde_ij
      for (j in 1:nrow(combn)){
        selec_combn <- as.vector(combn[j,])

        numcol <- (pos_row[selec_combn[1]]):(pos_row[selec_combn[1] + 1] - 1)
        numrow <- (pos_col[selec_combn[2]]):(pos_col[selec_combn[2] + 1] - 1)

        T_tilde[[count]][numrow, numcol] <-
          T_tilde_ij[[selec_combn[2]]][[selec_combn[1]]]
      }
      count <- count + 1
    }

    # Calculation of the new transformed matrix
    # according to ... eqn ...
    init_probs_p <- NULL
    for (i in 1:length(p)) {
      init_probs_p <- c(init_probs_p, init_probs[p[i]], rep(0, size[p[i]] - 1))
    }

    if (length(z) > 0) {
      subint_mat <- T_tilde$pp + (T_tilde$pz %*% solve(diag(1, ncol(T_tilde$zz))
                                                       - T_tilde$zz) %*% T_tilde$zp)

      init_probs_z <- init_probs[z]
      init_probs <- init_probs_p +
        (init_probs_z %*% solve(diag(1,ncol(T_tilde$zz)) - T_tilde$zz)  %*%
           T_tilde$zp)

    } else {
      subint_mat <- T_tilde$pp
      init_probs <- init_probs_p
    }
    ph <- phase_type(subint_mat, init_probs, round_zero = round_zero)
    return(ph)

    ##=======================##
    ## Continuous phase-type ##
    ##=======================##

    # If continuous, will apply the transformation of
    # Bladt and Nielsen 2017.
  } else if (class(phase_type) == 'cont_phase_type' ||
             class(phase_type) == 'mult_cont_phase_type') {

    init_probs <- phase_type$init_probs
    subint_mat <- phase_type$subint_mat

    n <- length(init_probs)

    if (is.matrix(reward)){
      if (nrow(reward) == 1){
        reward <- vector(reward)
      } else {
        stop('The rewards should be a vector.')
      }
    } else if (!is.vector(reward)) {
      stop('The rewards should be a vector.')
    }

    if (length(reward) != n) {
      stop('The reward vector has wrong dimensions (should be of the ',
           'same size that the inital probabilities).')
    }

    if (sum(reward < 0) != 0) {
      stop('The reward vector should only contain non-negative values.')
    }


    # Section to get the embended matrix of T (the subintensity matrix)
    Q <- subint_mat * 0
    for (i in 1:n) {
      for (j in 1:n) {
        if (i == j) {
          Q[i, i] <- 0
        } else {
          Q[i,j] <- -(subint_mat[i,j] / subint_mat[i,i])
        }
      }
    }

    p <- which(reward > 0)
    z <- which(reward == 0)

    if ((length(z) > 0) && (length(p) > 0)){

      # Block partionning of Q, with the submatrix Qpz corresponds to the
      # matrix with the transition from the states with positive rewards
      # to the states with zero reward (p = positive and z = zero)
      Qpp <- matrix(Q[p,p], nrow = length(p))
      Qpz <- matrix(Q[p,z], nrow = length(p))
      Qzp <- matrix(Q[z,p], nrow = length(z))
      Qzz <- matrix(Q[z,z], nrow = length(z))

      P <- Qpp + (Qpz %*% solve(diag(1, ncol(Qzz)) - Qzz) %*% Qzp)

      init_probs <-  init_probs[p] +
        init_probs[z] %*% (solve(diag(1, ncol(Qzz)) - Qzz) %*% Qzp)

    } else if ((length(z) == 0) && (length(p) > 0)) {
      # if there is no zero reward, no need to remove them
      P <- Q

    } else {
      stop('None of the reward are positive.')
    }

    # vec_e is a vector of 1 of the same size that P
    vec_e <- rep(1,nrow(P))
    # small_p is the exit rate of P
    small_p <- as.vector(vec_e - P %*% vec_e)
    # ti is the exit rate of the new subintensity matrix (rewarded)
    ti <- -(small_p * diag(subint_mat)[p] / reward[p])

    # Initialisation of the new subintensity matrix (rewarded)
    mat_T <- P * 0
    for (i in 1:nrow(P)){
      for (j in 1:ncol(P)){
        if (i != j){
          mat_T[i, j] <- -(subint_mat[p[i],p[i]]/reward[p[i]])*P[i,j]
        }
      }
    }
    # Calculate the rate of leaving each state
    subint_mat <- mat_T - diag((apply(mat_T, 1, sum) + ti))
    # Get a cont_phase_type object

    ph <- phase_type(subint_mat, init_probs, round_zero = round_zero)
    return(ph)
  } else {
    stop('The object provided should be of class disc_phase_type or ',
         'cont_phase_type.')
  }
}
