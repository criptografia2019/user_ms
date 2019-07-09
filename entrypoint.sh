
sleep 40
rails db:create
rails db:migrate
rails s -p 3009 -b '0.0.0.0'
