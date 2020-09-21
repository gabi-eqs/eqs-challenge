FROM alpine/helm as helm
FROM jenkins/jenkins:lts

COPY --from=helm /usr/bin/helm /usr/sbin/helm

