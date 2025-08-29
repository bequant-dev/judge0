FROM buildpack-deps:jammy AS production

ENV JUDGE0_HOMEPAGE "https://judge0.com"
LABEL homepage=$JUDGE0_HOMEPAGE

ENV JUDGE0_SOURCE_CODE "https://github.com/judge0/judge0"
LABEL source_code=$JUDGE0_SOURCE_CODE

ENV JUDGE0_MAINTAINER "Herman Zvonimir Došilović <hermanz.dosilovic@gmail.com>"
LABEL maintainer=$JUDGE0_MAINTAINER

ENV PATH "/usr/local/ruby-2.7.0/bin:/opt/.gem/bin:$PATH"
ENV GEM_HOME "/opt/.gem/"

# Install GCC 13, Ruby, and Node.js via apt
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      gcc-13 \
      g++-13 \
      gfortran-13 \
      ruby \
      ruby-dev \
      ruby-bundler \
      nodejs \
      npm && \
    mkdir -p /usr/local/gcc-13.0.0/bin && \
    mkdir -p /usr/local/gcc-13.0.0/lib64 && \
    ln -sf /usr/bin/gcc-13 /usr/local/gcc-13.0.0/bin/gcc && \
    ln -sf /usr/bin/g++-13 /usr/local/gcc-13.0.0/bin/g++ && \
    ln -sf /usr/bin/gfortran-13 /usr/local/gcc-13.0.0/bin/gfortran && \
    rm -rf /var/lib/apt/lists/*

# Install isolate (following the compilers Dockerfile pattern)
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends git libcap-dev && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/judge0/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    git checkout ad39cc4d0fbb577fb545910095c9da5ef8fc9a1a && \
    make -j$(nproc) install && \
    rm -rf /tmp/*
ENV BOX_ROOT /var/local/lib/isolate

# Install additional system dependencies for Judge0
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      cron \
      libpq-dev \
      sudo \
      postgresql-client \
      redis-tools \
      tzdata \
      locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Install Ruby gems and Node.js packages
RUN echo "gem: --no-document" > /root/.gemrc && \
    gem install bundler:2.1.4 && \
    npm install -g --unsafe-perm aglio@2.3.0

EXPOSE 2358

WORKDIR /api

COPY Gemfile* ./
RUN RAILS_ENV=production bundle

COPY cron /etc/cron.d
RUN cat /etc/cron.d/* | crontab -

COPY . .

# Create judge0 user and set permissions (moved before ENTRYPOINT)
RUN useradd -u 1000 -m -r judge0 && \
    echo "judge0 ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
    chown judge0: /api/tmp/ && \
    mkdir -p /api/log && \
    chown judge0: /api/log && \
    chmod 755 /api/log

USER judge0

ENTRYPOINT ["/api/docker-entrypoint.sh"]
CMD ["/api/scripts/server"]

ENV JUDGE0_VERSION "1.13.1"
LABEL version=$JUDGE0_VERSION

FROM production AS development

CMD ["sleep", "infinity"]
