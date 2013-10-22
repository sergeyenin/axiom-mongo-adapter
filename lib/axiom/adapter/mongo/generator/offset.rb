module Axiom
  module Adapter
    class Mongo
      class Generator
        class Offset < Generator

          def initialize
            @method_name = :skip  
          end

          private

          def set_fields(offset)
            @fields = offset.header.map(&:name)
          end

          def get_mongo_hash
            predicate
          end

          def set_operands(offset)
            @operand = offset.operand
          end

          def set_predicate(offset)
            @predicate =  Literal.positive_integer(offset.offset)
          end

          def set_name
            @name = @operand.operand.name
          end

        end #Offset
      end #Generator
    end #Mongo
  end #Adapter
end #Axiom