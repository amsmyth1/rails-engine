# README
This is an e-commerce API plug in to be utilized to expose merchants, items, and business intelligence queries.

  ## Authors
  - **Alexa Morales Smyth**
  | [GitHub](https://github.com/amsmyth1) |
  [LinkedIn](https://linkedin.com/alexamorales)

# Rails Engine

  Rails Engine is an e-commerce API that exposes 15 paginated endpoints. Users can expose information on merchants, then details on said merchant. The API allows the user to have CRUD functionality over Items, which are owned by merchants. Features include search of merchants and items and business intelligence features.

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
| GET | /api/v1/items/find?max_price=<num>&min_price=<num> | Find one item in between search parameter |
| GET | /api/v1/revenue/merchants?quantity=<num> | Find top <num> merchants by revenue |
| GET | /api/v1/revenue?start=<start_date>&end=<end_date> | Revenue based on a date range |
| GET | /api/v1/revenue/merchants/<merchant_id> | Revenue for a specific merchant |
| GET | /api/v1/revenue/unshipped?quantity=<num> | Top invoices with Potential revenue |

#### Pagination
- Pagination is available on all endpoints. To use, at the end of the path, add the following:
  `?page=1per_page=10`
The above sample of code will give you page 1 of the results and 10 results on the page. If a page is selected but there are no more results to display, and empty array will be returned.

### Organization of Application Code
- Model, Controller, Serializer design pattern is used for this application.
- The business intelligence endpoints are all related to revenue, so the RevenueController handles these endpoints.
- The Search Endpoints are handled by the SearchesController.

#### Refactor
- I opted to move forward with edge case testing and logic. All RSPec test have testing for edge cases. However this logic in the controller code god lengthy and required nested if statements. This would be the first thing I refactor. Ideally this logic would be abstracted away into a module.
- Review location of revnue queries. Should they all live in the merchant? Refactored potential revenue away from Merchant this morning and makes more sense living in Invoice.
- Add more testing for edge cases, got most of the edge cases tested in RSpec, but missed 1 or 2.

### Test Coverage
- Testing is at 99% coverage
- Postman required testing is passing at 100%
- Postman edge cases are passing. For example, the search item by price. All edge cases are passing in postman and in RSpec test.

### Active Record Queries
- Agile method applied. The AR queries were easier to complete while I grasped the concept of Controllers with json and Serializers. I had all BI and search queries completed by day 2. The remainder of the week was focused on understanding the API build, then connecting the Model methods to the controllers. Because Agile was applied, and I completed a lot of work when I could not complete the main portion of work, my project timeline was not affected and overall smooth.
