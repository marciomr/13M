#!/usr/bin/env ruby
# encoding: utf-8
require './modules.rb'

IDs = YAML.load_file("IDs.yaml")

IDs["events"].values.flatten.each { |e|
    Event.populate e
}

IDs["pages"].each { |p|
    Page.populate p, IDs["limits"]
}
