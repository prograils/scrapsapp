require 'spec_helper'

describe SingleFile do
  it { should belong_to(:scrap) }
  it { should validate_presence_of(:name) }
  #it { should validate_presence_of(:lexer) }

  context "[lexer]" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @scrap = FactoryGirl.create(:scrap, :user=>@user, :organization=>@user.private_organization)
    end
    it "should correctly define lexer for popular file types" do
      #puts Pygments::Lexer.all.select{|y| !(y.filenames.empty?)}.map{|x|[x.name]}
      {:rb=>"Ruby", :py=>"Python"}.each do |k,v|
        sf = FactoryGirl.create(:single_file, :name=>"test.#{k}", :scrap=>@scrap)
        sf.lexer.should == k
      end
    end

    it "should recognize txt file" do
      sf = FactoryGirl.build(:single_file, :name=>"config/initializer/test.txt", :scrap=>@scrap)
      sf.save!
      sf.lexer.should == "txt"
    end

    it "should recognize md file" do
      sf = FactoryGirl.create(:single_file, :name=>"config/initializer/test.md", :scrap=>@scrap)
      sf.lexer.should == "Markdown"
      sf.lexer_type.should == 'redcarpet'
    end

    it "should not recognize png, zip, gz, exe file" do
      %w( png zip gz tar exe).each do |ext|
        sf = FactoryGirl.create(:single_file, :name=>"config/initializer/test.#{ext}", :scrap=>@scrap)
        sf.lexer.should be_nil
      end
    end

    it "should correctly strip name into directory name and file name" do
      sf = FactoryGirl.create(:single_file, :name=>"config/initializer/test.rb", :scrap=>@scrap)
      sf.file_name.should == "test.rb"
      sf.directory.should == "config/initializer"
    end

    
  end
end
