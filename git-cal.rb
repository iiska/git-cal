#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'


require 'grit'
require 'erb'

log = `git-log --pretty=format:'%an|%at|%s'`.split("\n").map do |line|
  items = line.split('|')
  {:author => items[0], :timestamp => items[1], :message => items[2]}
end

template = File.open("template.html.erb"){|f| f.read}

rhtml = ERB.new(template)

puts rhtml.result
