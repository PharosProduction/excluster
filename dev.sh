#!/bin/bash

cd ./elixir; HOSTNAME=aaa@127.0.0.1 iex --erl "-gproc gproc_dist all" -S mix phx.server