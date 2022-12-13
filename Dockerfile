FROM ruby:3.1.2

WORKDIR /app

COPY script.rb /app
RUN chmod +x /app/script.rb

CMD ["/app/script.rb"]
