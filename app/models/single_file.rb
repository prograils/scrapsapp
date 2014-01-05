require 'tempfile'
class SingleFile < ActiveRecord::Base

  ## SCOPES
  scope :ordered, ->{ order("#{SingleFile.quoted_table_name}.id ASC") }

  ## ASSOCIATIONS
  belongs_to :scrap

  ## VALIDATED
  validates :name,
            :presence=>true
  #validates :lexer,
            #:inclusion=>{:in=>[""]|Pygments::Lexer.all.select{|y| !(y.filenames.empty?)}.map{|x|[x.name]}}

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
            self.lexer = lx.aliases.first
          else
            self.lexer = 'plain_text'
          end
          self.lexer_type = 'ace'
        end
        #if self.lexer.blank?
          #logger.info "yeah, blank lexer!!"
          #mime = MimeMagic.by_magic(self.content) || MimeMagic.by_path(self.file_name)
          #logger.info "mime: #{mime}"
          #file = Tempfile.new('scrapsapp')
          #file.write self.content
          #file.close
          #unless File.binary?(file.path)
            #self.lexer = 'text'
            #self.lexer_type = 'pygments'
          #end
          #file.unlink
        #end
      end
      true
    end

end
