# on STI classes tike Article and Profile, plugins' extensions
# on associations should be reflected on descendants
module ActiveRecord
  module Associations
    def association(name) #:nodoc:
      association = association_instance_get(name)

      if association.nil?
        reflection = self.class._reflect_on_association(name)

        # Check inheritance chain for possible upstream association
        klass = self.class.superclass
        while reflection.nil? && klass.respond_to?(:_reflect_on_association)
          reflection = klass._reflect_on_association(name)
          klass = klass.superclass
        end

        unless reflection
          raise AssociationNotFoundError.new(self, name)
        end
        association = reflection.association_class.new(self, reflection)
        association_instance_set(name, association)
      end

      association
    end
  end
end
