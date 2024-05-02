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