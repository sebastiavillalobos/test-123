.PHONY: build run restart stop rm delete test sh create-repo delete-repo upload_image push

APP_NAME ?= test-123
GH_USER ?= sebastiavillalobos
VISIBILITY ?= private
VERSION ?= 0.0.1


# Build the Docker image
build:
	@docker build -t test-123 .

# Run the Docker container
run: build
	@echo "Init Container on localhost:8181"
	@docker run -d -p 8181:8181 --name test-123 test-123

# Stop the running Docker container
stop:
	@echo "Stoping test-123 container"
	@docker ps -q --filter "name=test-123" | grep -q . && docker stop test-123 || true

# Remove the stopped container
rm:
	@echo "Removing test-123 container"
	@docker ps -a -q --filter "name=test-123" | grep -q . && docker rm test-123 || true

# Restart the Docker container
restart: stop rm build run

# Delete the project directory
delete: stop rm
	@echo "Deleting test-123 project"
	@cd ..
	@rm -rf test-123

# Run test script
test:
	@echo "Running script test_script.sh"
	@.\/test_script.sh
	@cd ..

# Upload Docker image to Docker Hub
upload_image: build
	@docker buildx build --platform linux\/amd64 -t test-123-amd64: .
	@docker tag test-123-amd64: sebiuo\/test-123:
	@docker push sebiuo\/test-123:
	@cd ..

# Run sh in container
sh:
	@docker exec -it test-123 sh

# Create a new repository
create-repo:
	@echo "Creating a new repository test-123..."
	@gh repo create sebastiavillalobos\/test-123 --public --description "test-123 project repository"
	@git init
	@git add .
	@git commit -m "Initial commit for test-123 project"
	@git branch -M main
	@git remote add origin https:\/\/github.com\/sebastiavillalobos\/test-123.git
	@git push -u origin main

# Delete repository
delete-repo:
	@echo "Deleting repository test-123..."
	@gh repo delete sebastiavillalobos\/test-123 --confirm

# Push changes to repository
push:
	@git add .
	@git commit -m "Update test-123 project"
	@git push -u origin main
