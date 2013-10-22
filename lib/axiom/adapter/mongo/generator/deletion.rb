module Axiom
  module Adapter
    class Mongo
      class Generator
        class Deletion < Generator

          def initialize
            @method_name = :remove  
          end

          private

          def get_mongo_hash
            #TODO we can delete only one record(see Axiom readme)
            @right.to_a.map{|tuple| Hash[tuple.data.map { |attribute, value| [attribute.name, value] }]}.first
          end

          def set_operands(deletion)
            @left = deletion.left
            @right = deletion.right
          end

          def set_name
            @name = @left.name
          end

        end #Deletion
      end #Generator
    end #Mongo
  end #Adapter
end #Axiom