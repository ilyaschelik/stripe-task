# README

## Project 


As recommended in the task the project is implemented to create a simple subscription model in which any subscription created via subscription UI are kept locally to view the changes on the local as well. 

Subscription model keeps only the subscription id and its status as well as the customer id, name and email to make an easier references back to UI. Customer Id, name and email fields are just kept for ease to reference while listing them on the dashboard. (They could have been separated and kept as in Customer model, as it is not the scope of the task, for ease, that is skipped.)

It listens 3 events from subscription [webhooks](https://docs.stripe.com/billing/subscriptions/webhooks). customer.subscription.created, customer.subscription.deleted & invoice.payment_succeeded. For handling the cases where a subscription is created, an invoice for a subscription is paid or a subscription is canceled.


On the root, http://localhost:3000/, the worked subscriptions are listed as a dashboard to view the state changes for ease.

Considering the high volume of the operations (a theoretical case) that may arise (especially at the end of the months, when subscriptions may have high volume of operations), the project is implemented to handle operations as a service each of which run as a background job.
For each operation, subscription create, update and delete, 5 concurrent workers are defined to process jobs from each operation queue. 

## How to run the app 

The app makes use of sidekiq & redis for background services and postgres as database service.

*NOTE: Before running the app, please rename the .env-sample file as .env and update the keys defined within with your own credentials from Stripe*

Please run the following command to make the whole app up. 

```
  docker-compose up --build
```

Visit the http://localhost:3000/ and observe no subscription has been worked so far yet.
Visit the http://localhost:3000/sidekiq and observe no processing job has been made yet.

Please run the following command to forward the events from Stripe subscription UI to your webhook

```
checkout the app 
cd /stripe-task 
stripe listen --forward-to localhost:3000/stripe/webhooks
```

Now you are ready to test the app by visiting the Strip.com UI and create, delete subscriptions and pay the invioces in test data mode.

1. Please create a subscription with no initial payment, make sure that the invoice is in draft on UI and see on the dashboard that the subscription has been created as 'unpaid'
2. Visit the invoice for that subscription and 'Charge customer' for that and make the payment. Observe that the 'unpaid' state changes to 'paid'
3. Visit the subscription on UI and click to 'Cancel subscription' button and observe that the state changes to 'canceled' on the dashboard.

*Note: Please notice from logs once a new subscription is created with a auto charge payment, it is first created as 'unpaid' and as it is immediately right after paid, it is updated as 'paid' as expected. While testing, consider to not pay the first invoice and see that the state will stay as 'unpaid' and after a successful payment to change to 'paid' state.*

You can alternatively visit the rails c and check the Subscription model/subscriptions table to observe the changes.


* How to run the test suite

To run the test specs please run the following command: 

```
docker exec -it  -e RAILS_ENV=test -e DATABASE_URL="postgres://postgres:postgres@db:5432/stripe_task_test" stripe-task-web-1 bundle exec rake db:prepare && rspec spec/
```

