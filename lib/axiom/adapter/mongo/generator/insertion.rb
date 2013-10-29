module Axiom
  module Adapter
    class Mongo
      class Generator
        # A Generator for Axiom::Relation::Operation::Insertion relations
        class Insertion < Generator

          # Initialize Insertion instance
          #
          # @return [undefined]
          #
          # @api public
          #
          def initialize
            @method_name = :insert  
          end

          private

          # Return valid mongo hash
          #
          # @return [Hash]
          #
          # @api private
          #
          def get_mongo_hash
            @right.to_a.inject([]) {|res, tuple| res << Hash[tuple.data.map { |attribute, value| [attribute.name, value] }]}
          end

          # Initialize operands attributes
          #
          # @return [Hash]
          #
          # @api private
          #
          def set_operands(insertion)
            @left = insertion.left
            @right = insertion.right
          end

          # Initialize name attribute
          #
          # @return [Hash]
          #
          # @api private
          #
          def set_name
            @name = @left.name
          end

        end #Insertion
      end #Generator
    end #Mongo
  end #Adapter
end #Axiom