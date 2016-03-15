#!/usr/bin/env ruby
# encoding: utf-8
require './modules.rb'
require 'yaml'

IDs = YAML.load_file("IDs.yaml")

IDs["events"].each { |e|
    Event.populate e
}
