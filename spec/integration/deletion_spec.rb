require 'spec_helper'
require 'integration_spec_helper'
require 'logger'

RSpec.configure { |c| c.extend IntegrationSpecHelper }

# if ENV['TRAVIS'] or ENV['HAS_MONGO']
  describe Adapter::Mongo, 'delete' do

    around(:each) do |ex|
      collection.insert(:firstname => 'John', :lastname => 'Doe')
      collection.insert(:firstname => 'Sue', :lastname => 'Doe')
      collection.insert(:firstname => 'Tray', :lastname => 'Doe')
      ex.run
      collection.remove
    end

    specify 'it allows to delete single records from relation' do
      relation_to_remove = relation.restrict{|r| r.firstname.eq('Sue')}
      relation.delete(relation_to_remove)
      relation.to_ary.should == [       
        [ 'John', 'Doe' ],
        [ 'Tray', 'Doe' ]
      ]
    end

    # specify 'it allows to insert new record to existing relation' do
    #   collection.remove
    #   relation.insert([[ 'John', 'Doe' ],[ 'Sue', 'Doe' ]])
    #   relation.insert([[ 'Tray', 'Doe' ]])
    #   relation.to_ary.should == [
    #     [ 'John', 'Doe' ],
    #     [ 'Sue', 'Doe' ],
    #     [ 'Tray', 'Doe' ]
    #   ]
    # end

  end
# end