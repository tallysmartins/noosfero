. $(dirname $0)/test_helper.sh

test_database_connectivity() {
  assertTrue 'noosfero database connectivity' 'run_on social psql -h database -U noosfero < /dev/null'
}

test_noosfero_running() {
  assertTrue 'Noosfero running' 'run_on social pgrep -u noosfero -f thin'
}

test_noosfero_on_subdir() {
  local meta="$(run_on social curl --fail http://localhost:9000/social | sed -e '/noosfero:root/ !d; s/^\s*//')"
  assertEquals '<meta property="noosfero:root" content="/social"/>' "$meta"
}

test_reverse_proxy_noosfero() {
  local meta="$(run_on social curl-host softwarepublico.dev http://localhost/social | sed -e '/noosfero:root/ !d; s/^\s*//')"
  assertEquals '<meta property="noosfero:root" content="/social"/>' "$meta"
}

test_reverse_proxy_static_files() {
  local content_type="$(curl-host softwarepublico.dev --head http://$config_external_hostname/social/images/noosfero-network.png | grep-header Content-Type)"
  assertEquals "Content-Type: image/png" "$content_type"
}

test_redirect_with_correct_hostname_behind_proxy() {
  local redirect="$(curl-host softwarepublico.dev --head https://$config_external_hostname/social/search/contents | grep-header Location)"
  assertEquals "Location: https://softwarepublico.dev/social/search/articles" "$redirect"
}


load_shunit2
