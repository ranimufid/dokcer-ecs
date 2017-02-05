FROM ubuntu:14.04
FROM ruby:2.2.5

MAINTAINER rnag <ranimufid@gmail.com>

EXPOSE 3000

# skip installing gem documentation
# RUN echo 'install: --no-document\nupdate: --no-document' >> "$HOME/.gemrc"

# Updates apt-package list and downloads libpq to ensure we can communicate with postgres
RUN apt-get update && apt-get install -qq -y --no-install-recommends build-essential libpq-dev nodejs

# Ensure that all gems are installed globally to avoid usage restriction later
# ENV GEM_HOME /usr/local/bundle
# ENV PATH $GEM_HOME/bin:$PATH

# install RVM, Ruby, and Bundler
# RUN \curl -L https://get.rvm.io | bash -s stable
# RUN /bin/bash -l -c "rvm requirements"
# RUN /bin/bash -l -c "rvm install ruby-2.2.5"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

# Specifies our application's final resting directory and craetes it
ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH

RUN cd $INSTALL_PATH && git clone https://github.com/askcharlie/guestbook.git
WORKDIR $INSTALL_PATH/guestbook
# RUN export REDIS_HOST=localhost && export DATABASE_URL="postgres://guestbook:Nfz98ukfki7Df2UbV8H@localhost/guestbook"
RUN bundle install
# RUN gem install rails
# RUN bundle exec rake db:migrate REDIS_HOST=localhost DATABASE_URL="postgres://guestbook:Nfz98ukfki7Df2UbV8H@localhost:5432/guestbook"
# CMD puma -p 3000
ENV REDIS_HOST=redis-guestbook.nzi5ls.ng.0001.apse1.cache.amazonaws.com
ENV DATABASE_URL="postgres://guestbook:Nfz98ukfki7Df2UbV8H@guestbookrdsinstance.c9uxdqlpr6hm.ap-southeast-1.rds.amazonaws.com:5432/guestbook"
CMD bundle install && rake db:migrate && puma -p 3000