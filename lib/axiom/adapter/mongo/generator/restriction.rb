module Axiom
  module Adapter
    class Mongo
      class Generator
        class Restriction < Generator

          def initialize
            @method_name = :find  
          end

          private

          def set_fields(restriction)
            @fields = restriction.header.map(&:name)
          end

          def get_mongo_hash
            predicate
          end

          def set_operands(restriction)
            @operand = restriction.operand
          end

          def set_predicate(restriction)
            @predicate = Function.function(restriction.predicate)
          end

          def set_name
            @name = @operand.name
          end

        end #Restriction
      end #Generator
    end #Mongo
  end #Adapter
end #Axiom