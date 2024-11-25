# define the function
checkHomeDirectory() {
  pattern="/home/[a-zA-Z][a-zA-z0-9]*$"
  # $1 is the first parameters to the function
  if [[ $1 =~ $pattern ]]; then
    echo "$1 is a valid home directory"
  else
    echo "$1 is an invalid home directory"
  fi
}

# call the function
input="/home/xyz"
checkHomeDirectory "$input"

input="/home/3aa"
checkHomeDirectory "$input"
