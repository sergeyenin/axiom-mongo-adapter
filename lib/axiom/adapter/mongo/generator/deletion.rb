module Axiom
  module Adapter
    class Mongo
      class Generator
        # A Generator for Axiom::Relation::Operation::Deletion relations
        class Deletion < Generator

          # Initialize Deletion instance
          #
          # @return [undefined]
          #
          # @api public
          #
          def initialize
            @method_name = :remove  
          end

          private

          # Return valid mongo hash
          #
          # @return [Hash]
          #
          # @api private
          #
          def get_mongo_hash
            #TODO we can delete only one record(see Axiom readme)
            @right.to_a.map{|tuple| Hash[tuple.data.map { |attribute, value| [attribute.name, value] }]}.first
          end

          # Initialize operands attributes
          #
          # @return [undefined]
          #
          # @api private
          #
          def set_operands(deletion)
            @left = deletion.left
            @right = deletion.right
          end

          # Initialize name attribute
          #
          # @return [undefined]
          #
          # @api private
          #
          def set_name
            @name = @left.name
          end

        end #Deletion
      end #Generator
    end #Mongo
  end #Adapter
end #Axiom