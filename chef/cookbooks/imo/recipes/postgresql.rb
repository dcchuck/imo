execute 'add postgres packages' do
  command 'apt-get update'
end

package 'postgresql-9.4'
package 'postgresql-contrib'

execute 'createuser' do
  guard = <<-EOH
    psql -U postgres -c "select * from pg_user where
    usename='vagrant'" |
    grep -c vagrant
  EOH

  user 'postgres'
  command 'createuser -s vagrant'
  not_if guard, user: 'postgres'
end
