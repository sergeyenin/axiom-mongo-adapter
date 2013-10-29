module IntegrationSpecHelper
  
  def self.extended(base)
    base.init_base
  end

  def init_base
    let(:uri)           { ENV.fetch('MONGO_URI', '127.0.0.1')                                    }
    let(:logger)        { Logger.new($stdout)                                                    }
            
    let(:adapter)       { Adapter::Mongo.new(database)                                           }
    let(:base_relation) { Relation::Base.new('people', [[:firstname,String],[:lastname,String]]) }

    let(:connection)    { Mongo::Connection.new(uri)                                             }
                                                                                    
    let(:relation)      { Adapter::Mongo::Gateway.new(adapter, base_relation)                    }
    let(:database)      { connection.db('test')                                                  }
    let(:collection)    { database.collection('people')                                          }
  end

end                                          