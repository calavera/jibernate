# Basic requires
require 'rubygems'
require 'jdbc/hsqldb'

# Our requires
require 'hibernate'

Hibernate.dialect = Hibernate::Dialects::HSQL
Hibernate.current_session_context_class = "thread"
Hibernate.connection_driver_class = "org.hsqldb.jdbcDriver"
Hibernate.connection_url = "jdbc:hsqldb:file:jibernate"
Hibernate.connection_username = "sa"
Hibernate.connection_password = ""
Hibernate.properties["hbm2ddl.auto"] = "update"

class Event
  extend Hibernate::Model
  hibernate_attr :title => :string, :created => :date
  hibernate!
end

Hibernate.tx do |session|
  # Hack for HSQLDB's write delay
  session.createSQLQuery("SET WRITE_DELAY FALSE").execute_update

  case ARGV[0]
  when /store/
    # Create event and store it
    event = Event.new
    event.title = ARGV[1]
    event.created = java.util.Date.new
    session.save(event)
    puts "Stored!"
  when /list/
    # List all events
    list = session.create_query('from Event').list
    puts "Listing all events:"
    list.each do |evt|
      puts <<EOS
  id: #{evt.id}
    title: #{evt.title}
    created: #{evt.created}"
EOS
    end
  else
    puts "Usage:\n\tstore <title>\n\tlist"
  end
end
