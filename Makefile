run: build
	docker-compose -f local.yaml up -d

build:
	docker-compose -f local.yaml build --no-cache

inpect_nginx:
	 docker exec -it nginx /bin/bash
down-v:
	docker-compose -f local.yaml down -v



