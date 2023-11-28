
FROM nginx

ARG TAG=v1.3.340

RUN apt update && apt install git curl wget unzip -y

RUN git clone --depth 1 --branch $TAG https://github.com/quarto-dev/quarto-cli.git
WORKDIR /quarto-cli

# Plotting support by adding Python 3.8 to install list
# python3 -m pip install jupyter matplotlib plotly
RUN ./configure.sh

COPY publish/render.sh /docker-entrypoint.d/90-render.sh

VOLUME /Content
