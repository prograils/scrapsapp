class SingleFile < ActiveRecord::Base
  # @TODO: I really don't like it...
  def self.lexer_options
    @@files ||= Dir.entries(Rails.root.join('vendor', 'assets', 'javascripts', 'ace'))
    @@lexers ||= @@files.select{|f| f=~/mode-/}.map do |f|
      f.split('-').last.split('.').first
    end
    @@lexers
  end

  ## SCOPES
  scope :ordered, ->{ order("#{SingleFile.quoted_table_name}.id ASC") }

  ## ASSOCIATIONS
  belongs_to :scrap

  ## VALIDATED
  validates :name,
            :presence=>true
  validates :lexer,
            :inclusion=>{:in=>SingleFile.lexer_options}

  ## BEFORE & AFTER
  before_save :split_name
  before_save :set_lexer



  private
    def split_name
      self.directory, self.file_name = File.split(self.name)
    end

    def set_lexer
      ext = File.extname(self.file_name)
      mime = MIME::Types.type_for(self.file_name).first
      # dirty, mime for soeme reason does not recognize md
      if (mime && mime.simplified =~ /text\//) || ext.to_s=='.md'
        if ext.to_s=='.md' || self.lexer == 'markdown'
          self.lexer = 'markdown'
          self.lexer_type = 'redcarpet'
        else
          self.lexer_type = 'ace'
        end
      else
        self.lexer = nil
        self.lexer_type = nil
      end
    end

end
