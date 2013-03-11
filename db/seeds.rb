# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create a default admin account, admin@example.com, with password 'password'
domain = Domain.create(name: 'example.com')
Mailbox.create(domain_id: domain.id, local_part: 'admin', exim_password_digest: '5f4dcc3b5aa765d61d8327deb882cf99', password: 'password', password_confirmation: 'password', roles: ['domain_admin'] )