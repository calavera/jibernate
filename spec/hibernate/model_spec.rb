require File.dirname(__FILE__) + '/../spec_helper'

class MockModel
  include Hibernate::Model
  hibernate_attr :title => :string, :created => :date
  hibernate!
  
  def name; self.class.name; end
end

describe "Hibernate::Model" do
  
  it "creates the mapping file with attributes in several lines" do
    
    mock = MockModel.new
    
    xml = mock.hibernate_mapping_xml
    xml.should == %{<?xml version="1.0"?>
<!DOCTYPE hibernate-mapping PUBLIC
  "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
  "http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd">

<hibernate-mapping package="ruby">
<class name="MockModel" table="MOCK_MODEL">
  <id name="id" column="MOCK_MODEL_ID">
      <generator class="native"/>
  </id>
  
  <property name="title" />
  <property name="created" type="timestamp" />
</class>
</hibernate-mapping>}
  end
end