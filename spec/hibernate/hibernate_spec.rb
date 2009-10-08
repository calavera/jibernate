require File.dirname(__FILE__) + '/../spec_helper'

describe "Hibernate" do
  it "declares hibernate configuration methods" do
    Hibernate::CONFIGURATION_OPTIONS.each do |key, value|
      key_for_method_name = key + (key.empty? ? '' : '_')
      
      if value.respond_to?(:each)
        value.each do |option|
          Hibernate.respond_to?("#{key_for_method_name}#{option}=").should == true
        end
      end
    end
  end
end