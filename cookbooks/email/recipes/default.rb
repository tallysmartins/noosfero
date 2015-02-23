include_recipe 'email'

package 'postfix'
package 'mailx' # for testing, etc

service 'postfix' do
  action [:enable, :start]
  supports :reload => true
end
