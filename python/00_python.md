## Structure of this directory
- 00_python.md: overall summary for python
- 01_xxxxxx.md: summary of a specific topic
- 02_yyyyyy.md: summary of another specific topic
- numpy_pkg.py: code for numpy package. Do not name it a numpy.py, as Python will confuse it with the numpy package.
- xxxx_pkg.py: code for another package. Still avoid name conflicts.

## Set up

### use virtual environment
Debian is very restrictive in installing Python package system-wide or user-wide. So the best practice is to create virtual environments for specific projects. Typically we only need a couple of virtual environments for tasks like data science and web applications.
```sh
# create a data science virtual environment
$ python3 -m venv ~/projects/my_ds_venv
# To activate the environment for any data-science project
$ source ~/projects/my_ds_venv/bin/activate
```

### use ipython for REPL
It is used in `iron.lua` for LazyVim.

To get documentation of a function at ipython console:

`> help(np.argmax)`



## tricks

### unpack a dictionary as function argument
The dictionary keys must match function parameters.

```python
dic = {"x": 100, "y": 200}
def add(x, y):
    return(x + y)
    
add(**dic)
    # 300
```

## Packages

### numpy

#### np.argmax()
Index of the largest value along a axis

```python
import numpy as np
arr = np.array([[1,3,2,1], [2,5,8,9], [9,4,4,3]])
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
```
