module Axiom
  module Adapter
    class Mongo
      class Generator
        # A Generator for Axiom::Relation::Operation::Offset relations 
        class Offset < Generator

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
          def set_operands(offset)
            @operand = offset.operand
          end

          # Interface for set_predicate method
          #
          # @param [Relation] relation
          #
          # @return [undefined]
          #
          # @api protected
          #
          def set_predicate(offset)
            @predicate =  Literal.positive_integer(offset.offset)
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
            @variable_name = "@skip"
          end

        end #Offset
      end #Generator
    end #Mongo
  end #Adapter
end #Axiom