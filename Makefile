DB_URL=postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable

network: ## Create Docker network for the project
	docker network create bank-network

postgres: ## Create Postgres container
	docker run --name postgres --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:14-alpine

mysql: ## Create MySQL container
	docker run --name mysql8 -p 3306:3306  -e MYSQL_ROOT_PASSWORD=secret -d mysql:8

createdb: ## Create the database with the name simple_bank and owner root
	docker exec -it postgres createdb --username=root --owner=root simple_bank

dropdb: ## Drop the database tables simple_bank
	docker exec -it postgres dropdb simple_bank

migrateup: ## Run the migration up command
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1: ## Run the migration up command with verbose flag and limit to 1
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown: ## Run the migration down command
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1: ## Run the migration down command with verbose flag and limit to 1
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

new_migration: ## Create a new migration file
	migrate create -ext sql -dir db/migration -seq $(name)

db_docs: ## Generate the database documentation
	dbdocs build doc/db.dbml

db_schema: ## Create the DBML file and convert to PostgreSQL compatible SQL script
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml

sqlc: ## Generate the SQLC code
	sqlc generate

test: ## Run tests for all packages in the current directory and all subdirectories
	go test -v -cover -short ./...

server: ## Run the server
	go run main.go

mock: ## Generate the mock files for the database and worker
	mockgen -package mockdb -destination db/mock/store.go github.com/polyglotdev/simplebank/db/sqlc Store
	mockgen -package mockwk -destination worker/mock/distributor.go github.com/polyglotdev/backend-masterclass-go/worker TaskDistributor

proto: ## Generate the proto files
	rm -f pb/*.go
	rm -f doc/swagger/*.swagger.json
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
	--go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=pb --grpc-gateway_opt=paths=source_relative \
	--openapiv2_out=doc/swagger --openapiv2_opt=allow_merge=true,merge_file_name=simple_bank \
	proto/*.proto
	statik -src=./doc/swagger -dest=./doc

evans: ## Start an interactive gRPC client session with a gRPC server
	evans --host localhost --port 9090 -r repl

redis: ## Create a Redis container
	docker run --name redis -p 6379:6379 -d redis:7-alpine

help: ## Display details on all commands
	@awk 'BEGIN {FS = ":.*?##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

init_migration: ## Create a new migration files
	@echo "Creating migration"
	migrate create -ext sql -dir db/migration -seq init_schema  # Create migration file
	@echo "Migration created"

.PHONY: network postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 new_migration db_docs db_schema sqlc test server mock proto evans redis help
