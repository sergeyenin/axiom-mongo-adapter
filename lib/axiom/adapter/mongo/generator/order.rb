module Axiom
  module Adapter
    class Mongo
      class Generator
        class Order < Generator

          def initialize
            @method_name = :sort  
          end

          private

          def set_fields(order)
            @fields = order.header.map(&:name)
          end

          def get_mongo_hash
            predicate
          end

          def set_operands(order)
            @operand = order.operand
          end

          def set_predicate(order)
            @predicate =  Literal.sort(order.directions)
          end

          def set_name
            @name = @operand.name
          end

        end #Order
      end #Generator
    end #Mongo
  end #Adapter
end #Axiom