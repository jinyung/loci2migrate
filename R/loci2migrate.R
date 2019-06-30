loci2migrate <- function(locipath, poppath, filename) {
  
  # read the loci file and the pop file
  loci <- scan(locipath, sep = '\n', what = 'char', quiet = TRUE)
  popdat <- read.table(poppath, sep = '\t')
  
  # initialize
  j <- 0
  j_end <- ind <- seq <- locus <- pop <- NULL
  
  # loop thru each line
  for (i in seq_along(loci)) {
    if (!startsWith(loci[i], '//')) {  # read the sequence
      j <- j + 1	# j keep track of ind #
      sp_ln <- unlist(strsplit(loci[i], ' '))
      ind[j] <- sp_ln[1]
      seq[j] <- tail(sp_ln, 1)
    } else {  # read the locus label
      if (is.null(j_end))
        j_end = 1
      sp_ln <- unlist(strsplit(loci[i], ' '))
      # get the label and clean other symbols 
      locus_tmp <-  gsub('*', '', tail(sp_ln, 1), fixed = TRUE)
      locus_tmp <-  gsub('-', '', locus_tmp, fixed = TRUE)
      locus[j_end:j] <- gsub('|', '', locus_tmp, fixed = TRUE)
      j_end <- j + 1  # j_end keep track of last ind of last locus
    }
  }
  
  # check for spelling error in ind label
  wrong_spell_in_pop <- !(popdat[, 1] %in% ind)
  if (any(wrong_spell_in_pop)) {
    stop('Not all ind label are found in the .loci file, please check whether\n',
         'you spelt the below entry wrong in the pop file* or you wish to ', 
         'remove \nthe entry from the pop file:\n', 
         paste0(popdat[which(wrong_spell), 1], ' (line', which(wrong_spell), 
                ')\n'), '*Note: label is case sensitive')
  }
  wrong_spell_in_loci <- !(ind %in% popdat[, 1])  # quick fix
  if (any(wrong_spell_in_loci)) {
    stop('loci file contains ind label not found in pop file, please check\n',
         'whether there is an spelling error in loci file, specifically ', 
         'the following ind labels:\n', 
         paste(ind[which(!ind %in% popdat[, 1])], collapse = ', '),
         '\n*Note: label is case sensitive')
  }
  
  # match population
  for (i in seq_along(ind)) {
    pop[i] <- as.character(popdat[, 2][popdat[, 1] == ind[i]])
  }
  
  # sequence length
  seqlen <- sapply(seq, nchar, USE.NAMES = FALSE)
  
  # open connection for writing
  filecon <- file(filename, "wt")
  
  # remove missing locus (locus that not present in all populations)
  locus <- as.factor(locus)
  pop <- as.factor(pop)
  locus_pop_i <- matrix(NA, nrow = length(levels(locus)), 
                        ncol = length(levels(pop)))
  for (i in seq_along(levels(pop))) {
    locus_pop_i[, i] <- table(locus[pop == levels(pop)[i]]) != 0
  }
  locus_keep_idx_levels <- apply(locus_pop_i, 1, all)  # keep if all are TRUE
  locus_keep_idx_ind <- locus %in% levels(locus)[locus_keep_idx_levels]
  
  # write some metadata
  cat(file = filecon, 
      length(levels(pop)), 
      length(levels(droplevels(locus[locus_keep_idx_ind]))), 
      basename(locipath), '\n')
  if (any(!locus_keep_idx_levels)) {
    cat(file = filecon,
        '# These loci were not found in all populations and hence removed:\n#', 
        levels(locus)[!locus_keep_idx_levels], '\n')
  }
  
  # combine all extracted info into a big dataframe
  dat <- data.frame(ind = ind, locus = locus, pop = as.factor(pop), seq = seq, 
                    seqlen = seqlen)[locus_keep_idx_ind, ]
  dat$locus <- droplevels(dat$locus)
  
  # and clear memory 
  rm(ind, locus, pop, seq, seqlen)
  
  # first sort by pop 
  for (i in seq_along(levels(dat$pop))) {  
    dat_sub <- subset(dat, dat$pop == levels(dat$pop)[i])
    dat_sub$locus <- droplevels(dat_sub$locus)
    # write summary
    seqlen_total <- as.integer(xtabs(dat_sub$seqlen~dat_sub$locus))
    n_ind_locus <- table(dat_sub$locus)
    if (i == 1)
      cat(file = filecon, seqlen_total/n_ind_locus, '\n')
    cat(file = filecon, n_ind_locus, levels(dat$pop)[i], '\n')
    
    # then sort by locus
    for (j in seq_along(levels(dat_sub$locus))) {
      locus_j <- levels(dat_sub$locus)[j]
      # write locus label
      cat(file = filecon, paste('#', locus_j, '\n'))
      dat_sub2 <- subset(dat_sub, dat_sub$locus == locus_j)
      
      # then write ind and seq
      for (k in seq_along(dat_sub2$ind)) {
        cat(file = filecon, as.character(dat_sub2$ind[k]), '\t', 
            as.character(dat_sub2$seq[k]), '\n')
      }
    }
  }
  
  # close file end writing
  close(filecon)
} 
