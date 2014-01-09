class SwitchPygmentsToAce < ActiveRecord::Migration
  def up
    SingleFile.where(lexer_type: 'pygments').update_all ['lexer_type=?', 'ace']
  end

  def down
    SingleFile.where(lexer_type: 'ace').update_all ['lexer_type=?', 'pygments']
  end
end
