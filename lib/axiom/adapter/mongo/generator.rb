module Axiom
  module Adapter
    class Mongo
      class Generator
        attr_reader :header, :name, :method_name, :predicate, :fields, :operand
          
        def visit(relation)
          @header = relation.header
          set_operands relation
          set_predicate relation
          set_fields relation
          set_name
          self
        end

        def to_hash
          get_mongo_hash
        end

        protected

        def set_fields(relation)
          @fields = relation.header.map(&:name)
        end

        def get_mongo_hash; end

        def set_operands(relation); end

        def set_predicate(relation); end

        def set_name
          @name = @operand.respond_to?(:name) ? @operand.name : ""
        end

      end #Generator
    end #Mongo
  end #Adapter
end #Axiom