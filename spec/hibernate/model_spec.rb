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
    xml.gsub(/\s{2,}/, '').should == %{<?xml version="1.0"?>
<!DOCTYPE hibernate-mapping PUBLIC
  "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
  "http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd">

<hibernate-mapping package="ruby">
<class name="MockModel" table="MOCKMODEL">
  <id name="id" column="MOCKMODEL_ID">
      <generator class="native"/>
  </id>

</class>
</hibernate-mapping>
}.gsub(/\s{2,}/, '')
  end
end
