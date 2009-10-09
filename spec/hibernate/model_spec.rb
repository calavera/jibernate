require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../fixtures/classes'

describe "Hibernate::Model" do
  
  it "creates the mapping file without attributes" do
    xml = MockModel2.hibernate_mapping_xml

    xml.should =~ /\<class name="MockModel2" table="MOCKMODEL2"\>/
    xml.should =~ /\<id name="id" column="MOCKMODEL2_ID"\>/
  end

  it "creates the mapping file with attributes" do 
    xml = MockModel.hibernate_mapping_xml

    xml.should =~ /\<class name="MockModel" table="MOCKMODEL"\>/
    xml.should =~ /\<id name="id" column="MOCKMODEL_ID"\>/
    xml.should =~ /\<property name="title"  \/\>/
    xml.should =~ /\<property name="created" type="timestamp" \/\>/
  end
end
