. $(dirname $0)/test_helper.sh

test_database_connectivity() {
  assertTrue 'colab database connectivity' 'run_on integration psql -h database -U colab < /dev/null'
}

test_colab_config_is_in_place() {
  assertTrue 'colab settings.py is in place' 'run_on integration test -f /etc/colab/settings.py'
}

test_colab_running() {
  assertTrue 'colab service running' 'run_on integration pgrep -fa colab.wsgi'
}

test_colab_responds() {
  assertTrue 'colab responds' "run_on integration curl-host 'softwarepublico.dev' http://localhost:8001"
}

test_nginx_responds() {
  assertTrue 'nginx reponds' "run_on integration curl-host 'softwarepublico.dev' http://localhost"
}

test_nginx_virtualhost() {
  local title="$(curl --header 'Host: softwarepublico.dev' https://$config_external_hostname/dashboard | grep '<title>' | sed -e 's/^\s*//')"
  assertEquals "<title>Home - Colab</title>" "$title"
}

test_reverse_proxy_gitlab() {
  assertTrue 'Reverse proxy for gitlab' "curl --header 'Host: softwarepublico.dev' https://$config_external_hostname/gitlab/public/projects | grep -i '<meta.*gitlab.*>'"
}

test_reverse_proxy_noosfero() {
  assertTrue 'Reverse proxy for noosfero' "curl --header 'Host: softwarepublico.dev' https://$config_external_hostname/social/search/people | grep -i '<meta.*noosfero.*>'"
}

load_shunit2
