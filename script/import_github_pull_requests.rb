#!/usr/bin/env ruby

OSSISTANT_DIR=File.expand_path('../..', __FILE__)
$:.unshift("#{OSSISTANT_DIR}/lib")

ENV['RACK_ENV'] ||= 'development'

require 'ossistant'
require 'optparse'

options = {}

opt_parser = OptionParser.new do |opts|

  opts.on('-i', '--interface INTERFACE') do |interface|
    options[:interface] = interface
  end
end

opt_parser.parse!

unless options[:interface]
  puts opt_parser
  exit 1
end

Ossistant.setup_env

rules = Ossistant.config.rules.all_of_type(Ossistant::Rules::PullRequestToTrello)
interface = Ossistant.config.interfaces.find(options[:interface])

rules.each do |rule|
  next unless rule['repos'].any?
  rule['repos'].each do |repo_name|
    unless repo_name.include?('/')
      warn "#{repo_name} is not a full name of a repo: skipping..."
      next
    end

    Ossistant.persisted_bus.trigger(Ossistant::Importers::PullRequestsFromRepo,
                                    interface,
                                    repo_name)
  end
end
