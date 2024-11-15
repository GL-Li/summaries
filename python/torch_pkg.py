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
