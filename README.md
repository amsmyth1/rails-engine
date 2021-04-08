# README
This is an e-commerce API plug in to be utilized to expose merchants, items, and business inteligence queries.


Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Test suite
#### Railes Engine Part1
1. Merchants
  - [x] Get all merchants
  - [x] Get one merchant
  - [x] Get one merchant's items
2. Items
  - [x] Get all items
  - [x] Get one item
  - [x] Create (then delete) one item
  - [x] Update one item
  - [x] Get an item's merchant
#### Rails Engine Part2
  - [x] Find All Merchants by Name Fragment
  - [x] Find One Item by Name Fragment
  - [x] Find One Item by Prices
#### Rails Engine Part3
  - [x] Get Merchants with Most Revenue
  - [x] Get Revenue between Date Range
  - [x] Get Revenue of a Single Merchant
  - [x] Potential Revenue of Unshipped Orders
---------------------
# README

  ## Authors
  - **Alexa Morales Smyth**
  | [GitHub](https://github.com/amsmyth1) |
  [LinkedIn](https://linkedin.com/alexamorales)

# Merchant Sales Engine

  Merchant Sales Engine is an e-commerce API that exposes 15 paginated endpoints. Users can expose information on merchants, then details on said merchant. The API allows the user to have CRUD functionality over Items, which are owned by merchants. Features include search of merchants and items and business intelligence features.

## Summary

  - [Getting Started](#getting-started)
  - [Runing the tests](#running-the-tests)
  - [Built With](#built-with)
  - [Functionality](#functionality)
  - [Versioning](#versioning)
  - [Authors](#authors)

## Getting Started
### Prerequisites

  This web application is built with Ruby 2.5.3 and Rails 5.2.4.3.

### Installing

  To get the web application running, please fork and clone down the repo.  
`git clone <your@github.account/viewing_party>`

- Install the gems  
`bundle install`

- Create the database  
`rails db{:drop,:create,:migrate,:seed}`

 - Running the tests
RSpec testing suite is utilized for this application. Run the RSpec suit to ensure everything is passing as expected.  
`bundle exec rspec`


## Deployment
*Coming soon*

## Versioning

  The current version is V1. Documentation on versions will be issued as needed in the future.

## Functionality and Usage

| HTTP verbs | Paths  | Used for |
| ---------- | ------ | --------:|
| GET | /api/v1/merchants| Get all merchants|
| GET | /api/v1/merchants/merchant_id   | Get information on a specific user |
| GET | /api/v1/merchants/merchant_id/items   | Get a merchant's items|
| GET | /api/v1/items | Get all items |
| Get | /api/v1/items/item_id | Get information on a specific item |
| POST | /api/v1/items | Create a new item |
| PUT | /api/v1/items/item_id | Edit/Update an existing item |
| GET | /api/v1/items/item_id/merchant | Show an item's merchant |
| GET | /api/v1/merchants/find?name=<query> | Get one merchant that matches query |
| GET | /api/v1/items/find_all?name=<query>| Find all items that match a name query |
| GET | /api/v1/items/find?max_price=<num>&min_price=<num> | Find one item inbetween search parameter |
| GET | /api/v1/revenue/merchants?quantity=<num> | Find top <num> merchants by revenue |
| GET | /api/v1/revenue?start=<start_date>&end=<end_date> | Revenue based on a date range |
| GET | /api/v1/revenue/merchants/<merchant_id> | Revenue for a specific merchant |
| GET | /api/v1/revenue/unshipped?quantity=<num> | Top invoices with Potential revenue |
