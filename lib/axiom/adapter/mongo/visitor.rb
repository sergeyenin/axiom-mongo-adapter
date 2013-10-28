module Axiom
  module Adapter
    class Mongo
      # Mongo visitor for axiom relations
      class Visitor
        include Adamantium::Flat

        # Return query
        #
        # @return [Hash]
        #
        # @api private
        #
        attr_reader :query

        # Return method for executing
        #
        # @return [Symbol]
        #
        # @api private
        #        
        attr_reader :method_name
 
        # Return collection name
        #
        # @return [String]
        #
        # @api private
        #
        attr_reader :collection_name

        # Return fields to select
        #
        # @return [Array<Symbol>]
        #
        # @api private
        #
        attr_reader :fields

        # Return mongo query options
        #
        # @return [Hash]
        #
        # @api private
        #
        def options
          {
            :skip   => @skip,
            :limit  => @limit,
            :sort   => @sort,
            :fields => fields
          }
        end

      private

        # Initialize visitor
        #
        # @param [Relation] relation
        #
        # @return [undefined]
        #
        # @api private
        #
        def initialize(relation)
          relation = relation.send(:relation) if relation.is_a? Gateway 
          dispatch(relation)
          @query ||= {}
          @sort  ||= []

        end

        TABLE = Operations.new(
          Axiom::Relation::Base                       => 'Generator::Base',
          Axiom::Relation::Operation::Order           => ['Generator::Order', :@sort],
          Axiom::Relation::Operation::Limit           => ['Generator::Limit', :@limit],
          Axiom::Relation::Operation::Offset          => ['Generator::Offset', :@skip],
          Axiom::Relation::Operation::Insertion       => 'Generator::Insertion',
          Axiom::Algebra::Restriction                 => 'Generator::Restriction',
          Axiom::Relation::Operation::Deletion        => 'Generator::Deletion'
        )


        def set_attributes(relation, generator_klass, ivar_name = :@query)
          if instance_variable_get(ivar_name)
            raise UnsupportedAlgebraError, "No support for visiting #{operation.class} more than once"
          end
          generator = eval(generator_klass).new.visit(relation)

          instance_variable_set(ivar_name, generator.to_hash)

          @collection_name = generator.name
          @method_name = generator.method_name
          @fields = generator.fields

          self
        end

        # Dispatch relation
        #
        # @param [Relation] relation
        #
        # @return [self]
        #
        # @api private
        #
        def dispatch(relation)
          call = TABLE.lookup(relation)
          set_attributes *call

          self
        end


        memoize :options
      end
    end
  end
end
