# CheapFlights 🛫


## Running

To run you can just use `iex mix -S run` or if you have docker then please follow the commands below
```
make docker-image
docker run -p 127.0.0.1:8080:8080/tcp -it sultaniman/cheap-flights
```

Once it is done you can check out one of the following links


http://localhost:8080/findCheapestOffer/?origin=MUC&destination=LCY&departureDate=2021-09-28

`{"data":{"cheapestOffer":{"airline":"ba","amount":132.38}}}`

http://localhost:8080/findCheapestOffer/?origin=MUC&destination=CDG&departureDate=2021-09-26

`{"data":{"cheapestOffer":{"airline":"klm","amount":199.29}}}`

http://localhost:8080/findCheapestOffer/?origin=MUC&destination=LHR&departureDate=2021-09-28

`{"data":{"cheapestOffer":{"airline":"ba","amount":156.38}}}`
