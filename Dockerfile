FROM centos:7

#  INSTALL vim
## ncurses-devel required for TUI applications
RUN yum update -y && \
    yum groupinstall -x ctags -y "Development Tools" && \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y ncurses-devel lua-devel ruby-devel python-devel python36-devel.x86_64

RUN mkdir -p /data/gitfiles && \
    cd /data/gitfiles && \
    git clone https://github.com/vim/vim.git && \
    cd /data/gitfiles/vim && \
     ./configure --with-features=huge \
                 --enable-fail-if-missing --enable-multibyte --enable-fontset \
                 --enable-rubyinterp --enable-pythoninterp --enable-python3interp --enable-luainterp \
                 --with-python3-command=/usr/bin/python3.6 && \
    make && make install

RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ARG VIMRC_SOURCE_URL="$VIMRC_SOURCE_URL"
RUN if [ -n "$VIMRC_SOURCE_URL" ]; then \
      curl $VIMRC_SOURCE_URL -o ~/.vimrc; \
    fi

RUN yum install -y man wget curl tree grep openssl which

WORKDIR /data/gitfiles

# INSTALL ctags
RUN git clone https://github.com/universal-ctags/ctags.git && \
    cd ctags && \
    ./autogen.sh && ./configure --enable-iconv && \
    make && make install


ENTRYPOINT ["tail", "-f", "/dev/null"]
