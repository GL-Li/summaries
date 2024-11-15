import numpy as np

""" =================================================================
numpy rank 1 array
- A numpy rank 1 array is a vector, which has a shape of (n,).
  It has no attributes like row or column so its transpose is
  still a (n,) vector.
- Try to avoid rank 1 array, use explicit shape instead. for example,
  when create random numbers, use
    - np.random.randn(3, 1) for column vector
    - or np.random.randn(1, 3) for row vector
    - not np.random.randn(3), if ever happens
        - aaa.reshape((3, 1)) to convert to column vector
        - aaa.reshape((1, 3)) to convert to row vector
- When construct from python list
    - np.array([1, 2, 3]) is a vector
    - np.array([[1, 2, 3]]) is a 1x3 matrix
"""

# a (3,) array
aaa = np.random.randn(3)
aaa.shape
# its transpose is still a (3,) array
aaa.T.shape
# their dot product is a scalr
np.dot(aaa, aaa.T)

# a (3, 1) array
bbb = np.random.randn(3, 1)
bbb.shape
# its transpost is a (3, 1) array
bbb.T.shape
# their dot product is a matrix
np.dot(bbb, bbb.T)

""" =================================================================
np.argmax()
- Index of the largest value along a axis
"""

arr = np.array([[1, 3, 2, 1], [2, 5, 8, 9], [9, 4, 4, 3]])
# array([[1, 3, 2, 1],
#        [2, 5, 8, 9],
#        [9, 4, 4, 3]])

# axis=0 means which row index has the largest value (in each column)
np.argmax(arr, axis=0)
# array([2, 1, 1, 1])

# axis=1 returns column index of the largest value in each row
np.argmax(arr, axis=1)
# array([1, 3, 0])

# axis=-1 where -1 is the index of the last axis, which is column for 2-D arrays
np.argmax(arr, axis=-1)
# array([1, 3, 0])

""" ================================================================
broadcasting
- in element-wise matrix operations, numpy automatically coverts low
  deimensional matrix into high deimensional matrix to match the
  other one so that the operations can complete
"""

# 3x4 matrix
A = np.array([[56.0, 0.0, 4.4, 68.0], [1.2, 104.0, 52.0, 8.0], [1.8, 135.0, 99.0, 0.9]])
# 1x4 matrix
col_sum = A.sum(axis=0)
# duplicate 1x4 col_sum into 3x4 and then element-wise division
percent = 100 * A / col_sum
