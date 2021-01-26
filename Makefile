BASENAME 	?= bats-with-helpers
BUILD_DATE 	:= $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
IMAGE 		?= mvignjevic/$(BASENAME)
VERSION		?= latest

BLUE=\033[0;34m
NC=\033[0m # No Color


.PHONY: lint
lint:
	@echo "\n\n${BLUE}Running Shellcheck analysis against test_helpers.bash file...${NC}\n"
	@shellcheck ./tests/test_helpers.bash && echo "OK"
	@echo "\n\n${BLUE}Running Hadolint linter against Dockerfile...${NC}\n"
	@docker run --rm -i hadolint/hadolint < Dockerfile && echo "OK"
	@echo "\n"


# Examples:
#   1. make build  (defaults to 'latest' tag)
#   2. make build VERSION=0.0.1
.PHONY: build
build:
	@echo "\n\n${BLUE}Building Docker image with labels:\n"
	@echo "  name: $(BASENAME)"
	@echo "  version: $(VERSION)${NC}\n"
	@sed                         		\
		-e 's|{NAME}|$(BASENAME)|g'     \
		-e 's|{VERSION}|$(VERSION)|g'   \
		Dockerfile | docker build --build-arg BUILD_DATE=$(BUILD_DATE) --tag $(IMAGE):$(VERSION) -f- .
	@echo "\n\n${BLUE}Inspect Docker image labels after build:${NC}\n"
	@docker inspect $(IMAGE):$(VERSION) -f '{{ json .Config.Labels }}' | jq -r .
	@echo "\n"


# Examples:
#   1. make test  (defaults to 'latest' tag)
#   2. make test VERSION=0.0.1
.PHONY: test
test:
	@echo "\n\n${BLUE}Running test-example.bats unit tests using Docker image:\n"
	@echo "  name: $(BASENAME)"
	@echo "  version: $(VERSION)${NC}\n"
	@docker run 					\
		--rm 						\
		-t 							\
		--volume "${PWD}:/code" 	\
		$(IMAGE):$(VERSION)			\
		./tests/test-example.bats
	@echo "\n"

# TODO: Add push command for semver major/minor/patch also
# # Example: make push
# .PHONY: push
# push: lint build test
# 	@echo "\n${BLUE}Pushing image to GitHub Docker Registry...${NC}\n"
# 	@docker push $(IMAGE):latest

# When Docker pushes version 2.6.3, they will overwrite all but the 2.6.2 tag.
# None of this happens automatically in Docker; your build and release process should tag and push each of these separately:
# $ docker build -t registry:latest .
# $ docker push registry:latest
# $ docker tag registry:latest registry:2
# $ docker push registry:2
# $ docker tag registry:latest registry:2.6
# $ docker push registry:2.6
# $ docker tag registry:latest registry 2.6.3
# $ docker push registry:2.6.3


# Examples:
#   1. make shell  (defaults to 'latest' tag)
#   2. make shell VERSION=0.0.1
.PHONY: shell
shell:
	@echo "\n\n${BLUE}Launching a shell in the containerized build environment...${NC}\n"
		@docker run 					\
			--rm 						\
			-it 						\
			--volume "${PWD}:/code" 	\
			--entrypoint /bin/sh 		\
			$(IMAGE):$(VERSION)


# Examples:
#   1. make shell-cmd CMD="-c 'date >> datefile'"  (defaults to 'latest' tag)
#   2. make shell-cmd VERSION=0.0.1 CMD="-c 'date >> datefile'"
.PHONY: shell
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


# Examples:
#   1. make docker-clean  (defaults to 'latest' tag)
#   2. make docker-clean VERSION=0.0.1
.PHONY: docker-clean
docker-clean:
	@echo "\n\n${BLUE}Pruning unused Docker images filtered by labels:\n"
	@echo "  \"label=org.opencontainers.image.title=$(IMAGE)\""
	@echo "  \"label=org.opencontainers.image.version=$(VERSION)\"${NC}\n"
	@docker system prune --force \
		--filter "label=org.opencontainers.image.title=$(IMAGE)" \
		--filter "label=org.opencontainers.image.version=$(VERSION)"
	@echo "\n"


.PHONY: clean
clean:
	rm -f .coverage
