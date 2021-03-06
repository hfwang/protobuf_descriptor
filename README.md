# protobuf_descriptor

[![Gem Version](http://img.shields.io/gem/v/protobuf_descriptor.svg)][gem]
[![Build Status](http://img.shields.io/travis/hfwang/protobuf_descriptor.svg)][travis]
[![MIT license](http://img.shields.io/badge/license-MIT-red.svg)][license]

[gem]: https://rubygems.org/gems/protobuf_descriptor
[travis]: https://travis-ci.org/hfwang/protobuf_descriptor
[license]: https://github.com/hfwang/protobuf_descriptor/blob/master/LICENSE.txt

* [Homepage](https://rubygems.org/gems/protobuf_descriptor)
* [Documentation](http://rubydoc.info/github/hfwang/protobuf_descriptor/master/frames)

## Description

Protobuf_descriptor provides helper methods to make working with Google Protocol
Buffer descriptors easier, go figure.. It handles type resolution, and computing
type names (both within protocol buffers and in the generated output).

## Examples

Given the `descriptor.desc` generated by the protocol buffer compiler, you
can introspect the various data types. This example references the descriptor
that would be generated by compiling
[single_file.proto](https://github.com/hfwang/protobuf_descriptor/blob/master/spec/protos/single_file_test/single_file.proto)

```ruby
require 'protobuf_descriptor'
descriptor = ProtobufDescriptor.load("descriptor.desc")

# Load a single file by its filename/basename
file_descriptor = descriptor[:single_file]

# Grab a handle to an enum, or a message
file_descriptor.messages[:FieldOptions]
file_descriptor.enums[:UnnestedEnum]

# Also allows resolving types by their fully qualified name:
descriptor.resolve_type(".porkbuns.UnnestedEnum") # note the leading "."
# or even doing so relative to another enum
descriptor.resolve_type("CType", ".porkbuns.FieldOptions")
```

For even more gory details, please peruse the actual
[documentation](http://rubydoc.info/github/hfwang/protobuf_descriptor/master/frames).

## Requirements

I've only tested this on Ruby 1.9.3+. If it works for you on an older version of
Ruby, let me know. You most likely want to install the
[Google Protocol Buffer library](https://code.google.com/p/protobuf/).

## Install

    $ gem install protobuf_descriptor

## Copyright

Copyright (c) 2014 Hsiu-Fan Wang

See LICENSE.txt for details.
