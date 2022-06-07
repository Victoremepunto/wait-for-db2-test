#!/usr/bin/env sh

command_exists() {
  command -v "$1" >/dev/null
}

set_container_engine() {
  if command_exists "docker"; then
    echo "docker"
  elif command_exists "podman"; then
    echo "podman"
  else
    echo ""
  fi
}

CONTAINER_ENGINE=$(set_container_engine)
CONTAINER_NAME="db2server"
SUCCESS_LOG_ENTRY="Setup has completed"
START_SECONDS="$SECONDS"

if [ -z "$CONTAINER_ENGINE" ]; then
  echo "cannot find either Docker or Podman in PATH"
  exit 1
fi

$CONTAINER_ENGINE run -h "$CONTAINER_NAME" \
  --privileged=true \
  --name "$CONTAINER_NAME" \
  --restart=always \
  -d -p 50000:50000 \
  -v $(pwd)/database:/database:z \
  --env-file .env \
  docker.io/ibmcom/db2

echo -n "waiting for db2"

while ! grep -q "Setup has completed" <<<$($CONTAINER_ENGINE logs "$CONTAINER_NAME" 2>/dev/null); do
  echo -n '.'
  sleep 1
done


echo -e "\n Took $(( SECONDS - START_SECONDS )) seconds"
