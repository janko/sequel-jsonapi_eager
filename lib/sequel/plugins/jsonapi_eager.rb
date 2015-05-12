module Sequel
  module Plugins
    module JsonapiEager
      module DatasetMethods
        def jsonapi_eager(includes)
          includes = includes.split(",") if includes.is_a?(String)

          eager_args = includes.map do |relationship|
            path = relationship.split(".").map(&:to_sym)
            path.reverse.inject { |hash, rel| {rel => hash} }
          end

          eager(*eager_args)
        end
      end

      ClassMethods = DatasetMethods

      module InstanceMethods
        def jsonapi_eager(includes)
          includes = includes.split(",") if includes.is_a?(String)

          includes.each do |relationship|
            association_name, association_include = relationship.split(".", 2)
            association_dataset = send("#{association_name}_dataset")
              .jsonapi_eager(association_include.to_s)
            associations[association_name.to_sym] = association_dataset.all
          end

          self
        end
      end
    end
  end
end
