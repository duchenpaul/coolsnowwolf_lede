# docker build -t coolsnowwolf_lede .
# docker run --name coolsnowwolf_lede -v ${pwd}:/app -it coolsnowwolf_lede make menuconfig
# docker cp coolsnowwolf_lede:/app/.config .

FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Base image: ubuntu
RUN sed -i 's/security.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list
RUN sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list
RUN apt-get update && apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf wget swig rsync
RUN apt-get -y autoremove --purge
RUN apt-get clean

RUN mkdir /app
WORKDIR /app
COPY ./ /app/

RUN ./scripts/feeds update -a && ./scripts/feeds install -a  && make defconfig 

CMD ["/bin/bash"]