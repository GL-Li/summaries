#!/bin/bash

echo "Starting OpenAI Chat Bot with Docker Compose..."
echo "The container will start in interactive mode."
echo "You can type your questions and get responses from OpenAI."
echo "Type 'quit', 'exit', or 'q' to stop the chat bot."
echo "Press Ctrl+C to stop the container."
echo ""

# Build the image first
docker compose build

# Run the container interactively, use run instead of up
docker compose run --rm app
