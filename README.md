# parking-api

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

* **PUT /v1/parking/:id/pay**: Make parking payment.

200
```json
{ message: "parking payed for ABC-1234" }
```

404
```json
{ "Couldn't find Parking with 'id'=999" }
```

422
```json
{ Validation failed: "Paid can't be processed again" }
```

* **PUT /v1/parking/:id/out**: Left parking.

200
```json
{ message: "ABC-1234 left parking" }
```

404
```json
{ "Couldn't find Parking with 'id'=999" }
```

422
```json
{ Validation failed: Left unauthorized without paying" }
```

* **GET /v1/parking/:plate**: History of parking.

200
```json
[
  { id: 1, time: "60 minutes", paid: true, left: true },
  { id: 2, time: "300 minutes", paid: true, left: false },
  { id: 3, time: "180 minutes", paid: false, left: false }
]
```

404
```json
{ "Couldnt find Parking history for plate: Invalid" }
```
