class SingleFile < ActiveRecord::Base

  ## ASSOCIATIONS
  belongs_to :scrap

  ## VALIDATED
  validates :name, 
            :presence=>true
  #validates :lexer,
            #:inclusion=>{:in=>[""]|Pygments::Lexer.all.select{|y| !(y.filenames.empty?)}.map{|x|[x.name]}}
  ## ACCESSIBLE
  attr_accessible :content, :directory, :lexer

  ## BEFORE & AFTER
  before_save :split_name
  before_save :set_lexer


  private
    def split_name
      self.directory, self.file_name = File.split(self.name)
    end

    def set_lexer
      if not self.lexer_changed? or self.lexer.blank?
        ext = File.extname(self.file_name)
        if ext.to_s=='.md'
          self.lexer = 'Markdown'
          self.lexer_type = 'redcarpet'
        else
          lx = Pygments::Lexer.find_by_extname(ext)
          if lx.present?
            self.lexer = lx.name
            self.lexer_type = 'pygments.rb'
          end
        end
      end
      true
    end

end
