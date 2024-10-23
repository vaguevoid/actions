images: build-build-vite build-package-textures build-package-electron build-deploy-steam build-deploy-web build-steam-login

build-build-vite:
	docker build -t vaguevoid/build-vite:v1 -f build/vite/Dockerfile build/vite

build-package-textures:
	docker build -t vaguevoid/package-textures:v1 -f package/textures/Dockerfile package/textures

build-package-electron:
	docker build -t vaguevoid/package-electron:v1 -f package/electron/Dockerfile package/electron

build-deploy-steam:
	docker build -t vaguevoid/deploy-steam:v1 -f deploy/steam/Dockerfile deploy/steam

build-deploy-web:
	docker build -t vaguevoid/deploy-web:v1 -f deploy/web/Dockerfile deploy/web

build-steam-login:
	docker build -t vaguevoid/steam-login:v1 -f deploy/steam/Dockerfile deploy/steam/login

.PHONY: images
