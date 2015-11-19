require_dependency 'profile'

# FIXME move to core
class Profile

  def has_admin? person
    return unless person
    person.has_permission? 'edit_profile', self
  end

end

class Profile

  # cannot use :order because of months/years named_scope
  has_many :orders, class_name: 'OrdersPlugin::Sale', foreign_key: :profile_id
  has_many :sales, class_name: 'OrdersPlugin::Sale', foreign_key: :profile_id
  has_many :purchases, class_name: 'OrdersPlugin::Purchase', foreign_key: :consumer_id

  has_many :ordered_items, through: :orders, source: :items, order: 'name ASC'

  has_many :sales_consumers, through: :sales, source: :consumer
  has_many :purchases_consumers, through: :purchases, source: :consumer

  has_many :sales_profiles, through: :sales, source: :profile
  has_many :purchases_profiles, through: :purchases, source: :profile

  def sales_all_consumers
    consumers = self.sales_consumers.order 'name ASC'
    consumers.concat self.consumers.except_self.order('name ASC') if self.respond_to? :consumers
    consumers.uniq
  end
  def purchases_all_suppliers
    suppliers = self.purchases_profiles.order 'name ASC'
    suppliers.concat self.suppliers.except_self.order('name ASC') if self.respond_to? :suppliers
    suppliers.uniq
  end

  def self.create_orders_manager_role env_id
    env = Environment.find env_id
    Role.create! environment: env,
      key: "profile_orders_manager",
      name: I18n.t("orders_plugin.lib.ext.profile.orders_manager"),
      permissions: [
        'manage_orders',
      ]
  end

  def orders_managers
    self.members_by_role Profile::Roles.orders_manager(environment.id)
  end

  PERMISSIONS['Profile']['manage_orders'] = N_('Manage orders')
  module Roles
    def self.orders_manager env_id
      role = find_role 'orders_manager', env_id
      role ||= Profile.create_orders_manager_role env_id
      role
    end

    class << self
      def all_roles_with_orders_manager env_id
        roles = all_roles_without_orders_manager env_id
        if not roles.find{ |r| r.key == 'profile_orders_manager' }
          Profile.create_orders_manager_role env_id
          roles = all_roles_without_orders_manager env_id
        end

        roles
      end
      alias all_roles_without_orders_manager all_roles
      alias all_roles all_roles_with_orders_manager
    end
  end

end
