# menu-api

The project provides a RESTful API for manage parking.

## Table of Contents

- [Run project](#run_project)
- [API](#api)
- [Test](#test)


## Run project
To run the project you need the following:

- Docker && Docker Compose

1. Clone the repository:

```
git clone https://github.com/murilo-miranda/parking-api.git
```

2. Create .env file in root with content:

```
DB_HOST=parking-db
POSTGRES_USER=parking-api
POSTGRES_PASSWORD=parking-api123
```

3. Run docker:

```
docker compose up
```

## Test

Run the command:

```
rspec
```

## API

* **POST /v1/parking**: Creates new data.

201
```json
{ id: Parking.last.id, plate: 'ABC-1234' }
```

422
```json
{ Validation failed: "Plate can't be blank" }
```

422
```json
{ Validation failed: "Plate is the wrong length (should be 8 characters)" }
```

422
```json
{ Validation failed: "Plate is invalid" }
```

