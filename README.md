# MsgpackGenerator
Tiny tool to generate [Message Pack](https://msgpack.org/) data

## Install gems
```bash
$ bundle
```

## Record structure
```ruby
record = {
  "username" => "yen",
  "password" => "T1mMv5X93",
  "domain_name" => "lednerhahn.co",
  "domain_word" => "jenkinswilkinson",
  "domain_suffix" => "com",
  "ip_v4_address" => "56.114.87.215",
  "private_ip_v4_address" => "10.104.135.172",
  "ip_v6_address" => "791d:f037:a4d4:f036:5565:dde:817b:9a89",
  "mac_address" => "80:f1:bb:94:0f:a1",
  "url" => "http://prohaska.io/fabian.daugherty",
  "user_agent" => "Mozilla/5.0...",
  "uuid" => "dd99be15-a73d-4296-a52d-938d5d815187"
}
```

## Usage
```
usage: mpg COMMAND [options]

options:
  -t, --total [NUM]                Number of records, default is 10
      --gzip                       Gzip
  -o, --output FILE_NAME           Output file
  -i, --input FILE                 Message pack file for extracting data, either .msgpack or .msgpack.gz
  -f, --fields FIELDS              Fields to be generated, comma separated
      --version                    show version

commands:
  gen       # generate message pack data
  degen     # extract data from a .msgpack or .msgpack.gz file

```
## Examples
```bash
# generate 20 records and zip it as .gz format
> ./bin/mpg gen -t 20 -o tadada -z
```

```bash
# unpack a msgpack file
> ./bin/mpg degen -i example_file.msgpack or example_file.msgpack.gz
```

```bash
# generate data with pre-defined fields
# only string supported
> ./bin/mpg gen -t 200 -o file_name -f col1,col2,col3
```
