
# Bundle up the data for Stan models --------------------------------------


assert_that(identical(levels(area_df$NA_L3NAME),
                      levels(factor(st_covs$NA_L3NAME))))

stan_d <- list(
  N = N,
  T = T,
  p = length(colnamesX),

  n_count = nrow(train_counts),
  counts = train_counts$n_fire,

  log_area = log(area_df$area * 1e-10),
  er_idx_train = as.numeric(factor(train_counts$NA_L3NAME,
                                   levels = levels(area_df$NA_L3NAME))),
  er_idx_full = as.numeric(factor(st_covs$NA_L3NAME)),

  n_fire = nrow(train_burns),
  sizes = (train_burns$R_ACRES - 1e3) / weibull_scale_adj,
  burn_idx = burn_idx,

  n_w = length(sparse_X$w),
  w = sparse_X$w,
  v = sparse_X$v,
  u = sparse_X$u,

  # sparse design matrix for training counts
  n_w_tc = length(sparse_X_tc$w),
  w_tc = sparse_X_tc$w,
  v_tc = sparse_X_tc$v,
  n_u_tc = length(sparse_X_tc$u),
  u_tc = sparse_X_tc$u,

  # sparse design matrix for training burns
  n_w_tb = length(sparse_X_tb$w),
  w_tb = sparse_X_tb$w,
  v_tb = sparse_X_tb$v,
  n_u_tb = length(sparse_X_tb$u),
  u_tb = sparse_X_tb$u,

  burn_eps_idx = burn_eps_idx,

  M = 4,
  slab_df = 5,
  slab_scale = 1,

  eps_idx_train = eps_idx_train,
  eps_idx_future = eps_idx_future)


gpd_d <- stan_d
gpd_d$size_threshold <- 0 # because we have converted to exceedances


zinb_gpd_d <- gpd_d
zinb_gpd_d$M <- 5
