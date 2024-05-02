# Backend Masterclass - Golang, PostgreSQL, Kubernetes, gRPC

[course link](https://www.udemy.com/course/backend-master-class-golang-postgresql-kubernetes/learn/)

## Section 1: Introduction

### Application we will build

- Simple Bank API
  - Create and manage account
    - Owner, balance, currency
  - Record all balance changes
    - Create an account entry for each change
  - Transfer money between accounts
    - Create an account entry for each transfer
- Database Design
  - Design DB schema
  - Generate SQL code

## Technologies

- Golang
- PostgreSQL
- Kubernetes
- gRPC
- Docker
- Helm

## Database Migrations Explored

Database migrations are a way to evolve a database schema easily and reliably across all environments. They are a way to make changes to a database in a structured and organized way. They have a way of going about this thru up/down migrations. Up migrations are the changes that you want to apply to the database and down migrations are the changes that you want to revert. Up migration are run sequentially and down migrations are run in reverse order.

## DB Learnings

A database is a structured set of data. So, in PostgreSQL, a database is a collection of schemas, and those schemas contain tables. Tables, on the other hand, is a collection of related data held in a structured format within a database. It consists of columns, and rows. Each column in a table is designed to store a certain type of information, like numbers, texts, or dates. Each row in the table represents a set of related data, and every row in the table has the same structure.

To put it simply, you can think of a database as a file cabinet, and a table as an individual drawer within that cabinet. The drawer (table) holds related documents (rows), and each document has the same set of attributes (columns).

> If you are going to create a Makefile with a help command, you can use the following snippet:

```makefile
.PHONY: help

help: ## Display details on all commands
	@awk 'BEGIN {FS = ":.*?##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
```

The comments after the colon is the description of the command. The `awk` command is used to parse the Makefile and display the commands and their descriptions.

An example output would be:

```bash
postgres                   Create Postgres container
mysql                      Create MySQL container
createdb                   Create the database with the name simple_bank and owner root
dropdb                     Drop the database tables simple_bank
migrateup                  Run the migration up command
migrateup1                 Run the migration up command with verbose flag and limit to 1
migratedown                Run the migration down command
migratedown1               Run the migration down command with verbose flag and limit to 1
new_migration              Create a new migration file
db_docs                    Generate the database documentation
db_schema                  Create the DBML file and convert to PostgreSQL compatible SQL script
sqlc                       Generate the SQLC code
test                       Run tests for all packages in the current directory and all subdirectories
server                     Run the server
mock                       Generate the mock files for the database and worker
proto                      Generate the proto files
evans                      Start an interactive gRPC client session with a gRPC server
redis                      Create a Redis container
help                       Display details on all commands
init_migration             Create a new migration files
```

## Generate CRUD Golang code from SQL

## What is CRUD?

CRUD stands for Create, Read, Update, and Delete. It is a set of operations that are used to create, read, update, and delete data. These operations are commonly used in databases and RESTful APIs.

Ways to use SQL in Golang:

- [database/sql package](https://pkg.go.dev/database/sql)
  - fast
  - manual mapping SQL fields to variables
- [GORM](https://pkg.go.dev/gorm.io/gorm)
  - Crud functions already implemented
  - Must learn to write query in GORM
  - Associations are also GORM specific
  - Slow on high load
- [SQLX](https://pkg.go.dev/github.com/jmoiron/sqlx)
  - Fast
  - Fields mapping via query text and struct tags
  - Failure won't occur until runtime
- [SQLC](https://pkg.go.dev/github.com/zeromicro/go-zero/core/stores/sqlc)
  - Fast and straight forward
  - Automatic code generation after just writing SQL
  - "idiomatic" Go code generation
  - Only supports PostgreSQL

## Golang Context

The context package in Go is used for **carrying deadlines**, **cancellation signals**, and **other request-scoped values across API boundaries and between processes**. It's often used in networked functions where it's necessary to manage timeouts, cancellations, and passing request-scoped data.

```go
func (q *Queries) CreateAccount(ctx context.Context, arg CreateAccountParams) (Account, error) {
	row := q.db.QueryRow(ctx, createAccount, arg.Owner, arg.Balance, arg.Currency)
	var i Account
	err := row.Scan(
		&i.ID,
		&i.Owner,
		&i.Balance,
		&i.Currency,
		&i.CreatedAt,
	)
	return i, err
}
```

`context.Context` is being used as the first parameter of the `CreateAccount` function. This allows the function **to handle cancellation signals and to pass along specific request-scoped data**.

Here's a brief explanation of how it's used:

- `ctx context.Context`: This is the context parameter. You can think of it as a bag of data that can be passed along to functions and routines. It can include data like deadlines or cancellation signals that can help long-running functions know when they should stop running.
- `q.db.QueryRow(ctx, createAccount, arg.Owner, arg.Balance, arg.Currency)`: Here, the context `ctx` is passed to the `QueryRow` function. If a cancellation signal is sent to `ctx`, `QueryRow` will stop executing and return immediately.

> 🧠 Context is often used in functions that call networked services, perform I/O operations, or run for a long duration, as these are situations where you might need to cancel an operation before it finishes.
