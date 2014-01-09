module ScrapsHelper
  def get_scrap_path(org, scrap)
    if current_user and current_user.member_of?(org) and scrap.folder_id.present?
      [org, scrap.folder, scrap]
    else
      [org, scrap]
    end
  end

  def get_lexer_options
    SingleFile.lexer_options
  end
end
