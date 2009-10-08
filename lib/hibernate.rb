$:.unshift(File.dirname(__FILE__) + '/../jibernate-libs') unless
  $:.include?(File.dirname(__FILE__) + '/../jibernate-libs') || 
  $:.include?(File.expand_path(File.dirname(__FILE__) + '/../jibernate-libs'))
$: << File.dirname(__FILE__)

require 'java'
require 'jruby/core_ext'

require 'stringio'
require 'hibernate/jars'
require 'hibernate/dialects'
require 'hibernate/model'
require 'hibernate/property_shim'

module Hibernate
  import org.hibernate.cfg.Configuration
  import javax.xml.parsers.DocumentBuilderFactory
  import org.xml.sax.InputSource
  JClass = java.lang.Class
  JVoid = java.lang.Void::TYPE
  DOCUMENT_BUILDER_FACTORY = DocumentBuilderFactory.new_instance
  DOCUMENT_BUILDER_FACTORY.validating = false
  DOCUMENT_BUILDER_FACTORY.expand_entity_references = false
  DOCUMENT_BUILDER = DOCUMENT_BUILDER_FACTORY.new_document_builder
  
  CONFIGURATION_OPTIONS = {
    '' => [:dialect, :current_session_context_class],
    'connection' => [:driver_class, :url, :username, :password]
  }
  
  CONFIGURATION_OPTIONS.each do |key, value|
    key_for_method_name = key + (key.empty? ? '' : '_')
    key_for_property_name = key + (key.empty? ? '' : '.')
  
    if value.respond_to?(:each)
      value.each do |option|
        define_method("#{key_for_method_name}#{option}=") do |variable|
          config.set_property "hibernate.#{key_for_property_name}#{option}", variable
        end
        module_function "#{key_for_method_name}#{option}="
      end
    else
      define_method("#{key_for_method_name}#{value}=") do |variable|
        config.set_property "hibernate.#{key_for_property_name}#{value}", variable
      end
      module_function "#{key_for_method_name}#{value}="
    end
  end

  def self.properties
    PropertyShim.new(config)
  end

  def self.tx
    session.begin_transaction
    if block_given?
      yield session
      session.transaction.commit
    end
  end

  def self.factory
    @factory ||= config.build_session_factory
  end

  def self.session
    factory.current_session
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.add_model(mapping)
    config.add_xml(File.read(mapping))
  end

  def self.add_xml(xml)
    config.add_xml(xml)
  end
end
