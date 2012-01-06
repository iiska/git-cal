#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require 'grit'
require 'yaml'

def read_config
  config_file = ['~/.gitcalrc', './config.yml'].select{|s|File.exists?(s)}.first
  File.open(config_file, 'r') do |f|
    @config = YAML.load(f.read)
  end
end

read_config

path = Pathname.new(@config['local_repos_dir']).join('**/.git').expand_path
@repos = []
Dir.glob(path.to_s) do |s|
  @repos << Grit::Repo.new(Pathname.new(s).parent.to_s)
end

day = Time.parse(ARGV[0])
@commits = []
@repos.each do |r|
  @commits += r.log('master', nil, :since => day, :until => day+24*3600)
end

@commits.each do |c|
  puts "%s\n%s\n\n" % [c.author_string, c.message]
end
