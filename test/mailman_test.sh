. $(dirname $0)/test_helper.sh

test_mailman_running() {
  assertTrue 'mailman running' 'run_on integration pgrep -fa mailmanctl'
}

test_mailman_delivery() {
  # create list
  run_on integration sudo -u mailman /usr/lib/mailman/bin/newlist --quiet foobar foobar@example.com foobar
  # subscribe us
  echo 'foobar@example.com' | run_on integration sudo -u mailman /usr/lib/mailman/bin/add_members -r - --welcome-msg=n foobar > /dev/null

  # send message
  date | run_on integration mail -r foobar@example.com -s test foobar@listas.softwarepublico.dev

  # wait for message to arrive at the list mailbox
  mbox=/var/lib/mailman/archives/private/foobar.mbox/foobar.mbox
  if wait_for integration $mbox; then
    messages=$(run_on integration sudo grep -i -c ^Message-ID: $mbox)
  else
    messages=0
  fi

  # remove list
  run_on integration sudo -u mailman /usr/lib/mailman/bin/rmlist -a foobar > /dev/null

  assertEquals 'Message arrives at mailbox' "1" "$messages"
}

test_mailman_web_interface() {
  local title="$(curl --silent --fail --location --header 'Host: listas.softwarepublico.dev' http://$integration/ | grep -i '<title>')"
  assertEquals "<TITLE>listas.softwarepublico.dev Mailing Lists</TITLE>" "$title"
}

. shunit2
