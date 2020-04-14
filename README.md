# MsgpackGenerator
Tiny tool to generate [Message Pack](https://msgpack.org/) data

## Install gems
```bash
$ bundle
```

## Usage

```
Usage: mpg [command] [options]

Commands:
gen, degen

Options:
    -t, --total [NUM]                Number of records
    -z, --gzip [flag]                Gzip
    -o, --output [FILE NAME]         File name
    -i, --input [FILE NAME]          File name
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
