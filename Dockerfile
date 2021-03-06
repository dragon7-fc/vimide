FROM ubuntu:focal

# Install tools
RUN apt-get update
RUN apt-get install -y vim curl unzip git wget

# Install python
RUN apt-get update
RUN apt-get install -y python3 python3-setuptools python3-pip python3-dev virtualenv \
 && ln -s /usr/bin/python3.8 /usr/bin/python \
 && ln -s /usr/bin/pip3 /usr/bin/pip
RUN pip install jedi flake8 autopep8 yapf

RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

# Install C and C++
RUN apt-get install -y gcc g++ build-essential clang clang-tidy clang-format cmake

# Install java and mvn
RUN apt-get install -y openjdk-11-jdk
RUN apt-get install -y maven
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=${PATH}:/usr/local/bin:${JAVA_HOME}/bin
RUN wget https://github.com/google/google-java-format/releases/download/google-java-format-1.6/google-java-format-1.6-all-deps.jar -P /usr/local/share/vim/
RUN wget https://repo1.maven.org/maven2/org/projectlombok/lombok/1.18.8/lombok-1.18.8-sources.jar -P /usr/local/share/vim
RUN wget https://repo1.maven.org/maven2/org/projectlombok/lombok/1.18.8/lombok-1.18.8.jar -P /usr/local/share/vim

# Install javascript
RUN curl -o- https://deb.nodesource.com/setup_14.x | bash
RUN apt-get install nodejs

# Install go
RUN curl -sL --retry 5 "https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz" \
    | gunzip | tar -x -C /usr/local/
ENV GOPATH=/user/work/go
ENV PATH=${PATH}:/usr/local/go/bin:${GOPATH}/bin
RUN go get golang.org/x/tools/cmd/goimports

COPY google-java-format /usr/local/bin/

RUN apt-get install -y locales \
 && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install RipGrep
RUN wget -O rg.deb https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb \
 && dpkg -i rg.deb \
 && rm rg.deb

# Install FZF
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
 && ~/.fzf/install
ENV PATH=${PATH}:/root/.fzf/bin

# Install misc
RUN apt-get install exuberant-ctags cscope
RUN pip3 install grip compiledb ranger-fm
ENV PATH=${PATH}:/root/.local/bin

COPY vimrc /root/.vimrc

# Download vundle plug and install all vim plugins using vimplug
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN vim +PlugInstall +qall

RUN cd ~/.vim/plugged/YouCompleteMe \
 && python3 ./install.py --java-completer --clangd-completer --go-completer --js-completer \
 && cd -
COPY ftplugin /root/.vim/ftplugin/
COPY ycm_extra_conf.py /root/.vim/.ycm_extra_conf.py


CMD ["/usr/bin/vim"]
