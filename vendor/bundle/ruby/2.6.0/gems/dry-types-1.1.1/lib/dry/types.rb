# frozen_string_literal: true

require 'bigdecimal'
require 'date'
require 'set'

require 'concurrent'

require 'dry-container'
require 'dry-equalizer'
require 'dry/core/extensions'
require 'dry/core/constants'
require 'dry/core/class_attributes'

require 'dry/types/version'
require 'dry/types/container'
require 'dry/types/inflector'
require 'dry/types/type'
require 'dry/types/printable'
require 'dry/types/nominal'
require 'dry/types/constructor'
require 'dry/types/module'

require 'dry/types/errors'

module Dry
  # Main library namespace
  #
  # @api public
  module Types
    extend Dry::Core::Extensions
    extend Dry::Core::ClassAttributes
    extend Dry::Core::Deprecations[:'dry-types']
    include Dry::Core::Constants

    TYPE_SPEC_REGEX = /(.+)<(.+)>/.freeze

    # @see Dry.Types
    def self.module(*namespaces, default: :nominal, **aliases)
      Module.new(container, *namespaces, default: default, **aliases)
    end
    deprecate_class_method :module, message: <<~DEPRECATION
      Use Dry.Types() instead. Beware, it exports strict types by default, for old behavior use Dry.Types(default: :nominal). See more options in the changelog
    DEPRECATION

    # @api private
    def self.included(*)
      raise 'Import Dry.Types, not Dry::Types'
    end

    # Return container with registered built-in type objects
    #
    # @return [Container{String => Nominal}]
    #
    # @api private
    def self.container
      @container ||= Container.new
    end

    # Check if a give type is registered
    #
    # @return [Boolean]
    #
    # @api private
    def self.registered?(class_or_identifier)
      container.key?(identifier(class_or_identifier))
    end

    # Register a new built-in type
    #
    # @param [String] name
    # @param [Type] type
    # @param [#call,nil] block
    #
    # @return [Container{String => Nominal}]
    #
    # @api private
    def self.register(name, type = nil, &block)
      container.register(name, type || block.call)
    end

    # Get a built-in type by its name
    #
    # @param [String,Class] name
    #
    # @return [Type,Class]
    #
    # @api public
    def self.[](name)
      type_map.fetch_or_store(name) do
        case name
        when String
          result = name.match(TYPE_SPEC_REGEX)

          if result
            type_id, member_id = result[1..2]
            container[type_id].of(self[member_id])
          else
            container[name]
          end
        when Class
          type_name = identifier(name)

          if container.key?(type_name)
            self[type_name]
          else
            name
          end
        end
      end
    end

    # Infer a type identifier from the provided class
    #
    # @param [#to_s] klass
    #
    # @return [String]
    def self.identifier(klass)
      Inflector.underscore(klass).tr('/', '.')
    end

    # Cached type map
    #
    # @return [Concurrent::Map]
    #
    # @api private
    def self.type_map
      @type_map ||= Concurrent::Map.new
    end

    # List of type keys defined in {Dry::Types.container}
    #
    # @return [String]
    #
    # @api private
    def self.type_keys
      container.keys
    end

    # @api private
    def self.const_missing(const)
      underscored = Inflector.underscore(const)

      if container.keys.any? { |key| key.split('.')[0] == underscored }
        raise NameError,
              'dry-types does not define constants for default types. '\
              'You can access the predefined types with [], e.g. Dry::Types["integer"] '\
              'or generate a module with types using Dry.Types()'
      else
        super
      end
    end
  end

  # Export registered types as a module with constants
  #
  # @example no options
  #
  #   module Types
  #     # imports all types as constants, uses modules for namespaces
  #     include Dry::Types()
  #   end
  #   # strict types are exported by default
  #   Types::Integer
  #   # => #<Dry::Types[Constrained<Nominal<Integer> rule=[type?(Integer)]>]>
  #   Types::Nominal::Integer
  #   # => #<Dry::Types[Nominal<Integer>]>
  #
  # @example changing default types
  #
  #   module Types
  #     include Dry::Types(default: :nominal)
  #   end
  #   Types::Integer
  #   # => #<Dry::Types[Nominal<Integer>]>
  #
  # @example cherry-picking namespaces
  #
  #   module Types
  #     include Dry::Types(:strict, :coercible)
  #   end
  #   # cherry-picking discards default types,
  #   # provide the :default option along with the list of
  #   # namespaces if you want the to be exported
  #   Types.constants # => [:Coercible, :Strict]
  #
  # @example custom names
  #   module Types
  #     include Dry::Types(coercible: :Kernel)
  #   end
  #   Types::Kernel::Integer
  #   # => #<Dry::Types[Constructor<Nominal<Integer> fn=Kernel.Integer>]>
  #
  # @param [Array<Symbol>] namespaces List of type namespaces to export
  # @param [Symbol] default Default namespace to export
  # @param [Hash{Symbol => Symbol}] aliases Optional renamings, like strict: :Draconian
  #
  # @return [Dry::Types::Module]
  #
  # @see Dry::Types::Module
  #
  # @api public
  #
  # rubocop:disable Naming/MethodName
  def self.Types(*namespaces, default: Types::Undefined, **aliases)
    Types::Module.new(Types.container, *namespaces, default: default, **aliases)
  end
  # rubocop:enable Naming/MethodName
end

require 'dry/types/core' # load built-in types
require 'dry/types/extensions'
require 'dry/types/printer'
