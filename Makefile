CONTAINERFILE = ./Containerfile
IMAGE_NAME = dpop/bucketeer
APP_VERSION = v1
GIT_HASH = test
CONTAINER_IMAGE = $(IMAGE_NAME):$(APP_VERSION)-$(GIT_HASH)
CONTAINER_IMAGE_ECR = $(ECR_REGISTRY)/$(IMAGE_NAME):$(APP_VERSION)-$(GIT_HASH)
CONTAINER_NAME = bucketeer-$(APP_VERSION)-$(GIT_HASH)

build:
	npm run build

exec: build
	./validate-env.sh
	node dist/index.js

image:
	docker rmi -f $(CONTAINER_IMAGE) || true
	docker build -f $(CONTAINERFILE) -t $(CONTAINER_IMAGE) .

image-ecr:
	docker rmi -f $(CONTAINER_IMAGE_ECR) || true
	docker build -f $(CONTAINERFILE) -t $(CONTAINER_IMAGE_ECR) .
	docker push $(CONTAINER_IMAGE_ECR)

container: image
	./validate-env.sh
	docker rm $(CONTAINER_NAME) || true
	docker run -d \
		-p 3000:3000 \
		-e BUCKET_NAME=$(BUCKET_NAME) \
		-e AWS_REGION=$(AWS_REGION) \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		--name $(CONTAINER_NAME) \
		$(CONTAINER_IMAGE)
