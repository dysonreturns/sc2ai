FROM aiarena/arenaclient-bot:latest
LABEL service="bot-ruby-local"

USER root
WORKDIR /root/ruby-builder

ARG RUBY_VERSION=3.3.0
ARG DEBIAN_DISABLE_RUBYGEMS_INTEGRATION=true

# Deps - Ruby build
RUN apt-get update
RUN apt install --assume-yes rustc curl build-essential libssl-dev zlib1g-dev libgmp-dev uuid-dev

# Deps - libyaml from source
RUN curl https://pyyaml.org/download/libyaml/yaml-0.2.5.tar.gz -o yaml-0.2.5.tar.gz
RUN tar -zxf yaml-0.2.5.tar.gz

# Ruby
RUN mkdir -p /root/ruby-builder/.ruby
RUN curl https://cache.ruby-lang.org/pub/ruby/3.3/ruby-$RUBY_VERSION.tar.gz -o ruby-$RUBY_VERSION.tar.gz
RUN tar -zxf ruby-$RUBY_VERSION.tar.gz
RUN mkdir ruby-$RUBY_VERSION/build
WORKDIR /root/ruby-builder/ruby-$RUBY_VERSION/build
RUN ../configure --prefix="/root/ruby-builder/.ruby" --disable-install-doc --enable-shared --enable-load-relative --with-libyaml-source-dir=/root/ruby-builder/yaml-0.2.5
RUN make install -j8

# Clean
WORKDIR /root/ruby-builder
RUN rm ruby-$RUBY_VERSION.tar.gz
RUN rm -rf ./ruby-$RUBY_VERSION
RUN rm yaml-0.2.5.tar.gz
RUN rm -rf ./yaml-0.2.5

# Package config
# numo-linalg needs openblas, copy to ruby-prefix/lib/ dir.
RUN apt download libopenblas0-serial
RUN mkdir openblas
RUN dpkg-deb -x ./libopenblas*.deb openblas
RUN cp -d openblas/usr/lib/x86_64-linux-gnu/openblas-serial/* /root/ruby-builder/.ruby/lib/
RUN rm -rf ./openblas
RUN rm ./libopenblas0-serial*.deb

RUN apt download libgfortran5
RUN mkdir libgfortran5
RUN dpkg-deb -x ./libgfortran*.deb libgfortran5
RUN find libgfortran5
RUN cp libgfortran5/usr/lib/x86_64-linux-gnu/libgfortran.so.5 /root/ruby-builder/.ruby/lib/
RUN rm -rf ./libgfortran5
RUN rm ./libgfortran5*.deb

RUN /root/ruby-builder/.ruby/bin/ruby --yjit -v
RUN apt remove --assume-yes rustc curl build-essential libssl-dev zlib1g-dev libgmp-dev uuid-dev

# Ladder zip
RUN apt install --assume-yes zip

ENV PATH "/root/ruby-builder/.ruby/bin:$PATH"

WORKDIR /root/

ENTRYPOINT ["/bin/bash"]
