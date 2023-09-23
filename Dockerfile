
FROM debian:11

ARG TAG=v1.3.340

RUN apt update && apt install git curl wget unzip -y

RUN git clone --depth 1 --branch $TAG https://github.com/quarto-dev/quarto-cli.git && \
    mv quarto-cli /Service
WORKDIR /Service

# Plotting support by adding Python 3.8 to install list
# python3 -m pip install jupyter matplotlib plotly
RUN ./configure.sh

WORKDIR /Content
EXPOSE 80

CMD ["quarto", "preview", \
    "--port", "80", "--host", "0.0.0.0", "--timeout", "0", \
    "--no-browser"]
