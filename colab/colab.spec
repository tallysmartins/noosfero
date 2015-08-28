%define name colab
%define version 1.10.3
%define default_release 4
%{!?release: %define release %{default_release}}
%define buildvenv /var/tmp/%{name}-%{version}

Summary: Collaboration platform for communities
Name: %{name}
Version: %{version}
Release: %{release}
Source0: %{name}-%{version}.tar.gz
License: GPLv2
Group: Development/Tools
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Prefix: %{_prefix}
Vendor: Sergio Oliveira <sergio@tracy.com.br>
Url: https://github.com/colab/colab
BuildArch: noarch
BuildRequires: colab-deps >= 1.10, python-virtualenv
Requires: colab-deps >= 1.10, solr, mailman-api

%description
Integrated software development platform.

%prep
%setup -n %{name}-%{version} -n %{name}-%{version}

%build
# install colab into virtualenv to make sure dependencies are OK
rm -rf %{buildvenv}
cp -r /usr/lib/colab %{buildvenv}
PATH=%{buildvenv}/bin:$PATH pip install --no-index .
virtualenv --relocatable %{buildvenv}

# cleanup virtualenv
rpm -ql colab-deps | sed '/^\/usr\/lib\/colab\// !d; s#/usr/lib/colab/##' > cleanup.list
while read f; do
  if [ -f "%{buildvenv}/$f" ]; then
    rm -f "%{buildvenv}/$f"
  fi
done < cleanup.list
rm -f cleanup.list
find %{buildvenv} -type d -empty -delete

%install

# install config file
install -d -m 0755 %{buildroot}/etc/colab
install -m 0644 misc/etc/colab/gunicorn.py %{buildroot}/etc/colab

# install virtualenv
install -d -m 0755 %{buildroot}/usr/lib
rm -rf %{buildroot}/usr/lib/colab
cp -r %{buildvenv} %{buildroot}/usr/lib/colab
mkdir -p %{buildroot}/%{_bindir}

cat > %{buildroot}/%{_bindir}/colab-admin <<EOF
#!/bin/sh
set -e

if [ "\$USER" = colab ]; then
  exec /usr/lib/colab/bin/colab-admin "\$@"
else
  exec sudo -u colab /usr/lib/colab/bin/colab-admin "\$@"
fi
EOF
chmod +x %{buildroot}/%{_bindir}/colab-admin

# install initscript
install -d -m 0755 %{buildroot}/lib/systemd/system
install -m 0644 misc/lib/systemd/system/colab.service %{buildroot}/lib/systemd/system
# install crontab
install -d -m 0755 %{buildroot}/etc/cron.d
install -m 0644 misc/etc/cron.d/colab %{buildroot}/etc/cron.d

%clean
rm -rf $RPM_BUILD_ROOT
rm -rf %{buildvenv}

%files
/usr/lib/colab
/var/log/colab
%{_bindir}/*
/etc/cron.d/colab
/etc/colab/gunicorn.py
/lib/systemd/system/colab.service

%post
groupadd colab || true
if ! id colab; then
  useradd --system --gid colab  --home-dir /usr/lib/colab --no-create-home colab
fi

if [ ! -f /etc/colab/settings.py ]; then
  SECRET_KEY=$(openssl rand -hex 32)
  cat > /etc/colab/settings.py <<EOF

# Set to false in production
DEBUG = True
TEMPLATE_DEBUG = True

# System admins
ADMINS = [['John Foo', 'john@example.com'], ['Mary Bar', 'mary@example.com']]

MANAGERS = ADMINS

COLAB_FROM_ADDRESS = '"Colab" <noreply@example.com>'
SERVER_EMAIL = '"Colab" <noreply@example.com>'

EMAIL_HOST = 'localhost'
EMAIL_PORT = 25
EMAIL_SUBJECT_PREFIX = '[colab]'

SECRET_KEY = '$(openssl rand -hex 32)'

ALLOWED_HOSTS = [
    'localhost',
#    'example.com',
#    'example.org',
#    'example.net',
]

# Database settings
#
#     When DEBUG is True colab will create the DB on
#     the repository root. In case of production settings
#     (DEBUG False) the DB settings must be set.
#
# DATABASES = {
#     'default': {
#         'ENGINE': 'django.db.backends.sqlite3',
#         'NAME': '/path/to/colab.sqlite3',
#     }
# }

# Disable indexing
ROBOTS_NOINDEX = False

LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,

    'formatters': {
        'colab': '[colab] (%(name)s) %(levelname)s: %(message)s',
        'verbose': '%(asctime)s (%(name)s) %(levelname)s: %(message)s',
    },

    'handlers': {
        'null': {
            'level': 'DEBUG',
            'class': 'logging.NullHandler',
        },
        'syslog': {
            'level': 'WARNING',
            'class': 'logging.handlers.SysLogHandler',
            'formatter': 'colab',
            'address': '/dev/log',
        },
        'file': {
            'level': 'DEBUG',
            'class': 'logging.handlers.TimedRotatingFileHandler',
            'filename': '/var/log/colab/colab.log',
            'interval': 24,  # 24 hours
            'backupCount': 7,  # keep last 7 backups
            'encoding': 'UTF-8',
            'formatter': 'verbose',
        },
    },

    'loggers': {
        'django': {
            'handlers': ['file', 'syslog'],
            'propagate': False,
        },
        'revproxy': {
            'handlers': ['file', 'syslog'],
            'propagate': False,
            'level': 'ERROR',
        },
    },
}

EOF

  chown root:colab /etc/colab/settings.py
  chmod 0640 /etc/colab/settings.py
fi

install -d -m 0755 -o colab -g colab /var/lib/colab-assets

# If nginx is available serve assets using it
if [ -d /usr/share/nginx ]; then
    ln -s /var/lib/colab-assets /usr/share/nginx/colab
fi

yes yes | colab-admin collectstatic

if [ $1 -gt 1 ]; then
  # upgrade; restart if running
  systemctl try-restart colab
fi

%preun
if [ $1 -eq 0 ]; then
  # package being removed
  systemctl stop colab
  systemctl disable colab
fi
