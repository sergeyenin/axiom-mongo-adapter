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

        def self.construct_generator(method_name: :find, variable_name: :query, binary: false, code_to_generate: nil, get_name: nil)
          
          generator = Class.new(Generator) do
            define_method(:initialize)        { @method_name = method_name }
            define_method(:set_predicate)     { |relation| @predicate = code_to_generate.call(relation) if code_to_generate }
            define_method(:set_operands)      { |relation| binary ? (@left, @right = relation.left, relation.right) : @operand = (relation.operand rescue nil) || relation }
            define_method(:set_name)          { @name = get_name ? get_name.call(@operand) : (@operand||@left).send(:name) }
            define_method(:set_variable_name) { @variable_name = "@#{variable_name}" }

            private :set_predicate, :set_operands, :set_name, :set_variable_name
          end

        end
        private_class_method :construct_generator

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
          Adapter::Mongo.available_modules.inject({Axiom::Relation::Base => construct_generator(binary: false)}) do |hash, (module_name, attributes)|
            class_name = module_name.name.split('::').last
            hash.tap{ hash[module_name] =  construct_generator(attributes) }
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
