module Axiom
  module Adapter
    class Mongo
      class Generator
        # A Generator for Axiom::Relation::Operation::Restriction relations
        class Restriction < Generator

          # Initialize Restriction instance
          #
          # @return [undefined]
          #
          # @api public
          #
          def initialize
            @method_name = :find  
          end

          private

          # Initialize fields attribute
          #
          # @return [Hash]
          #
          # @api private
          #
          def set_fields(restriction)
            @fields = restriction.header.map(&:name)
          end

          # Return valid mongo hash
          #
          # @return [Hash]
          #
          # @api private
          #
          def get_mongo_hash
            predicate
          end

          # Initialize operand attribute
          #
          # @return [Hash]
          #
          # @api private
          #
          def set_operands(restriction)
            @operand = restriction.operand
          end

          # Initialize predicate attribute
          #
          # @return [Hash]
          #
          # @api private
          #
          def set_predicate(restriction)
            @predicate = Function.function(restriction.predicate)
          end

          # Initialize name attribute
          #
          # @return [Hash]
          #
          # @api private
          #
          def set_name
            @name = @operand.name
          end

        end #Restriction
      end #Generator
    end #Mongo
  end #Adapter
end #Axiom