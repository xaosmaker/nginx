dev-init-run: dev-build
	./scripts/local_setup.sh
	docker compose -f devops/local.yaml up -d --remove-orphans

dev-run: prod-build
	docker compose -f devops/local.yaml up -d

dev-build:
	docker compose -f devops/local.yaml build --no-cache

dev-down-v:
	docker compose -f devops/local.yaml down -v



inspect_nginx:
	 docker exec -it nginx /bin/sh

logs:
	docker logs nginx

test-conf: 
	 docker exec -it nginx nginx -t 

hot-reload: test-conf
	 docker exec -it nginx nginx -s reload




prod-init-run: prod-build
	./scripts/prod_setup.sh
	docker compose -f devops/prod.yaml up -d

prod-run: prod-build
	docker compose -f devops/prod.yaml up -d

prod-build:
	docker compose -f devops/prod.yaml build --no-cache

prod-down-v:
	docker compose -f devops/prod.yaml down -v

