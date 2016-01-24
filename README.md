# PubKeyStore.js

A node.js App Server for storing your ssh Public Keys to make it easier maintaining your multiple device keys.

## Setup your dev environment

* You need a node 4.2 api-compatible version.
* `npm install` all dependencies
* Start the server by typing `DEBUG=pubkey* node .`

## Architecture

the keys are stored in a redis database hash per devicekey:
```
home-windows10:
	pubkey: ssh-ed25519 XxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXx user@home-windows10
	revoked: false
	added: 1453668035634
	seclevel: 10
```

It's worth mentioning that the Timestamp in `added` is an [EcmaScript Timestamp](http://www.ecma-international.org/ecma-262/5.1/#sec-15.9.1.1). ES measures Time in milliseconds sine 01 January, 1970 UTC.

The seclevel can be used to query the store for different security environments (higher seclevel means the device is more trusted).


## API

###authentication

all requests tagged with **AUTH** have to include 3 query variables:

* `uid`: the clients userid
* `ts`: the request timestamp
* `token`: md5( timestamp + ":" + userid + ":" + usersecret )


### store a new key
**AUTH**

POST /store?uid={uid}&ts={ts}&token={token}

```
POST /store?uid=user&ts=1453668035634&token=5e6d399f82271e45c7e33193ca4136db
Content-Type: application/json

{
	"pubkey": "ssh-ed25519 XxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXx user@home-windows10"
	"device": "home-windows10"
	"seclevel": 10
}

Answer:
Content-Type: application/json
{
	"id": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}
```

### revoke a key
**AUTH**

POST /revoke?uid={uid}&ts={ts}&token={token}

```
POST /revoke?uid=user&ts=1453668035634&token=5e6d399f82271e45c7e33193ca4136db
Content-Type: application/json

{
	"id": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}

Answer:
Content-Type: application/json
{
	"msg": "ok"
}
```

### query a key status

GET /get/by/id/:id or  
GET /get/by/device/:device or  
POST /get/by/pubkey

```
GET /get/by/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

Answer:
Content-Type: application/json
{
	"device": "home-windows10"
	"id": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	"pubkey": "ssh-ed25519 XxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXx user@home-windows10"
	"revoked": false
	"added": 1453668035634
	"seclevel": 10
}
```

### query all keys with a higher seclevel than x

GET /get/by/sec/:x

```
GET /get/by/sec/5

Answer:
Content-Type: application/json
{
	"length": 1
	"keys": [
		{ key information... }
	]
}
```
