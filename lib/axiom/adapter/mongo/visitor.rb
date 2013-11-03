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
          dispatch(relation)
          @query ||= {}
          @sort  ||= []

        end

        TABLE = Operations.new(
          Adapter::Mongo.available_modules.inject({Axiom::Relation::Base => Generator::Base}) do |hash, module_name|
            class_name = module_name.name.split('::').last
            hash.tap{ hash[module_name] =  Axiom::Adapter::Mongo::Generator.const_get(class_name) }            
          end
        )

        # Initialize Visitor instance attributes
        #
        # @param [Relation] relation
        #   incoming relation
        #
        # @param [Generator] generator
        #   generator class for incoming relation
        #
        # @param [Symbol] ivar_name
        #   instance variable name, in which will be mongo json request
        # @return [self]
        #
        # @api private
        #
        def set_attributes(generator, relation)
          generator = generator.new.visit(relation)

          raise UnsupportedAlgebraError, "No support for visiting #{operation.class} more than once" if instance_variable_get(generator.variable_name)

          instance_variable_set(generator.variable_name, generator.to_hash)
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
