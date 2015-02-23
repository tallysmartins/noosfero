. $(dirname $0)/test_helper.sh

test_inbound_mail() {
  run_on integration create-list mylist foo@example.com

  # sending FROM EMAIL RELAY HOST
  run_on email send-email foo@example.com mylist@listas.softwarepublico.dev

  messages=$(run_on integration wait-for-messages mylist)

  run_on integration remove-list mylist

  assertEquals 'Message arrives at the mailing list' '1' "$messages"
}

_test_outbound_email() {
  machine="$1"

  run_on email clear-email-queue

  run_on $machine send-email sender@example.com receiver@example.com

  messages=$(run_on email wait-for-email-to receiver@example.com)

  run_on email clear-email-queue

  assertEquals 'Message delivered through relay' 1 "$messages"
}

test_outbound_email_integration() {
  _test_outbound_email integration
}
test_outbound_email_database() {
  _test_outbound_email database
}
test_outbound_email_social() {
  _test_outbound_email social
}
test_outbound_email_reverseproxy() {
  _test_outbound_email reverseproxy
}

. shunit2

