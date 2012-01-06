#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'


require 'grit'
require 'erb'
require 'yaml'

@repos = []

def read_config
  config_file = ['~/.gitcalrc', './config.yml'].select{|s|File.exists?(s)}.first
  File.open(config_file, 'r') do |f|
    @config = YAML.load(f.read)
  end
  @config['local_repos'].each do |r|
    @repos << Grit::Repo.new(r)
  end
end

read_config
day = Time.parse(ARGV[0])
@repos.each do |r|
  p r.log('master', :since => day, :until => day)
end
