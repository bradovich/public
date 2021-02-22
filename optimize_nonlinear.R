# steepest descent of banana function

gradfxy <- function(x,y) {
  rbind((200*(y - x^2)*(-2*x) + 2*(1 - x)*(-1)),(200*(y - x^2)*1))
  }

# pass initial x & y-values, fixed step size, error margin
desc <- function(x0,y0,stepsize,e) {
    
    iter <- 0
    while (norm(as.matrix(gradfxy(x0,y0))) > e) {
      di = -gradfxy(x0,y0)/norm(as.matrix(gradfxy(x0,y0)))
      si = stepsize
      rbind(x1,y1) = rbind(x0,y0) + si*di
      x0 = x1
      y0 = y1
    
      iter = iter + 1
    }
    cat("Final x value:  ",xi[1])
    cat("\nFinal y value:  ",xi[2])
    cat("\n# Iterations:  ",iter)
}

desc(4,4,0.0001,0.001)


# steepest descent of banana function - backtracking algorithm

gradfxy <- function(x,y) {
  rbind((200*(y - x^2)*(-2*x) + 2*(1 - x)*(-1)),(200*(y - x^2)*1))
}

# define f(x,y)
fxy <- function(x,y) {
  100*(y - x^2)^2 + (1 - x)^2
}

# pass initial x & y-values, initial step size, error margin
desc_bktrk <- function(x0,y0,stepsize,e) {
  
  iter <- 0
  si = stepsize
  while (norm(as.matrix(gradfxy(x0,y0))) > e) {
    di = -gradfxy(x0,y0)/norm(as.matrix(gradfxy(x0,y0)))
    xi = rbind(x0,y0) + si*di
    x1 = xi[1]
    y1 = xi[2]
    
    if (fxy(x1,y1) >= fxy(x0,y0)){
      si = si*0.5
    }
    
    x0 = x1
    y0 = y1
    iter = iter + 1
  }
  cat("\nFinal x value:  ",xi[1])
  cat("\nFinal y value:  ",xi[2])
  cat("\n# Iterations:  ",iter)
}
  

desc_bktrk(4,4,5,0.001)



# define f(x,y)
fxy <- function(X) {
  x = X[1]
  y = X[2]
  100*(y - x^2)^2 + (1 - x)^2
}

nonlinear = nlm(fxy,c(4,4))
cat("Final x,y:  ", nonlinear$estimate,"\n")
cat("# Iterations:  ", nonlinear$iterations)
