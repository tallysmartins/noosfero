# Software Público - configuration management

## Requirements

* [chake](https://rubygems.org/gems/chake)
* rake

For development

* vagrant
* shunit2
* moreutils
* redir

## Configuration parameters

All configuration parameters are defined in `nodes.yaml`, with exception of IP
addresses, which are defined in different files:

- for local development, the IP addresses of the Vagrant VMs are defined in
  config/local/ips.yaml.

- for production, you need to create a new file called
  `config/production/ips.yaml`

You will probably not need to change nodes.yaml unless you are developing the
deployment process.

## Deploy

### Development

First you have to bring up the development virtual machines:

```bash
$ vagrant up
$ rake preconfig
$ rake bootstrap_common
```

Right now there are 5 VM's, so this might take a while. The basic commands for
deployment:

```bash
$ rake                                  # deploys all servers
$ rake nodes                            # lists all servers
$ rake converge:$server                 # deploys only $server
```

### Production

* TODO: document adding the SSL key and certificate
* TODO: document creation of `prod.yaml`.
* TODO: document SSH configuration

The very first step is

```
$ rake preconfig SPB_ENV=production
```

This will perform some initial configuration to the system that is required
before doing the actual deployment.

After that:

```bash
$ rake SPB_ENV=production                   # deploys all servers
$ rake nodes SPB_ENV=production             # lists all servers
$ rake converge:$server SPB_ENV=production  # deploys only $server
```

You can also do `export SPB_ENV=production` in your shell and omit it in the
`rake` calls.

See the output of `rake -T` for other tasks.

## Viewing the running site when developping locally

Run:

```bash
./server
```

Follow the on-screen instructions an browse to
[http://softwarepublico.dev/](http://softwarepublico.dev/).

Note: this requires that your system will resolve `\*.dev` to `localhost`.
Google DNS servers will do that automatically, otherwise you might add the following entries to `/etc/hosts`:

```
127.0.53.53 softwarepublico.dev
127.0.53.53 listas.softwarepublico.dev
```

