source("cachematrix.R")
# create the cachable matrix object with x set to the passed in 2x2 matrix
x <- makeCacheMatrix(matrix(c(0,4,4,0),nrow = 2,ncol = 2))
# Note the environment variable value. This is how R determines lexical scope
print ("x summary information is: ")
print (x)
print ("The value of the x matrix is:")
print (x$get())
# invert the matrix
i <- cacheSolve(x)
print ("The inverse of x is:")
print (i)
# invert the same matrix again
print ("Computing the inverse of the same matrix again, returns its cached value")
i <- cacheSolve(x)
print(i)