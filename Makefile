VERSION ?= v1

images: build-build-vite build-package-textures build-package-electron build-deploy-steam build-deploy-web build-steam-login

build-build-vite:
	docker build -t vaguevoid/build-vite:$(VERSION) -f build/vite/Dockerfile build/vite

build-package-textures:
	docker build -t vaguevoid/package-textures:$(VERSION) -f package/textures/Dockerfile package/textures

build-package-electron:
	docker build -t vaguevoid/package-electron:$(VERSION) -f package/electron/Dockerfile package/electron

build-deploy-steam:
	docker build -t vaguevoid/deploy-steam:$(VERSION) -f deploy/steam/Dockerfile deploy/steam

build-deploy-web:
	docker build -t vaguevoid/deploy-web:$(VERSION) -f deploy/web/Dockerfile deploy/web

build-steam-login:
	docker build -t vaguevoid/steam-login:$(VERSION) -f deploy/steam/Dockerfile deploy/steam/login

.PHONY: images
