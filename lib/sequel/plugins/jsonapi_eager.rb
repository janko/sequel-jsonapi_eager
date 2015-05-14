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
            assoc_name, assoc_include = relationship.split(".", 2)
            if model.associations.map(&:to_s).include?(assoc_name)
              associations[assoc_name.to_sym] = send(assoc_name) do |ds|
                ds.jsonapi_eager(assoc_include.to_s)
              end
            else
              raise UndefinedAssociation, "#{model} doesn't have association #{assoc_name.inspect}"
            end
          end

          self
        end
      end
    end
  end
end
