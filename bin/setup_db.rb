#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pg'

conn = PG.connect(dbname: 'template1')
conn.exec('CREATE DATABASE memos')
conn.close

conn = PG.connect(dbname: 'memos')
conn.exec(<<~SQL)
  CREATE TABLE memos (
    id UUID PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT
  )
SQL
conn.close

puts 'Setup complete!'
