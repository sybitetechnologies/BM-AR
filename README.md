# README

This README would normally document whatever steps are necessary to get the
application up and running.

* Rails Version - 5.0.0.1

### Prerequisites
1. Ruby 2.3.1
2. bundler ruby gem
3. Postgres

### Setup steps: 
Please execute below steps

1. bundle install
2. bower install
3. rake db:create db:migrate
4. rails s --> localhost:3000

### End points: 

#### Transfer money:

```ruby
POST   --  /api/transfer --> 
params: {
	amount: <floating number>,
	credited_user: <Creditor user email>
}

response: {
	amount: <FLoating number>,
	credit_user: {
		email: <email>,
		name: <name>
	},
	debit_user: {
		email: <email>,
		name: <name>
	},
}
```

#### Withdraw money:

```ruby
POST   -- /api/withdraw --> 
params: {
	amount: <floating number>
}

response: {
	amount: <FLoating number>,
	debit_user: {
		email: <email>,
		name: <name>
	},
}
```

#### Deposit money:

```ruby
POST   --  /api/deposit --> 
params: {
	amount: <floating number>,
	credited_user: <Creditor user email>
}

response: {
	amount: <FLoating number>,
	credit_user: {
		email: <email>,
		name: <name>
	}
}
```

#### Transactions:

```ruby
GET   --  /api/transactions --> 

response: [{
	amount: <FLoating number>,
	credit_user: {
		email: <email>,
		name: <name>
	},
	debit_user: {
		email: <email>,
		name: <name>
	},
}]
```

#### Get balance:

```ruby
GET   --  /api/balance --> 

response: [{
	amount: <FLoating number>,
	user: {
		email: <email>,
		name: <name>
	},
}]
```

### Device Token gem custom messages:

#### User sign up:
 
```ruby
curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/api/auth -d "{\"email\":\"user@example.com\",\"password\":\"12341234\", \"confirm_success_url\":\"foo\"}"

response:
{"status":"success","data":{"id":2,"provider":"email","uid":"user@example.com","name":null,"nickname":null,"image":null,"email":"user@example.com","created_at":"2017-01-02T15:30:20.516Z","updated_at":"2017-01-02T15:30:20.516Z"}}
```

#### User sign in with error formats:

```ruby
curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/api/auth/sign_in -d "{\"email\":\"user@example.com\",\"password\":\"12341234\"}"

{"data":{"id":1,"email":"user@example.com","provider":"email","uid":"user@example.com","name":null,"nickname":null,"image":null}}

curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/api/auth/sign_in -d "{\"email\":\"user@example.com\",\"password\":\"123412341\"}"

{"error":"Failed to login","errors":{"password":["Invalid password"]}}%

curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/api/auth/sign_in -d "{\"email\":\"user1@example.com\",\"password\":\"12341234\"}"

{"error":"Failed to login","errors":{"email":["A confirmation email was sent to your account at '%{email}'. You must follow the instructions in the email before your account can be activated"]}}


curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/api/auth/sign_in -d "{\"email\":\"unidentified@example.com\",\"password\":\"12341234\"}"

{"error":"Failed to login","errors":{"email":["User not found"]}}

```




TODO: 

1. API documentation. 
2. Search implementation. 
3. Playground for action cable. (more of playground)

