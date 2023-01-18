FROM debian:sid-slim as builder 
ARG TARGETARCH
ARG SRATOOLS_VER="3.0.3"
ARG NCBI_VDB_VER="3.0.2"
ARG SRATOOL='fasterq_dump'
RUN apt-get update && apt-get install -y curl cmake bzip2 build-essential g++ libbz2-dev libz-dev ncurses-dev liblzma-dev libcurl4-openssl-dev 
RUN curl -L https://github.com/ncbi/ncbi-vdb/archive/refs/tags/${NCBI_VDB_VER}.tar.gz | tar -zvxf -
RUN curl -L https://github.com/ncbi/sra-tools/archive/refs/tags/${SRATOOLS_VER}.tar.gz | tar -zxvf - 
RUN cd ncbi* && ./configure && make && make install
RUN cd ../sra* && ./configure && make && make install

FROM debian:sid-slim
ARG SRATOOLS_VER="3.0.3"
COPY --from=builder  /usr/local/ncbi/sra-tools/bin /usr/local/ncbi/sra-tools/bin
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="$PATH:/usr/local/ncbi/sra-tools/bin"
