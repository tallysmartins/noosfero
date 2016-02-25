GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

printf "${GREEN}=================================\n"
printf "GovUserPlugin:UNITS${NC}\n"
rake test:units TEST=plugins/gov_user/test/unit/*
units=$?

printf "${GREEN}=================================\n"
printf "GovUserPlugin:FUNCTIONALS${NC}\n"
rake test:functionals TEST=plugins/gov_user/test/functional/*
functionals=$?

printf "${GREEN}=================================\n"
printf "GovUserPlugin:SELENIUM${NC}\n"
xvfb-run -a cucumber plugins/gov_user/features/* -p software_communities_selenium --format progress
selenium=$?

printf "${GREEN}=================================\n"
printf "GovUserPlugin:CUCUMBER${NC}\n"
xvfb-run -a cucumber plugins/gov_user/features/* -p software_communities --format progress
cucumber=$?

if [ $units -ne 0 ] || [ $functionals -ne 0 ] || [ $selenium -ne 0 ] || [ $cucumber -ne 0 ]; then
	printf "${RED}=================================\n"
	printf "ERROR RUNNING GOV USER PLUGIN TESTS${NC}\n"
	exit 1
fi

exit 0
