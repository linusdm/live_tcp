# LiveTcp

This is an experiment to monitor a TCP service that only exposes a request/response inteface without a durable socket connection.
Any observed changes are broadcast over a Phoenix PubSub to allow LiveViews to subscribe to these changes.

## Apps

This umbrella project contains two apps:
- `:live_tcp_monitor` a simple Phoenix application that starts and consumes the monitors.
- `:live_tcp_server` a simple TCP server to emulate a back-end. It also exposes an API through iex to change values.

Both applications are started when you run `iex -S phx.server` from the root folder.

## TODO

- [x] Start a very simple embedded TCP server and add an interface to change values (from iex)
- [x] Dynamically start monitors
- [x] Observe changes in a LiveView
- [ ] Persist monitor specifications to survive a system restart,
      and make sure all registered monitors are restarted at startup.

## Development

You can use [asdf](https://github.com/asdf-vm/asdf) and the provided `.tool-versions` to get the
correct erlang and elixir environment.

Start up a postgres database with docker by running `docker-compose up -d` in the root folder.
Stop the database by running `docker-compose down --remove-orphans`.

Alternatively you can use following commands to start and stop a postgres database,
using only docker without docker-compose:
```sh
docker run --detach -e POSTGRES_PASSWORD="postgres" -p 5432:5432 --name live_tcp_db postgres
docker stop live_tcp_db && docker rm live_tcp_db
```

To start your Phoenix server:

  * Install dependencies with `mix deps.get` (in the root folder)
  * Create and migrate your database with `mix ecto.setup` (in the `apps/live_tcp_monitor` folder)
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
    (do this in the root folder to make sure both applications start)

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Use the application

To start a monitor with some identifier simply visit [`localhost:4000/monitors/1`](http://localhost:4000/monitors/1)
(the last part inidicates the identifier).

To change a monitored value you need the iex console. Simply execute:
```elixir
LiveTcp.Server.set_value("1", "new value")
```
The first arguement indicates the identifier (which you used to start the monitor above). The second argument is the new
value for this identifier.
