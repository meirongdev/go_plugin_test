FROM golang:alpine3.16 AS plugin
# Set the Current Working Directory inside the container
WORKDIR app
# Copy everything from the current directory to the Working Directory inside the container
COPY go_plugin .
RUN  apk add git gcc musl-dev 
# ENV GOCACHE OFF
RUN go env -w GOPRIVATE=github.com/csdaomin/go_plugin_test && \
    go build -trimpath -buildmode=plugin -o plugin.so
#RUN go get github.com/csdaomin/go_plugin_test/go_module
FROM golang:alpine3.16 AS server
# Set the Current Working Directory inside the container
RUN  apk add git gcc musl-dev 
WORKDIR app
COPY go_server .
# Copy everything from the current directory to the Working Directory inside the container
COPY --from=plugin /go/app/plugin.so .
# ENV GOCACHE OFF
RUN git config --global url."https://csdaomin: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@github.com".insteadOf "https://github.com"
RUN go env -w GOPRIVATE=github.com/csdaomin/go_plugin_test && \
    go build -trimpath -o main
CMD ./main