require 'erb'

module Hibernate
  module Model
    TYPES = {
      :string => java.lang.String,
      :long => java.lang.Long,
      :date => java.util.Date
    }

    def self.append_features(base)
      super
      base.extend self
    end

    def hibernate_attr(attrs)
      @hibernate_attrs = attrs
      @hibernate_attrs.merge(:id => :long).each do |name, type|
        attr_accessor name
        get_name = "get#{name.to_s.capitalize}"
        set_name = "set#{name.to_s.capitalize}"

        alias_method get_name.intern, name
        add_method_signature get_name, [TYPES[type].java_class]
        alias_method set_name.intern, :"#{name.to_s}="
        add_method_signature set_name, [JVoid, TYPES[type].java_class]
      end
    end

    def hibernate!
      become_java!(".")
      Hibernate.add_xml(hibernate_mapping_xml)
    end

    def hibernate_type_attr(type)
      case type
      when :date
        'type="timestamp"'
      else
        ''
      end
    end

    def hibernate_mapping_xml
      template = ERB.new %{<?xml version="1.0"?>
<!DOCTYPE hibernate-mapping PUBLIC
        "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
        "http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd">
<hibernate-mapping package="ruby">
    <class name="<%= name %>" table="<%= name.upcase %>">
        <id name="id" column="<%= name.upcase %>_ID">
            <generator class="native"/>
        </id>
        <% @hibernate_attrs.each do |n, typ| %>
        <property name="<%= n %>" <%= hibernate_type_attr(typ) %> />
        <% end %>
    </class>
</hibernate-mapping>
}
      xml = template.result(binding)
#       puts xml
      xml
    end
  end
end
