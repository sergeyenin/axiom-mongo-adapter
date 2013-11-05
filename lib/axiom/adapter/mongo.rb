require 'axiom'
require 'mongo'
require 'axiom/adapter/mongo/support/definition'
module Axiom
  module Adapter
    # An adapter for mongodb
    class Mongo
      # Error raised when query on unsupported algebra is created
      class UnsupportedAlgebraError < StandardError; end

      include Adamantium::Flat

      singleton_class.class_eval{ attr_accessor :available_modules }
      self.available_modules = {}

      def self.define_modules
        yield
      end

      def self.axiom_module(module_name, &block)
        self.available_modules = self.available_modules.merge({ module_name => Definition.new.call(&block).to_hash })
      end


      define_modules do
        
        #define Relation::Operation::Order
        axiom_module Relation::Operation::Order do 
          variable_name :sort

          code_to_generate do |order|
            Literal.sort(order.directions)
          end
        end
        
        #define Relation::Operation::Offset
        axiom_module Relation::Operation::Offset do 
          variable_name :skip

          code_to_generate do |offset|
            Literal.positive_integer(offset.offset)
          end

          get_name do |operand|
            operand.operand.name
          end
        end
        
        #define Relation::Operation::Limit
        axiom_module Relation::Operation::Limit do 
          variable_name :limit

          code_to_generate do |limit|
            Literal.positive_integer(limit.limit)
          end

          get_name do |operand|
            operand.operand.name
          end
        end
        
        #define Relation::Operation::Insertion
        axiom_module Relation::Operation::Insertion do 
          method_name :insert
          binary :true

          code_to_generate do |insertion|
            insertion.right.to_a.inject([]) {|res, tuple| res << Hash[tuple.data.map { |attribute, value| [attribute.name, value] }]}
          end

        end
        
        #define Relation::Operation::Deletion
        axiom_module Relation::Operation::Deletion do 
          method_name :remove
          binary :true

          code_to_generate do |deletion|
            deletion.right.to_a.map{|tuple| Hash[tuple.data.map { |attribute, value| [attribute.name, value] }]}.first
          end

        end
        
        #define Algebra::Restriction
        axiom_module Algebra::Restriction do 
          code_to_generate do |restriction|
            Function.function(restriction.predicate)
          end

        end

      end

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
require 'axiom/adapter/mongo/operations'
require 'axiom/adapter/mongo/visitor'
require 'axiom/adapter/mongo/function'
require 'axiom/adapter/mongo/literal'
require 'axiom/adapter/mongo/gateway'
require 'axiom/adapter/mongo/query'
