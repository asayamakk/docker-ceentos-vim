FROM centos:7

# ncurses-devel TUIのアプリ(vim)動かすのに必要
RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y wget curl tree grep libssl-dev openssl \
                   ncurses-devel lua-devel ruby-devel
RUN mkdir -p /data/gitfiles && \
    cd /data/gitfiles && \
    git clone https://github.com/vim/vim.git && \
    cd /data/gitfiles/vim && \
     ./configure --with-features=huge \
                 --enable-fail-if-missing --enable-multibyte --enable-fontset \
                 --enable-rubyinterp --enable-luainterp && \
    make && make install

RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ENTRYPOINT ["tail", "-f", "/dev/null"]
