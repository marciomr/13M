#!/usr/bin/env ruby
# encoding: utf-8
require './modules.rb'

IDs = YAML.load_file("IDs.yaml")

IDs["events"].each { |e|
    Event.populate e
}
