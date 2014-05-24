#!/bin/sh
erl +P 1024000 +K true -smp disable -pa ebin -boot start_sasl -s x start   -mnesia dir '"./Mnesia.nonode@nohost"'