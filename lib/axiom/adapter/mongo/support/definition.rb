module Axiom
  module Adapter
    class Mongo
      class Definition
        attr_accessor :method_name, :variable_name, :binary, :code_to_generate, :get_name

        instance_methods(false).grep(/=$/).each{ |method| class_eval{ alias_method method[0..-2], method } }
        
        def code_to_generate(&block)
          tap{ @code_to_generate = block }          
        end

        def get_name(&block)
          tap{ @get_name = block }          
        end

        def call(&block)
          instance_eval(&block)
        end

        def to_hash
          instance_variables.map(&:to_s).inject({}){ |hash, var| hash.tap { hash[var[1..-1].to_sym] = instance_variable_get(var) } }
        end

      end #class Defifnition
    end #class Mongo
  end #module Adapter
end #module Axiom