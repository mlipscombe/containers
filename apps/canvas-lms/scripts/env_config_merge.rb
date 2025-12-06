#!/usr/bin/env ruby

require 'yaml'
require 'json'

APP_HOME = ENV['APP_HOME'] || '/usr/src/app/'
CONFIG_DIR = File.join(APP_HOME, 'config')
RAILS_ENV = ENV['RAILS_ENV'] || 'production'

# Collect overrides grouped by config file and YAML path
# Structure: { "outgoing_mail" => { ["multiple_inboxes", "reply_to_addresses"] => value } }
overrides = Hash.new { |h, k| h[k] = {} }
indexed_overrides = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = {} } }
scalar_present = Hash.new { |h, k| h[k] = {} }

ENV.each do |env_key, raw_value|
  next unless env_key.start_with?('CANVAS_')

  body = env_key.sub(/^CANVAS_/, '')
  parts = body.split('__')
  next if parts.empty?

  config_name = parts.shift.downcase
  next if config_name.empty?

  # No remaining parts means we don't know where to put this, skip
  next if parts.empty?

  # Detect indexed form: last token is digits only
  if parts.last.match?(/^[0-9]+$/)
    index = parts.pop.to_i
    path = parts.map { |p| p.downcase }
    # If the first segment matches the current RAILS_ENV, drop it to avoid
    # double-nesting (e.g., production.production.*)
    path.shift if !path.empty? && path.first == RAILS_ENV.downcase
    path_key = path.join('.')

    # Skip indexed form if we already have a scalar/json override for this path
    next if scalar_present[[config_name, path_key]]

    indexed_overrides[config_name][path_key][index] = raw_value
  else
    path = parts.map { |p| p.downcase }
    # If the first segment matches the current RAILS_ENV, drop it to avoid
    # double-nesting under the environment key
    path.shift if !path.empty? && path.first == RAILS_ENV.downcase
    path_key = path.join('.')

    # Mark that a scalar/json override exists for this path
    scalar_present[[config_name, path_key]] = true

    value = begin
      parsed = JSON.parse(raw_value)
      parsed
    rescue JSON::ParserError, TypeError
      # Simple type casting: booleans and numbers, otherwise string
      case raw_value
      when 'true' then true
      when 'false' then false
      else
        if raw_value.match?(/\A-?[0-9]+\z/)
          raw_value.to_i
        elsif raw_value.match?(/\A-?[0-9]+\.[0-9]+\z/)
          raw_value.to_f
        else
          raw_value
        end
      end
    end

    overrides[config_name][path] = value
  end
end

# Convert indexed overrides into arrays, respecting scalar precedence
indexed_overrides.each do |config_name, paths|
  paths.each do |path_key, index_hash|
    path = path_key.split('.')
    # If a scalar override exists for this path, skip the indexed values
    next if overrides[config_name].key?(path)

    max_index = index_hash.keys.max
    next if max_index.nil?

    arr = Array.new(max_index + 1)
    index_hash.each do |idx, v|
      arr[idx] = v
    end

    overrides[config_name][path] = arr
  end
end

# Apply overrides to YAML files

overrides.each do |config_name, paths|
  file_path = File.join(CONFIG_DIR, "#{config_name}.yml")
  next unless File.file?(file_path)

  data = YAML.load_file(file_path, aliases: true)
  data = {} if data.nil?

  env_root = (data[RAILS_ENV] ||= {})

  paths.each do |path, value|
    current = env_root
    # Walk/create nested hashes up to the parent of the final key
    path[0..-2].each do |key|
      key = key.to_s
      current[key] = {} unless current[key].is_a?(Hash)
      current = current[key]
    end

    leaf_key = path.last.to_s
    # Replace the entire value at this leaf
    current[leaf_key] = value
  end

  File.write(file_path, YAML.dump(data))
end
