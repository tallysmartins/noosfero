# Software Público - configuration management

## Requirements

* [chake](https://rubygems.org/gems/chake)
* [rake](https://rubygems.org/gems/rake)
* python-sphinx

For development

* vagrant
* shunit2
* moreutils
* redir

## Configuration parameters

All configuration parameters are defined in `nodes.yaml`, with exception of IP
addresses and ssh configuration, which are defined in different files.
Each environment are defined on `config/<ENV>/*` and to deploy
you're need to use the `SPB_ENV` variable. The environment
`local` is defined by default. The files to configure a new env are:

- **config.yaml**: any configuration used for the specific environment.
- **ips.yaml**: the IP of each node.
- **ssh_config**: used to login into the machine with the
command `rake login:$server`.
- **iptables-filter-rules**: any iptables configuration needed
to the environment.

If you need to do any changes on the IPs addresses, make sure
that the ips.yaml are configure for the right environment.
You will probably not need to change nodes.yaml unless you are
developing the deployment process.

## Deploy

### Development

First you have to bring up the development virtual machines:

```bash
$ vagrant up
$ rake preconfig
$ rake bootstrap_common
```

```
WARNING: Right now there are 7 VM's: six of them with 512MB of
 RAM and one with 1GB of RAM. Make sure that your local machine
 can handle this environment. Also, this might take a while.
```

The basic commands for deployment:
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
before doing the actual deployment. This command should only be
runned **one** time.

After that:

```bash
$ rake SPB_ENV=production                   # deploys all servers
$ rake nodes SPB_ENV=production             # lists all servers
$ rake converge:$server SPB_ENV=production  # deploys only $server
```

You can also do `export SPB_ENV=production` in your shell and
omit it in the `rake` calls.

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
