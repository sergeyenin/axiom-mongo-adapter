module Axiom
  module Adapter
    class Mongo
      class Generator
        class Base < Generator

          def initialize
            @method_name = :find  
          end

          private

          def set_operands(relation)
            @operand = relation
          end

          def set_name
            @name = @operand.name
            @operand = nil
          end

        end #Base
      end #Generator
    end #Mongo
  end #Adapter
end #Axiom