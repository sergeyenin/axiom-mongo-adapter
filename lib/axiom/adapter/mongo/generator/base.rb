module Axiom
  module Adapter
    class Mongo
      class Generator
        # A Generator for Axiom::Relation::Base relations
        class Base < Generator

          # Initialize Base instance
          #
          # @return [undefined]
          #
          # @api public
          #
          def initialize
            @method_name = :find  
          end

          private

          # Initialize operands attributes
          #
          # @return [undefined]
          #
          # @api private
          #
          def set_operands(relation)
            @operand = relation
          end

          # Initialize name attribute
          #
          # @return [undefined]
          #
          # @api private
          #
          def set_name
            @name = @operand.name
            @operand = nil
          end

        end #Base
      end #Generator
    end #Mongo
  end #Adapter
end #Axiom