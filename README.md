# QueryObjStruct

[README-ptbr.md](README-ptbr.md) in Português-Brasil

QueryObjStruct It allows us to perform queries in a json (only for now), yaml and toml, dynamically...

And the expectations are that it is not necessary to change anything in the queries, just inform the structure of the object.


## Documentation

### Functions

- **[(len [arg1])](#function-len)**
- **[(sum \*arg1)](#function-sum)**
- **[(sequal \*arg1, \*arg2)](#function-sequal)**
- **[(eequal \*arg1, \*arg2)](#function-eequal)**


_(Json obtained from one of BrasilApi's endpoints)_
```json
[
   {
     "name": "Selic",
     "value": 13.75
   },
   {
     "name": "CDI",
     "value": 13.65
   },
   {
     "name": "IPCA",
     "value": 4.18
   }
]
```

#### To get only the names of this array of objects, just type the following query...

`*.name` ▶️ RUN!
```json
[
   "Selic",
   "CDI",
   "IPCA"
]
```

#### To get only the first object of the array...

`[0]` ▶️ RUN!
```json
{
   "name": "Selic",
   "value": 13.75
}
```

#### To get only the 'value' field of the second array object...

`[1].value`

```json
13.75
```


Alright now let's complicate things a little more, let's use functions.


## function len

First argument is optional, but it must be a key.
It is possible to count number of array and characters of a content.

ex:

`([0].(len @name))` ▶️ RUN!
```
5
```
or

`[0].name.(len)` ▶️ RUN!
```
5
```

`(len)` ▶️ RUN!
```
3
```
Above is counting array number.

## function sum

First argument is required

`[0].name.(len)` ▶️ RUN!
```
5
```

## function equal

Returns all array objects that the key (@key) starts with the content.

`(sequal @value, 4)` ▶️ RUN!

or

`(sequal 4, @value)` ▶️ RUN!
```
[
   {
     "name": "IPCA",
     "value": 4.18
   }
]
```

## function eequal

Returns all array objects that the key (@key) ends with the content.

`(eequal @value, 5)` ▶️ RUN!
```
[
   {
     "name": "Selic",
     "value": 13.75
   },
   {
     "name": "CDI",
     "value": 13.65
   }
]
```
<br/>

# stack used

**Back-end:** [Vlang](https://vlang.io/)

**Front-end:** [pico.css](https://picocss.com/)

**Icon:** [lucide](https://lucide.dev/license)

**Code editor:** [ace](https://ace.c9.io/)

**fonts:** [google fonts](https://fonts.googleapis.com)
