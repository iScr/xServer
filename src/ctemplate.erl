-module (ctemplate).
-compile(export_all).

start() ->
	spawn(?MODULE, loop, []).

rpc(Pid, Request) ->
	Pid ! {self(), Request},
	receive 
		{Pid, Response} ->
			Response
	end.	

loop() ->
	receive
		{From, _Req} ->
			From ! { self(), "from loop"},
			loop();
		Any ->
			io:format("Received:~p~n", [Any]),
			loop()
	end.
