. $(dirname $0)/test_helper.sh

test_redirect_http_to_https() {
  local redirect="$(curl --header 'Host: softwarepublico.dev' --head http://$reverseproxy/ | grep-header Location)"
  assertEquals "Location: https://softwarepublico.dev/" "$redirect"
}

test_reverse_proxy_to_colab() {
  local title="$(curl --header 'Host: softwarepublico.dev' https://$reverseproxy/dashboard | grep '<title>' | sed -e 's/^\s*//')"
  assertEquals "<title>Home - Colab</title>" "$title"
}

test_redirect_http_to_mailman() {
  local title="$(curl --silent --fail --location --header 'Host: listas.softwarepublico.dev' --insecure https://$reverseproxy/ | grep -i '<title>')"
  assertEquals "<TITLE>listas.softwarepublico.dev Mailing Lists</TITLE>" "$title"
}

. shunit2
