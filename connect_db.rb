#!/usr/bin/env ruby
# encoding: utf-8
require 'mysql2'
require 'active_record'

ActiveRecord::Base.establish_connection(
   :adapter   => 'mysql2',
   :encoding  => 'utf8',
   :host      => 'localhost',
   :port      => 3306,
   :username  => '13M',
   :password  => '13M',
   :database  => '13M'
)
