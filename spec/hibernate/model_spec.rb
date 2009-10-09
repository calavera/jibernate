require File.dirname(__FILE__) + '/../spec_helper'

class MockModel
  include Hibernate::Model
  hibernate_attr :title => :string, :created => :date
  hibernate!
end

describe "Hibernate::Model" do
  
  it "creates the mapping file with attributes in several lines" do 
    xml = MockModel.hibernate_mapping_xml

    xml.gsub(/\s{2,}/, '').should == %{<?xml version="1.0"?>
<!DOCTYPE hibernate-mapping PUBLIC
  "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
  "http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd">

<hibernate-mapping package="ruby">
<class name="MockModel" table="MOCKMODEL">
  <id name="id" column="MOCKMODEL_ID">
      <generator class="native"/>
  </id>

  <property name="title"  />
  <property name="created" type="timestamp" />
</class>
</hibernate-mapping>
}.gsub(/\s{2,}/, '')
  end
end
