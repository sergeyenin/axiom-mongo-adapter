# encoding: utf-8

module Axiom
  module Adapter
    class Mongo
      # A relation backed by mongo adapter
      class Gateway < ::Axiom::Relation
        include Axiom::Relation::Proxy

        # Return inspected stub to fight against inspect related errors in spec printouts
        #
        # @return [String]
        #
        # @api private
        #
        # TODO: Remove this.
        #
        def inspect; 'GATEWAY'; end

        CHANGING_METHODS = [:insert, :delete]

        MAP = Adapter::Mongo.available_modules.inject({}){ |hash, module_name| hash.tap{ module_name::Methods.public_instance_methods(false).each{ |method| hash[method] = module_name } } }

        MAP.each_key do |method|
          define_method(method) do |*args, &block|
            return super unless supported?(method)
            response = @relation.send(method, *args, &block)
            self.class.new(adapter, response, @operations + [response.class]).tap{ adapter.execute(response) if CHANGING_METHODS.include?(method) }
          end
        end

        # The adapter the gateway will use to fetch results
        #
        # @return [Adapter::Mongo]
        #
        # @api private
        #

        attr_reader :adapter
        protected :adapter

        # Initialize a Gateway
        #
        # @param [Adapter::DataObjects] adapter
        #
        # @param [Relation] relation
        #
        # @return [undefined]
        #
        # @api private
        #
        def initialize(adapter, relation, operations=Set.new)
          @adapter  = adapter
          @relation = relation
          @operations = operations
        end

        # Iterate over each row in the results
        #
        # @example
        #   gateway = Gateway.new(adapter, relation)
        #   gateway.each { |tuple| ... }
        #
        # @yield [tuple]
        #
        # @yieldparam [Tuple] tuple
        #   each tuple in the results
        #
        # @return [self]
        #
        # @api public
        #
        def each
          return to_enum unless block_given?
          tuples.each { |tuple| yield tuple }
          self
        end
        
        # Convert the Gateway into an Array
        #
        # @example
        #   array = relation.to_ary
        #
        # @return [Array]
        #
        # @api public
        def to_ary
          tuples.map(&:to_ary)
        end

        def to_a
          tuples.to_a
        end
 
      private

        # Return if method is supported in this gateway
        #
        # @param [Symbol] method
        #
        # @return [true|false]
        #
        # @api private
        #
        def supported?(method)
          !@operations.include?(MAP.fetch(method))
        end

        # Return a list of tuples to iterate over
        #
        # @return [#each]
        #
        # @api private
        #
        def tuples
          return relation if materialized?
          self.class.superclass.new(header, adapter.read(relation))
        end
      end
    end # class Gateway
  end # class Relation
end # module Axiom
