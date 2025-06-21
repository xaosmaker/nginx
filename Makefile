init-run: build
	sudo python3 create_dir.py
	docker compose -f local.yaml up -d

run: build
	docker compose -f local.yaml up -d

build:
	docker compose -f local.yaml build --no-cache

down-v:
	docker compose -f local.yaml down -v



inspect_nginx:
	 docker exec -it nginx /bin/bash

logs:
	docker logs nginx

test-conf: 
	 docker exec -it nginx nginx -t 

hot-reload: test-conf
	 docker exec -it nginx nginx -s reload




init-run-prod: build-prod
	python3 create_dir.py prod
	docker compose -f prod.yaml up -d

run-prod: build-prod
	docker compose -f prod.yaml up -d

build-prod:
	docker compose -f prod.yaml build --no-cache

down-v-prod:
	docker compose -f prod.yaml down -v

