
Summary: redis
Name: redis
Version: 2.8.17
Release: 1
License: BSD
Group: Applications/Multimedia
URL: http://redis.io/
Source0: redis-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildRequires: gcc, make, systemd
%{?systemd_requires}
Requires(post): /usr/sbin/useradd
Provides: redis

Packager: Alexandre Barbosa <alexandrealmeidabarbosa@gmail.com>

%description
Redis is a key-value database. It is similar to memcached but the dataset is
not volatile, and values can be strings, exactly like in memcached, but also
lists and sets with atomic operations to push/pop elements.

In order to be very fast but at the same time persistent the whole dataset is
taken in memory and from time to time and/or when a number of changes to the
dataset are performed it is written asynchronously on disk. You may lose the
last few queries that is acceptable in many applications but it is as fast
as an in memory DB (beta 6 of Redis includes initial support for master-slave
replication in order to solve this problem by redundancy).

Compression and other interesting features are a work in progress. Redis is
written in ANSI C and works in most POSIX systems like Linux, *BSD, Mac OS X,
and so on. Redis is free software released under the very liberal BSD license.


%prep
%setup

%{__cat} <<EOF >redis.logrotate
%{_localstatedir}/log/redis/*log {
    missingok
}
EOF

%{__cat} <<'EOF' >redis.service
[Unit]
Description=Redis

[Service]
User=redis
WorkingDirectory=%{_localstatedir}/lib/redis
ExecStart=/usr/bin/redis-server %{_sysconfdir}/redis.conf
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF


%build
%{__make}

%install
%{__rm} -rf %{buildroot}
mkdir -p %{buildroot}%{_bindir}
%{__install} -Dp -m 0755 src/redis-server %{buildroot}%{_bindir}/redis-server
%{__install} -Dp -m 0755 src/redis-benchmark %{buildroot}%{_bindir}/redis-benchmark
%{__install} -Dp -m 0755 src/redis-cli %{buildroot}%{_bindir}/redis-cli

%{__install} -Dp -m 0755 redis.logrotate %{buildroot}%{_sysconfdir}/logrotate.d/redis
%{__install} -Dp -m 0755 redis.service %{buildroot}%{_unitdir}/redis.service
%{__install} -Dp -m 0644 redis.conf %{buildroot}%{_sysconfdir}/redis.conf
%{__install} -p -d -m 0755 %{buildroot}%{_localstatedir}/lib/redis
%{__install} -p -d -m 0755 %{buildroot}%{_localstatedir}/log/redis

%pre
/usr/sbin/useradd --system --shell /sbin/nologin --home-dir %{_localstatedir}/lib/redis redis 2> /dev/null || :

%preun
%systemd_preun redis.service

%postun
%systemd_postun redis.service
/usr/sbin/userdel redis 2> /dev/null || :
/usr/sbin/groupdel redis 2> /dev/null || :

%post
%systemd_post redis.service
sed -i 's/# bind 127.0.0.1/bind 127.0.0.1/' %{_sysconfdir}/redis.conf

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-,root,root,0755)
%{_bindir}/redis-server
%{_bindir}/redis-benchmark
%{_bindir}/redis-cli
%{_unitdir}/redis.service
%config(noreplace) %{_sysconfdir}/redis.conf
%{_sysconfdir}/logrotate.d/redis
%dir %attr(0770,redis,redis) %{_localstatedir}/lib/redis
%dir %attr(0755,redis,redis) %{_localstatedir}/log/redis

%changelog
* Mon Nov 10 2014 - update for redis-2.8.17
- update preamble
- change redis-server, redis-benchmark and redis-cli location
- enable daemonize in redis.conf

* Tue Jul 13 2010 - jay at causes dot com 2.0.0-rc2
- upped to 2.0.0-rc2

* Mon May 24 2010 - jay at causes dot com 1.3.9-2
- moved pidfile back to /var/run/redis/redis.pid, so the redis
  user can write to the pidfile.
- Factored it out into %{pid_dir} (/var/run/redis), and
  %{pid_file} (%{pid_dir}/redis.pid)


* Wed May 05 2010 - brad at causes dot com 1.3.9-1
- redis updated to version 1.3.9 (development release from GitHub)
- extract config file from spec file
- move pid file from /var/run/redis/redis.pid to just /var/run/redis.pid
- move init file to /etc/init.d/ instead of /etc/rc.d/init.d/

* Fri Sep 11 2009 - jpriebe at cbcnewmedia dot com 1.0-1
- redis updated to version 1.0 stable

* Mon Jun 01 2009 - jpriebe at cbcnewmedia dot com 0.100-1
- Massive redis changes in moving from 0.09x to 0.100
- removed log timestamp patch; this feature is now part of standard release

* Tue May 12 2009 - jpriebe at cbcnewmedia dot com 0.096-1
- A memory leak when passing more than 16 arguments to a command (including
  itself).
- A memory leak when loading compressed objects from disk is now fixed.

* Mon May 04 2009 - jpriebe at cbcnewmedia dot com 0.094-2
- Patch: applied patch to add timestamp to the log messages
- moved redis-server to /usr/sbin
- set %config(noreplace) on redis.conf to prevent config file overwrites
  on upgrade

* Fri May 01 2009 - jpriebe at cbcnewmedia dot com 0.094-1
- Bugfix: 32bit integer overflow bug; there was a problem with datasets
  consisting of more than 20,000,000 keys resulting in a lot of CPU usage
  for iterated hash table resizing.

* Wed Apr 29 2009 - jpriebe at cbcnewmedia dot com 0.093-2
- added message to init.d script to warn user that shutdown may take a while

* Wed Apr 29 2009 - jpriebe at cbcnewmedia dot com 0.093-1
- version 0.093: fixed bug in save that would cause a crash
- version 0.092: fix for bug in RANDOMKEY command

* Fri Apr 24 2009 - jpriebe at cbcnewmedia dot com 0.091-3
- change permissions on /var/log/redis and /var/run/redis to 755; this allows
  non-root users to check the service status and to read the logs

* Wed Apr 22 2009 - jpriebe at cbcnewmedia dot com 0.091-2
- cleanup of temp*rdb files in /var/lib/redis after shutdown
- better handling of pid file, especially with status

* Tue Apr 14 2009 - jpriebe at cbcnewmedia dot com 0.091-1
- Initial release.
