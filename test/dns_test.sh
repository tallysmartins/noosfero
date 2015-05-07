. $(dirname $0)/test_helper.sh

if [ "$SPB_ENV" = local ]; then
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
  local expected=".*in-addr.arpa domain name pointer $hostname"
  assertTrue "Reverse DNS of $ip must be $hostname (found: $results)" "expr match \"$results\$\" \"$expected\$\""
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

# TODO test_spf_external_relay

if [ "$1" = '--doc' ]; then
  check_hostname() {
    echo "| ❏ A | $1 | $2 |"
  }
  check_mx() {
    echo "| ❏ MX | $1 | ${2}. |"
  }
  check_reverse_dns() {
    echo "| ❏ PTR  | $1 | ${2}. |"
  }
  header() {
    echo "## $1"
    echo
    echo '| Tipo | Entrada | Aponta para |'
    echo '|:-----|:------|:----------|'
  }
  footer() {
    echo
  }
  (
    echo "# Entradas de DNS necessárias"
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

    # FIXME test_spf_external_relay

  )
else
  . shunit2
fi
