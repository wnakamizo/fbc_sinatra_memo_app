# frozen_string_literal: true

require 'pg'

module MemoRepository
  def self.connection
    @connection ||= PG.connect(dbname: 'memos')
  end

  def self.load_memos
    connection.exec('SELECT * FROM memos ORDER BY id')
  end

  def self.find(id)
    connection.exec_params('SELECT * FROM memos WHERE id = $1', [id])
  end

  def self.create(memo_params)
    result = connection.exec_params(
      'INSERT INTO memos (title, description) VALUES ($1, $2) RETURNING id',
      [memo_params[:title], memo_params[:description]]
    )
    result[0]['id']
  end

  def self.edit(id, memo_params)
    result = connection.exec_params(
      'UPDATE memos SET title = $1, description = $2 WHERE id = $3',
      [memo_params[:title], memo_params[:description], id]
    )
    result.cmd_tuples.positive?
  end

  def self.delete(id)
    connection.exec_params('DELETE FROM memos WHERE id = $1', [id])
  end
end
