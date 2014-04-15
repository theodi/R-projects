cluscomp_mach <- function (x, diss = FALSE, algorithms = list("kmeans"), alparams = list(), 
						alweights = list(), clmin = 2, clmax = 10, prop = 0.8, reps = 50, 
						merge = 0) {
  if (class(x) == "ExpressionSet") {
    x <- expSetProcess(x)
  }
  if (data_check(x) != TRUE) {
    stop("the provided data fails the data integrity check")
  }
  if (class(algorithms) != "list") {
    stop("You must pass the algorithm names in a list")
  }
  for (i in 1:length(algorithms)) {
    if (existsFunction(algorithms[[i]]) != 1) {
      stop("One or more of the specified algorithms does not exist")
    }
    else {
    }
  }
  if (length(alweights) == 0) {
    alweights = as.list(rep("1", length(algorithms)))
  }
  else {
    if (length(alweights) != length(algorithms)) {
      stop("If you sepcify algorithm weightings their number must equal the number of algorithms being used")
    }
  }
  if (clmin < 2) {
    stop("cannot have less than two clusters")
  }
  if (prop <= 0 | prop > 1) {
    stop("resampling proportion must be greater than 0 and less than 1")
  }
  if (merge != 0 & merge != 1) {
    stop("merge can only be 0 or 1")
  }
  total = sum(as.numeric(alweights))
  norm = as.numeric(alweights)/total
  sample_number = dim(x)[1]
  cmlist <- list()
  
  for (clnum in clmin:clmax) {
    print(paste("cluster number k=", clnum), quote = FALSE)
    if (merge > 0) {
      mm <- matrix(0, nrow = dim(x)[1], ncol = dim(x)[1], 
                   dimnames = list(row.names(x), row.names(x)))
    }
    
    for (a in 1:length(algorithms)) {
      print(paste("running experiment", a, "algorithm:", 
                  algorithms[[a]], sep = " "), quote = FALSE)
      final_conn <- matrix(0, nrow = dim(x)[1], ncol = dim(x)[1], 
                           dimnames = list(row.names(x), row.names(x)))
      final_id <- final_conn
      algo_clmem <- paste(algorithms[[a]], "_clmem", sep = "")
      current_algo <- get(algo_clmem)
      if (length(alparams) != 0) {
        current_params <- alparams
        current_params$diss <- diss
#        if (!is.null(current_params$diss)) {
#          diss = TRUE
#        }
      }
      else {
        if (diss == TRUE) {
          current_params = list(diss = TRUE)
        }
        else {
          current_params = list()
        }
      }
      
      # Define progress bar
      pb <- txtProgressBar(title = "progress bar", min=0, max=reps, style=3)     
      for (i in 1:reps) {
	   # progress bar
          Sys.sleep(0.1)
          setTxtProgressBar(pb, i)
          if (diss == TRUE) {
          if (unique(names(x) == row.names(x)) == FALSE) {
            stop("the row and column names of the distance matrix are not the same or the distance matrix is not square !")
          }
          else {
              samp_row_names <- sample(row.names(x), as.integer(prop * 
              sample_number))
            samp_x <- x[samp_row_names, samp_row_names]
            samp_x <- as.dist(samp_x)
          }
		# close progress bar
        Sys.sleep(1)
        close(pb)
        }
        else {
          samp_x <- x[sample(row.names(x), as.integer(prop * sample_number)), ]
          }
    
        clmem <- current_algo(samp_x, clnum, params = current_params)
        conn <- matrix(0, nrow = dim(x)[1] + 1, ncol = dim(x)[1] + 
          1, dimnames = list(c("x", row.names(x)), c("x",row.names(x))))
        conn[row.names(clmem), 1] <- as.matrix(clmem)
        conn[1, row.names(clmem)] <- as.matrix(clmem)
			ordering = order(conn[,1])
			  breakpoints = which(diff(conn[ordering,1]) != 0)
			  if (conn[ordering[1], 1] != 0){
				breakpoints = c(1, breakpoints + 1, nrow(conn) + 1)
			  } else {
				breakpoints = c(breakpoints + 1, nrow(conn) +1)
			  }
			  output = matrix(0, nrow(conn), nrow(conn))

			  for (i in 1:(length(breakpoints) - 1)){
				output[ ordering[breakpoints[i]:(breakpoints[i+1] -1)],
					ordering[breakpoints[i]:(breakpoints[i+1] -1)]] =  1
			  }
			  output[,1] = conn[,1]
			  output[1,] = conn[,1]
			  conn <- output
        final <- conn[2:dim(conn)[1], 2:dim(conn)[1]]
		rownames(final) <- row.names(x)
		colnames(final) <- row.names(x)
        id = final
        id[] <- 0
        id[row.names(clmem), row.names(clmem)] <- 1
        final_conn = final_conn + final
        final_id = final_id + id
      }
      consensus = final_conn/final_id
      ind <- is.na(consensus)
      consensus[ind] <- 0
      rm <- current_algo(x, clnum, params = current_params)
      current_consmatrix <- new("consmatrix", cm = consensus, 
                                rm = rm, a = algorithms[[a]], k = clnum, call = match.call())
      cmlist[paste("e", a, "_", algorithms[[a]], "_k", 
                   clnum, sep = "")] <- current_consmatrix
      if (merge != 0) {
        weighted <- current_consmatrix@cm * norm[a]
        mm <- mm + weighted
      }
    }
    if (merge != 0) {
      mm <- new("mergematrix", cm = mm, k = clnum, a = "merge")
      cmlist[paste("merge_k", clnum, sep = "")] <- mm
    }
  }
  return(cmlist)
}