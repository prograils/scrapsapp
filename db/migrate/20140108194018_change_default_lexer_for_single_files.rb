class ChangeDefaultLexerForSingleFiles < ActiveRecord::Migration
  def up
    change_column_default(:single_files, :lexer, 'plain_text')
    SingleFile.where('lexer is null').update_all ['lexer = ?', 'plain_text']
  end

  def down
    change_column_default(:single_files, :lexer, nil)
  end
end
