image := sultaniman/cheap-flights
vsn := $(shell git log -1 --pretty=%h)

.PHONY: docker-image
docker-image:
	docker build . -t $(image):latest -t $(image):$(vsn)

.PHONY: fmt
fmt:
	mix format

.PHONY: test
test:
	MIX_ENV=test mix test --trace --cover
