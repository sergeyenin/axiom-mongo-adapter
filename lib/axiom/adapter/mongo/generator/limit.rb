module Axiom
  module Adapter
    class Mongo
      class Generator
        # A Generator for Axiom::Relation::Operation::Limit relations
        class Limit < Generator

          # Initialize Limit instance
          #
          # @return [undefined]
          #
          # @api public
          #
          def initialize
            @method_name = :find  
          end

          private

          # Return valid mongo hash
          #
          # @return [Hash]
          #
          # @api private
          #
          def get_mongo_hash
            predicate
          end

          # Initialize operands attributes
          #
          # @return [undefined]
          #
          # @api private
          #
          def set_operands(limit)
            @operand = limit.operand
          end

          # Interface for set_predicate method
          #
          # @param [Relation] relation
          #
          # @return [undefined]
          #
          # @api protected
          #
          def set_predicate(limit)
            @predicate =  Literal.positive_integer(limit.limit)
          end

          # Initialize name attribute
          #
          # @return [undefined]
          #
          # @api private
          #
          def set_name
            @name = @operand.operand.name
          end

          def set_variable_name
            @variable_name = "@limit"
          end

        end #Limit
      end #Generator
    end #Mongo
  end #Adapter
end #Axiom