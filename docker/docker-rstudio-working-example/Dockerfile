# rocker/rstudio:4.4.2 by build id
FROM rocker/rstudio@sha256:71cceddbaac4d201fb911aaf5a62ca76902361547d7537e765c5c16367fcc7cb

# install core packages from file
COPY install_packages.R .
RUN Rscript install_packages.R

# for covr::report() only
RUN Rscript -e "install.packages(c('DT', 'htmltools'))"

# for selfSrv
RUN Rscript -e "install.packages(c('gitr', 'installr'))"

# update packages when rebuild image
RUN Rscript -e "update.packages(ask = FALSE)"

# install customize version of openxlsx, which write workbook faster for selfSrv run
COPY openxlsx_4.2.5.9002.tar.gz .
RUN Rscript -e 'install.packages("openxlsx_4.2.5.9002.tar.gz", repos = NULL, type = "source")'

# create a .ssh directory to be mounted to host .ssh for github / bitbucket
# RUN mkdir /home/rstudio/.ssh

# install my favirate font for RStudio
COPY ./ubuntu-fonts/UbuntuMono-Regular.ttf .
RUN install -m644 UbuntuMono-Regular.ttf /etc/rstudio/fonts/

# display git branch in RStudio Server terminal
# COPY bashrc /etc/bash.bashrc

# clean up files
RUN rm UbuntuMono-Regular.ttf install_packages.R openxlsx_4.2.5.9002.tar.gz

# install missing utilities
RUN apt update
RUN apt install less
RUN apt install -y vim
RUN apt install -y openssh-client
RUN apt install -y iputils-ping     # for debugging internet
RUN apt install -y curl  # in case need to install other app in container

# create a .ssh directory to be mounted to host .ssh for github / bitbucket
RUN mkdir /home/rstudio/.ssh

# display git branch in RStudio Server terminal and add $HOME/bin to path
COPY bashrc /etc/bash.bashrc

# vimrc for all
COPY vimrc /etc/vim/vimrc
# for retrobox colorscheme
ENV TERM=xterm-256color

# Install vim-plug into the system vim folder for shared usage
RUN curl -fLo /etc/vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Install plugins as the root user in the shared directory
RUN mkdir /etc/vim/plugged
RUN vim -u /etc/vim/vimrc +PlugInstall +qall
# Set proper permissions for all users to access id they need
RUN chmod -R go+rX /etc/vim

EXPOSE 8787
