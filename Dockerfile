# see docker-compose.yml for details
# which drives this file with 4 params 

ARG IMAGE_REPO # tryretool is public docker repository

ARG RETOOL_VERSION # "3.114.1-stable" as of Dec 2024

# 2 Images Needed
# - backend + code-executor-service
# - if airgapped, change: tryretool/backend-airgapped
ARG RETOOL_IMAGE

ARG START_CMD

FROM $IMAGE_REPO/$RETOOL_IMAGE:$RETOOL_VERSION

# Retool vs Code Executor have different start commands
CMD $START_CMD
