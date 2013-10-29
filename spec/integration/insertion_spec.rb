require 'spec_helper'
require 'integration_spec_helper'
require 'logger'

RSpec.configure { |c| c.extend IntegrationSpecHelper }

# if ENV['TRAVIS'] or ENV['HAS_MONGO']
  describe Adapter::Mongo, 'insert' do

    around(:each) do |ex|
      collection.remove
      ex.run
      collection.remove
    end

    specify 'it allows to insert new records to empty relation' do
      relation.insert([[ 'John', 'Doe' ],[ 'Sue', 'Doe' ]])
      relation.sort.to_ary.should == [       
        [ 'John', 'Doe' ],
        [ 'Sue', 'Doe' ]
      ]
    end

    specify 'it allows to insert new record to existing relation' do
      relation.insert([[ 'John', 'Doe' ],[ 'Sue', 'Doe' ]])
      relation.insert([[ 'Tray', 'Doe' ]])
      relation.sort.to_ary.should == [
        [ 'John', 'Doe' ],
        [ 'Sue', 'Doe' ],
        [ 'Tray', 'Doe' ]
      ]
    end

  end
# end