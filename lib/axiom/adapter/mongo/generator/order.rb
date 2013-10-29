module Axiom
  module Adapter
    class Mongo
      class Generator
        # A Generator for Axiom::Relation::Operation::Order relations
        class Order < Generator

          # Initialize Order instance
          #
          # @return [undefined]
          #
          # @api public
          #
          def initialize
            @method_name = :sort  
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
          def set_operands(order)
            @operand = order.operand
          end

          # Interface for set_predicate method
          #
          # @param [Relation] relation
          #
          # @return [undefined]
          #
          # @api protected
          #
          def set_predicate(order)
            @predicate =  Literal.sort(order.directions)
          end

          # Initialize name attribute
          #
          # @return [undefined]
          #
          # @api private
          #
          def set_name
            @name = @operand.name
          end

        end #Order
      end #Generator
    end #Mongo
  end #Adapter
end #Axiom