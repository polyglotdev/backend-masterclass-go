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
