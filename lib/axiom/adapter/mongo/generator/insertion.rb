module Axiom
  module Adapter
    class Mongo
      class Generator
        class Insertion < Generator

          def initialize
            @method_name = :insert  
          end

          private

          def get_mongo_hash
            @right.to_a.inject([]) {|res, tuple| res << Hash[tuple.data.map { |attribute, value| [attribute.name, value] }]}
          end

          def set_operands(insertion)
            @left = insertion.left
            @right = insertion.right
          end

          def set_name
            @name = @left.name
          end

        end #Insertion
      end #Generator
    end #Mongo
  end #Adapter
end #Axiom