# This project (cachematrix.R) sets up two functions, makeCacheMatrix and 
# cacheSolve, that implement cached matrix inversion for square invertible
# matrices. 
# (1) makeCacheMatrix creates a special "matrix" object that can cache
# its inverse and (2) a "wrapper-like" function for solve (the R matrix inverse 
# function) that calculates and caches inverses using makeCacheMatrix.

# The first function, `makeCacheMatrix` creates a special "matrix", which is
# really a list containing named functions that:
# 
# 1.  set the value of the passed in (square, invertible) matrix
# 2.  get the value of the matrix
# 3.  set the value of the inverse
# 4.  get the value of the inverse

## Usage example: 
## 1. Create a cachable matrix object initialized to the passed in
## matrix: Note the the matrix must be square to be used by cacheSolve or solve.
## Solve will throw an error otherwise. cacheSolve will pass the error through. 
# y=makeCacheMatrix(matrix(c(0,.5,.5,0),2,2)) 
## 2. Solve for the inverse of matrix (assuming the matrix is invertable): 
# inverse <- cacheSolve(matrixX) 
# [,1] [,2] 
# [1,]  0.0  0.5 
# [2,]  0.5  0.0 
## 3. Solve for the inverse again with the same matrix: 
# inverse <- cacheSolve(matrixX) 
# getting cached data [,1] [,2] 
# [1,]  0.0  0.5 [2,]  0.5  0.0 
## 4. If cachable matrix object is changed via set or new one initialized, 
## a new inverse is computed and cached when cacheSolve is called

## Test case is included as test.R in this folder

makeCacheMatrix <- function(initial_matrix = matrix()) {
## When makeCacheMatrix object is initialized or set, inverse_matrix is set to NULL
  inverse_matrix <- NULL
  set <- function(y) {
    initial_matrix <<- y
    inverse_matrix <<- NULL
  }
  get <- function() 
    initial_matrix
  setinverse <- function(inverse) 
    inverse_matrix <<- inverse
  getinverse <- function() 
    inverse_matrix
  list(set = set, get = get,
       setinverse = setinverse,
       getinverse = getinverse)
}


# The following function calculates the inverse of the special "matrix"
# created with the above function. However, it first checks to see if the
# inverse has already been calculated. If so, it `gets the inverse from the
# cache and skips the computation. Otherwise, it calculates the inverse of
# the data and sets the value of the inverse in the cache via the `setinverse`
# function.

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
  inverse <- x$getinverse()
  if(!is.null(inverse)) {
    message("getting cached data")
    return(inverse)
  }
  data <- x$get()
  inverse <- solve(data, ...)
  x$setinverse(inverse)
  return(inverse)
}
