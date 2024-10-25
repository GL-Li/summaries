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
