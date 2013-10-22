module Axiom
  module Adapter
    class Mongo
      class Generator
        class Limit < Generator

          def initialize
            @method_name = :limit  
          end

          private

          def set_fields(limit)
            @fields = limit.header.map(&:name)
          end

          def get_mongo_hash
            predicate
          end

          def set_operands(limit)
            @operand = limit.operand
          end

          def set_predicate(limit)
            @predicate =  Literal.positive_integer(limit.limit)
          end

          def set_name
            @name = @operand.operand.name
          end

        end #Limit
      end #Generator
    end #Mongo
  end #Adapter
end #Axiom