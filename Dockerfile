# ############################
# # STEP 1 build executable binary
# ############################
# # golang alpine 1.13.5
# FROM golang@sha256:0991060a1447cf648bab7f6bb60335d1243930e38420bee8fec3db1267b84cfa as builder

# # Install git + SSL ca certificates.
# # Git is required for fetching the dependencies.
# # Ca-certificates is required to call HTTPS endpoints.
#  RUN apk update && apk add --no-cache git ca-certificates tzdata && update-ca-certificates

# # # Create appuser
# ENV USER=appuser
# ENV UID=10001

# # See https://stackoverflow.com/a/55757473/12429735
# RUN adduser \
#     --disabled-password \
#     --gecos "" \
#     --home "/nonexistent" \
#     --shell "/sbin/nologin" \
#     --no-create-home \
#     --uid "${UID}" \
#     "${USER}"
# WORKDIR $GOPATH/src/mypackage/myapp/


# COPY . .


# ENV GO111MODULE=on
# RUN go mod download
# RUN go mod verify



# # Build the binary
# RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
#       -ldflags='-w -s -extldflags "-static"' -a \
#       -o /go/bin/user-server ./cmd/server


# ############################
# # STEP 2 build a small image
# ############################
# FROM scratch

# WORKDIR /root/

# # Import from builder.
# COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
# COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# COPY --from=builder /etc/passwd /etc/passwd
# COPY --from=builder /etc/group /etc/group

# #Copy our static executable
# COPY --from=builder /go/bin/user-server /go/bin/user-server
# # COPY --from=builder $GOPATH/src/mypackage/myapp/b.env b.env



# # # Use an unprivileged user.
# USER appuser:appuser
# EXPOSE 8564 8085
# #Run the hello binary.
# CMD ["/go/bin/user-server","grpc-port","8564"]

FROM  scratch

ADD ./bin/server_linux ./bin/server_linux

ENTRYPOINT ["/bin/server_linux","--grpc-port", "8456"]