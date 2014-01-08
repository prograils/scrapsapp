module ScrapsHelper
  def get_scrap_path(org, scrap)
    if current_user and current_user.member_of?(org) and scrap.folder_id.present?
      [org, scrap.folder, scrap]
    else
      [org, scrap]
    end
  end

  def get_lexer_options
    @@files ||= Dir.entries(Rails.root.join('vendor', 'assets', 'javascripts', 'ace'))
    @@lexers ||= @@files.select{|f| f=~/mode-/}.map do |f|
      f.split('-').last.split('.').first
    end
    @@lexers
  end
end
