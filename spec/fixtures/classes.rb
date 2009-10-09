class MockModel
  include Hibernate::Model
  hibernate_attr :title => :string, :created => :date
  hibernate!
end

class MockModel2
  include Hibernate::Model
  hibernate!
end

class Parent
  include Hibernate::Model
  hibernate_attr :fullname => :string
#  hibernate_has_many :children => '::Child'
  hibernate!
end

class Child
  include Hibernate::Model
  hibernate_attr :fullname => :string
#  hibernate_belongs_to :parent => '::Parent'
  hibernate!
end
