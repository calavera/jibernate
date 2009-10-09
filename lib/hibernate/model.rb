require 'erubis'

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
      @hibernate_attrs.merge(default_hibernate_attrs).each do |name, type|
        define_accessors(name, type)
      end
    end

    def hibernate_has_many(attrs)
      @hibernate_has_many_attrs = attrs
      @hibernate_has_many_attrs.each do |name, type|
        define_accessors(name, type)
      end
    end

    def hibernate_belongs_to(attrs)
      @hibernate_belongs_to_attrs = attrs
      @hibernate_belongs_to_attrs.each do |name, type|
        define_accessors(name, type)
      end
    end

    def hibernate!
      unless @hibernate_attrs
        default_hibernate_attrs.each {|name, type| define_accessors(name, type)}
        @hibernate_attrs = {}
      end 

      @java_class = become_java!(".")
      Hibernate.add_xml(hibernate_mapping_xml)
      @java_class
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
      @mapping_xml ||= begin
        template = Erubis::Eruby.load_file(File.dirname(__FILE__) + '/hibernate_mapping.xml.erb')

        template.evaluate({
          :name => name,
          :hibernate_attrs => Hash[@hibernate_attrs.map {|k, v| [k, hibernate_type_attr(v)]}],
          :hibernate_has_many_attrs => @hibernate_has_many_attrs,
          :hibernate_belongs_to_attrs => @hibernate_belongs_to_attrs
        })
      end
    end

    private
    def default_hibernate_attrs
      {:id => :long}
    end

    def define_accessors(name, type, get_name = nil, set_name = nil)
      attr_accessor name
      get_name ||= "get#{name.to_s.capitalize}"
      set_name ||= "set#{name.to_s.capitalize}"

      java_type = type_to_java(type)

      alias_method get_name.intern, name
      add_method_signature get_name, [java_type]
      alias_method set_name.intern, :"#{name.to_s}="
      add_method_signature set_name, [JVoid, java_type]
    end

    def type_to_java(type)
      if TYPES.include?(type)
        TYPES[type].java_class
      else
        # FIXME: eval defined classes?
      end
    end
  end
end
