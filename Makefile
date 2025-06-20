run: build
	docker-compose -f local.yaml up -d

build:
	docker-compose -f local.yaml build --no-cache

inpect_nginx:
	 docker exec -it nginx /bin/bash
down-v:
	docker-compose -f local.yaml down -v

logs:
	docker logs nginx


init-run-prod: build-prod
	python3 create_dir.py
	docker-compose -f prod.yaml up -d

run-prod: build-prod
	docker-compose -f prod.yaml up -d

build-prod:
	docker-compose -f prod.yaml build --no-cache


test-conf: 
	 docker exec -it nginx nginx -t 

hot-reload: test-conf
	 docker exec -it nginx nginx -s reload

down-v-prod:
	docker-compose -f prod.yaml down -v

