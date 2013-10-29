require 'spec_helper'
require 'logger'

# if ENV['TRAVIS'] or ENV['HAS_MONGO']
  describe Adapter::Mongo, 'read' do
    let(:uri)           { ENV.fetch('MONGO_URI', '127.0.0.1')                                    }
    let(:logger)        { Logger.new($stdout)                                                    }
            
    let(:adapter)       { Adapter::Mongo.new(database)                                           }
    let(:base_relation) { Relation::Base.new('people', [[:firstname,String],[:lastname,String]]) }

    let(:connection)    { Mongo::Connection.new(uri)                                             }
                                                                                    
    let(:relation)      { Adapter::Mongo::Gateway.new(adapter, base_relation)                    }
    let(:database)      { connection.db('test')                                                  }
    let(:collection)    { database.collection('people')                                          }
    before :all do
      collection.insert(:firstname => 'John', :lastname => 'Doe')
      collection.insert(:firstname => 'Sue', :lastname => 'Doe')
      collection.insert(:firstname => 'Tray', :lastname => 'Doe')
    end

    after :all do
      collection.remove
    end

    specify 'it allows to receive all records' do
      data = relation.to_ary
      data.should == [
        [ 'John', 'Doe' ],
        [ 'Sue', 'Doe' ],
        [ 'Tray', 'Doe' ]
      ]
      # collection.skip(1)
    end

    specify 'it allows to receive specific records' do
      data = relation.restrict { |r| r.firstname.eq('John') }.to_ary
      data.should == [ [ 'John', 'Doe' ] ]
    end

    specify 'it allows to sort records' do
      data = relation.sort.to_ary
      data.should == [
        [ 'John', 'Doe' ],
        [ 'Sue', 'Doe' ],
        [ 'Tray', 'Doe' ]
      ]
    end

    specify 'it allows to offset records' do
      data = relation.sort.drop(2).to_ary
      data.should == [ [ 'Tray', 'Doe' ] ]
    end

    specify 'it allows to limit records' do
      data = relation.sort.take(1).to_ary
      data.should == [ [ 'John', 'Doe' ] ]
    end

  end
# end
