. $(dirname $0)/test_helper.sh

if [ "$SPB_ENV" = local -o "$SPB_ENV" = lxc ]; then
  echo "_No DNS for local environment_"
  exit
fi


export LANG=C

check_hostname() {
  local host="$1"
  local ip="$2"
  local results="$(host -t A $host)"
  local expected="$host has address $ip"
  assertEquals "$host must resolve to $ip" "$results" "$expected"
}

check_mx() {
  local host="$1"
  local mx="$2"
  local results="$(host -t MX $host)"
  local expected="$host mail is handled by 0 ${mx}."
  assertEquals "$host MX must be $mx"  "$results" "$expected"
}

check_reverse_dns() {
  local ip="$1"
  local hostname="$2"
  local results="$(host $ip)"
  local expected=".*in-addr.arpa domain name pointer ${hostname}."
  assertTrue "Reverse DNS of $ip must be $hostname (found: $results)" "expr match '$results' 'include:$expected\$'"
}

check_spf() {
  domain="$1"
  spf_domain="$2"
  local results="$(host -t TXT "$domain")"
  assertTrue "TXT entry for $domain must have include:$spf_domain (found: $results)" "expr match '$results' 'include:$spf_domain'"
}

test_dns_web() {
  check_hostname "$config_external_hostname" "$config_external_ip"
}

test_mx() {
  check_mx "$config_external_hostname" "${config_relay_hostname}"
}

test_dns_lists() {
  check_hostname "$config_lists_hostname" "$config_external_ip"
}

test_mx_lists() {
  check_mx "$config_lists_hostname" "$config_relay_hostname"
}

test_dns_relay() {
  check_hostname "$config_relay_hostname" "$config_relay_ip"
}

test_reverse_dns_web() {
  check_reverse_dns "$config_external_ip" "$config_external_hostname"
}

test_reverse_dns_relay() {
  check_reverse_dns "$config_relay_ip" "$config_relay_hostname"
}

if [ -n "$config_external_outgoing_mail_domain" ]; then
  test_spf_domain() {
    check_spf "$config_external_hostname" "$config_external_outgoing_mail_domain"
  }
  test_spf_lists() {
    check_spf "$config_lists_hostname" "$config_external_outgoing_mail_domain"
  }
fi

if [ "$1" = '--doc' ]; then
  check_hostname() {
    echo '   * - A'
    echo "     - $1"
    echo "     - ${2}"
  }
  check_mx() {
    echo '   * - MX'
    echo "     - $1"
    echo "     - ${2}."
  }
  check_reverse_dns() {
    echo '   * - PTR'
    echo "     - $1"
    echo "     - ${2}."
  }
  check_spf() {
    echo "   * - TXT (SPF: \"v=spf1 ...\")"
    echo "     - $1 "
    echo "     - include:${2} "
  }
  header() {
    local aponta="${2:-Aponta para}"
    echo '.. list-table::'
    echo '   :header-rows: 1'
    echo
    echo '   * - Tipo'
    echo '     - Entrada'
    echo "     - $aponta"
  }
  footer() {
    echo
  }
  (
    header 'DNS(A)'
    test_dns_web
    test_dns_lists
    test_dns_relay
    footer

    header 'MX'
    test_mx
    test_mx_lists
    footer

    header 'DNS reverso'
    test_reverse_dns_web
    test_reverse_dns_relay
    footer

    header 'SPF' 'Deve conter'
    test_spf_domain
    test_spf_lists
    footer

  )
else
  . shunit2
fi
