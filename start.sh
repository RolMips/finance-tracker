#!/bin/bash

# Function to check if PostgreSQL is running
is_running_postgresql() {
  pg_isready > /dev/null 2>&1
  return $?
}

# Function to check if Redis is running
is_running_redis() {
  redis-cli ping > /dev/null 2>&1
  return $?
}

# Check and start PostgreSQL service
if is_running_postgresql; then
  echo "PostgreSQL is already running."
else
  echo "PostgreSQL is not running. Starting it..."
  sudo service postgresql start
  if is_running_postgresql; then
    echo "PostgreSQL started successfully."
  else
    echo "Failed to start PostgreSQL."
    exit 1
  fi
fi

# Check and start Redis service
if is_running_redis; then
  echo "Redis is already running."
else
  echo "Redis is not running. Starting it..."
  sudo service redis-server start
  if is_running_redis; then
    echo "Redis started successfully."
  else
    echo "Failed to start Redis."
    exit 1
  fi
fi

# Run yarn build:sss
#echo "Running 'yarn build:css'..."
#yarn build:css
#if [ $? -ne 0 ]; then
#  echo "'yarn build:sss' failed."
#  exit 1
#fi

# Start the Rails server
echo "Starting Rails server with 'bundle exec rails server'..."
bundle exec rails server
if [ $? -ne 0 ]; then
  echo "Failed to start the Rails server."
  exit 1
fi
