CONTAINERFILE = ./Containerfile
IMAGE_NAME = unleash/bucketeer
APP_VERSION = v1
GIT_HASH = test
CONTAINER_IMAGE = $(IMAGE_NAME):$(APP_VERSION)-$(GIT_HASH)
CONTAINER_NAME = bucketeer-$(APP_VERSION)-$(GIT_HASH)

build:
	npm run build

exec: build
	./validate-env.sh
	node dist/index.js

image:
	podman rmi -f $(CONTAINER_IMAGE) || true
	podman build -f $(CONTAINERFILE) -t $(CONTAINER_IMAGE)

container: image
	./validate-env.sh
	podman rm $(CONTAINER_NAME) || true
	podman run -d \
		-p 3000:3000 \
		-e BUCKET_NAME=$(BUCKET_NAME) \
		-e AWS_REGION=$(AWS_REGION) \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		--name $(CONTAINER_NAME) \
		$(CONTAINER_IMAGE)
