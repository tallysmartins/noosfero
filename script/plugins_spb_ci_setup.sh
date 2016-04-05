current_path=$(pwd)
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

printf "${GREEN}=================================\n"
printf "Enabling SPB plugins${NC}\n"
ln -s "$current_path/../src/noosfero-spb/software_communities/" plugins/software_communities
ln -s "$current_path/../src/noosfero-spb/gov_user/" plugins/gov_user
ln -s "$current_path/../src/noosfero-spb/spb_migrations/" plugins/spb_migrations
ln -s "$current_path/../src/noosfero-spb/noosfero-spb-theme" public/designs/themes/noosfero-spb-theme

printf "${GREEN}=================================\n"
printf "Enabling Organization Ratings${NC}\n"
./script/noosfero-plugins enable organization_ratings
bundle exec rake db:migrate
ratings=$?

printf "${GREEN}=================================\n"
printf "Enabling Gov User, Software Communities and SPB Migrations${NC}\n"
./script/noosfero-plugins enable software_communities gov_user
bundle exec rake db:migrate
gov_and_soft_plugins=$?


printf "${GREEN}=================================\n"
printf "Enabling SPB Migrations${NC}\n"
./script/noosfero-plugins enable spb_migrations
bundle exec rake db:migrate
spb_migrations=$?

printf "${GREEN}=================================\n"
printf "Compiling translations${NC}\n"
rake noosfero:translations:compile &>/dev/null
translations=$?

if [ $gov_and_soft_plugins -ne 0 ] || [ $ratings -ne 0 ] || [ $translations -ne 0 ] || [ $spb_migrations -ne 0 ]; then
	printf "${RED}=================================\n"
	printf "Error migrating SPB plugins!!n${NC}\n"
  exit 1
fi

printf "${GREEN}=================================\n"
printf "Running rake db:test:prepare${NC}\n"
bundle exec rake db:test:prepare
