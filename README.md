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

For development, all configuration parameters are defined in the file
`nodes.yaml`.

For production, create a new file based on `nodes.yaml`, e.g.
`prod.yaml`.

Todos os parâmetros de configuração estão definidos no arquivo nodes.yaml

## Deploy

### Development

First you have to bring up the development virtual machines:

```bash
$ vagrant up
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

```bash
$ rake NODES=prod.yaml                  # deploys all servers
$ rake nodes NODES=prod.yaml            # lists all servers
$ rake converge:$server NODES=prod.yaml # deploys only $server
```

You can also do `export NODES=prod.yaml` in your shell and omit the
`NODES=prod.yaml` parameter in the `rake` calls.

See the output of `rake -T` for other tasks.

## Viewing the running site in development

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

