## Structure of this directory
- python.md: overall summary for python
- xxxxxx.md: summary of a specific topic
- yyyyyy.md: summary of another specific topic
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
# generate installed packages of the virtual environment
$ pip freeze > requirements.txt
# replicate installed packages in another virtual environment
$ pip install -r requirements.txt   # activate this virtual environment first
```

### install packages from a file
In a virtual environment, to generate requirements.txt which contains installed packages
```sh
pip freeze > requirments.txt
```
Edit the file if necessary, for example, some packages might be specific to the computer hardward.

To install the same packages in a new virtual environment on any computer:
```sh
pip install -r requirements.txt
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
See `numpy_pkg.py` for code examples

- `np.argmax(arr, axis)`: get the index of the largest value along an axis
