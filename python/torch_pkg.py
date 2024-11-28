import torch

"""torch.randint(low=0, high, size) -> Tensor ===============================
Generate a tensor of integers in the range of [low, high) with shape defined
by tuple size.
"""

torch.randint(3, 5, (3,))
# tensor([3, 3, 4])

torch.randint(10, (2, 3))
# tensor([[7, 8, 1],
#         [0, 2, 6]])


"""torch.stack(tensors, dim=0) -> Tensor =====================================
Concatinate a sequence of tensors along a new dimension
- tensors: a sequence, list,  ...
"""

x = torch.randint(10, (3,))
x.shape  # torch.size([3])
y = torch.stack((x, x))
y.shape  # torch.size([2, 3]), new dimension as dim=0

z = torch.stack([torch.randint(10, (3,)) for i_ in range(5)])
z.shape  # torche.size([5, 3])


"""torch.Tensor.repeat =========================================================
Tile a small tensor into larger and higher dimensional tensor
"""
x = torch.tensor([[1, 2, 3], [4, 5, 6]])  # 2 x 3
x.repeat(4, 1, 1).shape  # 4 x 2 x 3. consider x as 1 x 2 x 3
x.repeat(5, 2, 3).shape  # 5 x 4 x 9. which is (5, 2, 3) x (1, 2, 3)
x.repeat(2, 3, 4, 5).shape  # 2 x 3 x 8 x 15. consider x as 1 x 1 x 2 x 3
x.repeat(2, 3, 4)  # 2 x 6 x 12: 2 stacks, 6 rows, 12 columns
  # The steps for repeat
  # - repeat 4 times along column directoion, the resulting tensor then
  # - repeat 3 times along row direction
  # - repeat 2 times along stack
  # tensor([[[1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3],
  #          [4, 5, 6, 4, 5, 6, 4, 5, 6, 4, 5, 6],
  #          [1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3],
  #          [4, 5, 6, 4, 5, 6, 4, 5, 6, 4, 5, 6],
  #          [1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3],
  #          [4, 5, 6, 4, 5, 6, 4, 5, 6, 4, 5, 6]],
  # 
  #         [[1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3],
  #          [4, 5, 6, 4, 5, 6, 4, 5, 6, 4, 5, 6],
  #          [1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3],
  #          [4, 5, 6, 4, 5, 6, 4, 5, 6, 4, 5, 6],
  #          [1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3],
  #          [4, 5, 6, 4, 5, 6, 4, 5, 6, 4, 5, 6]]])
  
  
""" torch.bmm: batch matrix-matrxi product ====================================
torch.bmm(input, mat2)
- input, mat2: both are 3D tensors. each containing the same number of matrix
- if input is b x n x m, then mat2 must be b x m x p.
- so the output tensor is b x n x p
"""

X = torch.randn(2, 3, 4)
y = torch.randn(2, 4, 5)
torch.bmm(x, y)  # 2 x 3 x 5
  #  tensor([[[ 1.5850e+00, -1.9927e+00,  1.5198e-01,  2.2982e+00,  2.3274e+00],
  #           [-3.2416e+00,  2.1791e-01, -1.4190e+00, -3.4571e-01,  9.3174e-01],
  #           [ 6.9060e-01, -1.2362e+00, -1.2842e+00,  1.8101e+00,  6.7247e-01]],
  #  
  #          [[ 2.5660e-03,  5.6626e-01, -1.0658e-01,  1.1091e-01, -4.1017e-01],
  #           [ 5.1315e-01, -1.0887e+00,  1.1123e+00, -9.0566e-01,  8.4658e-01],
  #           [-4.7447e-01, -7.3012e-02,  1.7248e+00,  2.0508e-01, -2.9208e+00]]])
  

""" torch.permute: swap dimensions ==================================================
torch.permute(input, dim):
- input: tensor
- dims: tuple, desired ordering of dimensions
"""
x = torch.randn(2, 3, 5)     # 2 x 3 x 5
  # tensor([[[-0.6052,  0.4068,  2.1475,  0.4667, -1.2674],
  #          [-1.4267,  0.2561,  0.0940,  0.5747,  0.1233],
  #          [-0.5415,  0.9545, -0.0475, -1.8620, -0.3716]],
  # 
  #         [[ 1.3319,  1.9364,  0.0412, -1.7772, -1.4953],
  #          [-0.1296, -1.4581, -0.5004, -0.3329, -0.8342],
  #          [ 1.0152,  1.1924,  1.2936, -0.0849, -0.2542]]])
torch.permute(x, (2, 0, 1))  # 5 x 2 x 3
  # tensor([[[-0.6052, -1.4267, -0.5415],
  #          [ 1.3319, -0.1296,  1.0152]],
  # 
  #         [[ 0.4068,  0.2561,  0.9545],
  #          [ 1.9364, -1.4581,  1.1924]],
  # 
  #         [[ 2.1475,  0.0940, -0.0475],
  #          [ 0.0412, -0.5004,  1.2936]],
  # 
  #         [[ 0.4667,  0.5747, -1.8620],
  #          [-1.7772, -0.3329, -0.0849]],
  # 
  #         [[-1.2674,  0.1233, -0.3716],
  #          [-1.4953, -0.8342, -0.2542]]])
  #

""" torch.argmax: return indices of max value along a dimention ===============
dim: reduce along this dimension while keep other dimensions unchanged.
- Take a mxn 2D tensor for example, if dim=0, the first step is to collapse it 
  into a 1xn tensor, then replace each element with the row index of the max 
  element.

"""
x = torch.arange(24).reshape(2, 3, 4)
  # tensor([[[ 0,  1,  2,  3],
  #          [ 4,  5,  6,  7],
  #          [ 8,  9, 10, 11]],
  # 
  #         [[12, 13, 14, 15],
  #          [16, 17, 18, 19],
  #          [20, 21, 22, 23]]])

# flattern array
torch.argmax(x)  # idex 23 of flatterned array

# reduce (colapse) the first dimention to 1 from 2, find the max value and return 
# its index along the first dimention.
torch.argmax(x, dim=0)
  # tensor([[1, 1, 1, 1],
  #         [1, 1, 1, 1],
  #         [1, 1, 1, 1]])

# reduce the second dimension from 3 to 1, find the max value and return its 
# index along the second dimention
torch.argmax(x, dim=1)
  # tensor([[2, 2, 2, 2],
  #         [2, 2, 2, 2]])

# do the same for the third dimension
torch.argmax(x, dim=2)
  # tensor([[3, 3, 3],
  #         [3, 3, 3]])

# now it is easy to understand 2D case
aaa = torch.tensor([[0.9991, 0.0009],
                    [0.9982, 0.0018],
                    [0.9949, 0.0051],
                    [0.0491, 0.9509],
                    [0.0307, 0.9693]])
torch.argmax(aaa, dim=0)  # tensor([0, 4])
torch.argmax(aaa, dim=1)  # tensor([0, 0, 0, 1, 1])

