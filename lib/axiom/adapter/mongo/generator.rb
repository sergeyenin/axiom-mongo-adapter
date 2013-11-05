module Axiom
  module Adapter
    class Mongo
       # basic interface generators
      class Generator

        # Return the relation's header
        #
        # @return [Object]
        #
        # @api private
        #
        attr_reader :header

        # Return the collection(table) name
        #
        # @return [String]
        #
        # @api private
        #
        attr_reader :name

        # Return a mondo driver method for executing
        #
        # @return [Symbol]
        #
        # @api private
        #
        attr_reader :method_name

        attr_reader :variable_name

        # Return the axiom relation's predicate(in hash form for mongo)
        #
        # @return [Hash]
        #
        # @api private
        #
        attr_reader :predicate

        # Return a axiom relation's fields
        #
        # @return [Array<Symbol>]
        #
        # @api private
        #
        attr_reader :fields

        # Return a axiom relation's operand
        #
        # @return [Relation]
        #
        # @api private
        #
        attr_reader :operand

        # Visit a relation
        #
        # @param [Relation] relation
        #
        # @return [self]
        #
        # @api public
        #         
        def visit(relation)
          @header = relation.header
          set_operands relation
          set_predicate relation
          set_fields relation
          set_name
          set_variable_name
          self
        end

        # Return valid mongo hash
        #
        # @return [Hash]
        #
        # @api public
        #
        def to_hash
          get_mongo_hash
        end

        protected
        # Initialize fields attribute
        #
        # @param [Relation] relation
        #
        # @return [Array<Symbol>]
        #
        # @api protected
        #
        def set_fields(relation)
          @fields = relation.header.map(&:name)
        end

        # Interface for get_mongo_hash method
        #
        # @return [Hash]
        #
        # @api protected
        #
        def get_mongo_hash; predicate; end

        # Interface for set_operands method
        #
        # @param [Relation] relation
        #
        # @return [undefined]
        #
        # @api protected
        #
        def set_operands(relation); end

        # Interface for set_predicate method
        #
        # @param [Relation] relation
        #
        # @return [undefined]
        #
        # @api protected
        #
        def set_predicate(relation); end

        # Initialize name attribute
        #
        # @return [undefined]
        #
        # @api protected
        #
        def set_name
          @name = @operand.respond_to?(:name) ? @operand.name : ""
        end

        def set_variable_name
          @variable_name = "@query"
        end

      end #Generator
    end #Mongo
  end #Adapter
end #Axiom