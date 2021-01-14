# The image to build (just the basename)
BASENAME := bats-with-helpers

DOCKER_ID := mvignjevic

# IMAGE := $(REGISTRY)/$(BASENAME)
IMAGE := $(DOCKER_ID)/$(BASENAME)

# # This version-strategy uses git tags to set the version string
# TAG := $(shell git describe --tags --always --dirty)

BLUE=\033[0;34m
NC=\033[0m # No Color

.PHONY: lint
lint:
	@echo "\n\n${BLUE}Running Shellcheck analysis against test_helpers.bash file...${NC}\n"
		@shellcheck ./tests/test_helpers.bash && echo "OK"
	@echo "\n\n${BLUE}Running Hadolint linter against Dockerfile...${NC}\n"
		@docker run --rm -i hadolint/hadolint < Dockerfile && echo "OK"
	@echo "\n"

.PHONY: build
# Example: make build VERSION=0.0.1
build:
	@echo "\n\n${BLUE}Building Docker image with labels:\n"
	@echo "  name: $(BASENAME)"
	@echo "  version: $(VERSION)${NC}\n"
		@sed                                     \
			-e 's|{NAME}|$(BASENAME)|g'            \
			-e 's|{VERSION}|$(VERSION)|g'        \
			Dockerfile | docker build --tag $(IMAGE):$(VERSION) -f- .
	@echo "\n"

.PHONY: test
# Example: make test VERSION=0.0.1
test:
	@echo "\n\n${BLUE}Running test-example.bats unit tests using Docker image:\n"
	@echo "  name: $(BASENAME)"
	@echo "  version: $(VERSION)${NC}\n"
		@docker run 					\
			--rm 						\
			-t 						\
			--volume "${PWD}:/code" 	\
			$(IMAGE):$(VERSION) 		\
			./tests/test-example.bats
	@echo "\n"

.PHONY: push
# Example: make push VERSION=latest
push: lint build test
	@echo "\n${BLUE}Pushing image to GitHub Docker Registry...${NC}\n"
	@docker push $(IMAGE):latest

.PHONY: shell
# Example: make shell VERSION=0.0.1
shell:
	@echo "\n\n${BLUE}Launching a shell in the containerized build environment...${NC}\n"
		@docker run 					\
			--rm 						\
			-it 						\
			--volume "${PWD}:/code" 	\
			--entrypoint /bin/sh 		\
			$(IMAGE):$(VERSION)

.PHONY: shell
# Example: make shell-cmd VERSION=0.0.1 CMD="-c 'date >> datefile'"
shell-cmd:
	@echo "\n\n${BLUE}Running a shell command in the containerized build environment...${NC}\n"
		@docker run 					\
			--rm 						\
			-t 						\
			--volume "${PWD}:/code" 	\
			--entrypoint /bin/sh 		\
			--user $$(id -u):$$(id -g) 	\
			$(IMAGE):$(VERSION) 		\
			$(CMD)

.PHONY: clean
clean:
	rm -rf .pytest_cache .coverage .pytest_cache coverage.xml

.PHONY: docker-clean
docker-clean:
	@echo "\n\n${BLUE}Pruning unused Docker images filtered by \"label=name=$(BASENAME)\"...${NC}\n"
	@docker system prune --force --filter "label=name=$(BASENAME)"
	@echo "\n"
