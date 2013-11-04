require 'axiom'
require 'mongo'

module Axiom
  module Adapter
    # An adapter for mongodb
    class Mongo
      # Error raised when query on unsupported algebra is created
      class UnsupportedAlgebraError < StandardError; end

      include Adamantium::Flat

      singleton_class.class_eval{ attr_accessor :available_modules }

      self.available_modules = [
              Relation::Operation::Order,
              Relation::Operation::Offset,
              Relation::Operation::Limit,
              Relation::Operation::Insertion,
              Relation::Operation::Deletion,
              Algebra::Restriction          
      ]
      # Return mongo connection
      #
      # @return [::Mongo::DB]
      #
      # @api private
      #
      attr_reader :database
      # Execute relation in base
      #
      # @param [Relation] relation
      #
      # @return [undefined]
      #
      # @api public
      #
      def execute(relation, &block)
        query = Query.new(@database, relation)
        return to_enum(__method__, relation) if !block_given? and query.visitor.method_name == :find
        query.tap{|query| query.execute}.each(&block)
      end
 
      # Read tuples from relation
      #
      # @param [Relation] relation
      #   the relation to read from
      #
      # @return [self]
      #   returns self when block given
      #
      # @return [Enumerable<Array>]
      #   returns enumerable when no block given
      #
      # @api private
      #

    private

      # Initialize mongo adapter
      #
      # @param [Mongo::DB] database
      #
      # @return [undefined]
      #
      # @api private
      #
      def initialize(database)
        @database = database
      end

    end #class Mongo
  end #module Adapter
end #module Axiom

require 'axiom/adapter/mongo/generator'
require 'axiom/adapter/mongo/generator/base'
require 'axiom/adapter/mongo/generator/insertion'
require 'axiom/adapter/mongo/generator/deletion'
require 'axiom/adapter/mongo/generator/restriction'
require 'axiom/adapter/mongo/generator/offset'
require 'axiom/adapter/mongo/generator/order'
require 'axiom/adapter/mongo/generator/limit'
require 'axiom/adapter/mongo/operations'
require 'axiom/adapter/mongo/visitor'
require 'axiom/adapter/mongo/function'
require 'axiom/adapter/mongo/literal'
require 'axiom/adapter/mongo/gateway'
require 'axiom/adapter/mongo/query'
