""" ========================================================================
Debug python code line by line in iPython

commands:
  - l: list current line
  - n: execute next line
  - c: run all remaining lines
  - q: quit ipdb. Must quit before working on next cells.
"""

import ipdb


def aaa(x, y):
    ipdb.set_trace()
    a1 = x * 55
    a2 = a1 * y
    return a2


print(aaa(3, 5))
