# README

## Project 


As recommended in the task the project is implemented to create a simple subscription model in which any subscription created via subscription UI are kept locally to view the changes on the local as well. 

Subscription model keeps only the subscription id and its status as well as the customer id, name and email to make an easier references back to UI. 

On the root, http://localhost:3000/, the worked subscriptions are listed to view the state changes for ease. 

Considering the high volume of the operations (a theoretical case) that may arise (especially at the end of the months, when subscriptions may have high volume of operations), the project is implemented to handle each operation as a service which run as a background job. 
For each operation, subscription create, update and delete, 5 concurrent workers are defined to process jobs from each operation queue. 

## How to run the app 

The app makes use of sidekiq & redis for background services and postgresql as database service. 

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

* How to run the test suite

* Deployment instructions

* ...
