#!/bin/bash

elixir=$(ps aux | grep [e]tc/server.pid | wc -l)

if  [ $elixir -ge 1 ]
then
	echo "elixir works"
else
	echo 1
fi