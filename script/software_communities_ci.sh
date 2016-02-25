RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

./script/noosfero-plugins disable gov_user
printf "${GREEN}=================================\n"
printf "SoftwareCommunitiesPlugin:UNITS${NC}\n"
rake test:units TEST=plugins/software_communities/test/unit/*
units=$?

printf "${GREEN}=================================\n"
printf "SoftwareCommunitiesPlugin:FUNCTIONALS${NC}\n"
rake test:functionals TEST=plugins/software_communities/test/functional/*
functionals=$?

printf "${GREEN}=================================\n"
printf "SoftwareCommunitiesPlugin:SELENIUM${NC}\n"
xvfb-run -a cucumber plugins/software_communities/features/* -p software_communities_selenium --format progress
selenium=$?

printf "${GREEN}=================================\n"
printf "SoftwareCommunitiesPlugin:CUCUMBER${NC}\n"
xvfb-run -a cucumber plugins/software_communities/features/* -p software_communities --format progress
cucumber=$?

if [ $units -ne 0 ] || [ $functionals -ne 0 ] || [ $selenium -ne 0 ] || [ $cucumber -ne 0 ]; then
	printf "${RED}=================================\n"
	printf "ERROR RUNNING SOFTWARE COMMUNITIES PLUGIN TESTS${NC}\n"
	exit 1
fi

exit 0
