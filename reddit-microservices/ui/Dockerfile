FROM alpine

ENV APP_HOME=/app
ENV POST_SERVICE_HOST=post
ENV POST_SERVICE_PORT=5000
ENV COMMENT_SERVICE_HOST=comment
ENV COMMENT_SERVICE_PORT=9292

WORKDIR $APP_HOME

ADD . $APP_HOME

# Почему нет ruby-json в зависимостях в Gemfile ????
RUN apk add --no-cache build-base ruby ruby-bundler ruby-dev ruby-json && \
    gem install bundler --no-ri --no-rdoc && bundle install && apk del build-base ruby-dev && \
    rm -rf /usr/share/terminfo/ && rm -rf /root/.bundle/cache/

CMD ["puma"]
