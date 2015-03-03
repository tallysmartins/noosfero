. $(dirname $0)/test_helper.sh

test_mailman_running() {
  assertTrue 'mailman running' 'run_on integration pgrep -fa mailmanctl'
}

test_mailman_delivery() {
  # create list
  run_on integration create-list mylist user@example.com

  # send message
  run_on integration send-email user@example.com mylist@listas.softwarepublico.dev

  # wait for message to arrive at the list mailbox
  messages=$(run_on integration wait-for-messages mylist)

  # remove list
  run_on integration remove-list mylist

  assertEquals 'Message arrives at mailbox' "1" "$messages"
}

test_mailman_web_interface() {
  local title="$(curl --location --header 'Host: listas.softwarepublico.dev' http://$integration/mailman/cgi-bin/listinfo | grep -i '<title>')"
  assertEquals "<TITLE>listas.softwarepublico.dev Mailing Lists</TITLE>" "$title"
}

load_shunit2
