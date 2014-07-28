-module (processes).
-export ([max/1]).
-compile(export_all).

max(N) ->
	Max = erlang:system_info(process_limit),
	io:format("Maximum allowed processes:~p~n", [Max]),
	statistics(runtime),
	statistics(sall_clock),

	N.

loop () ->
	receive 
		{rectangle, W, H} ->
			io:format("Area of rectangle is ~p~n", [W * H]),
			loop();
		{circle, R} ->
			io:format("Area of circle is ~p~n", [3.14 * R * R]),
			loop()
	end.



wait() ->
	receive 
		die -> void
	end.

for(N, N, F) -> [F()];
for(I, N, F) -> [F() | for(I + 1, N, F)].




