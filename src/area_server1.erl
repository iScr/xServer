-module (area_server1).
-compile(export_all).

loop() ->
	receive 
		{From, {rectangle, W, H}} ->
			From ! {self(), W * H},
			loop();
		{From, {circle, R}} ->
			From ! {self(),3.14 * R * R},
			loop();
		{From, Other} ->
			From ! {self(), {error, Other}},
			loop()
	end.


rpc(Pid, Request) ->
	Pid ! {self(), Request},
	receive 
		{Pid, Response} ->
			Response
	end.	


