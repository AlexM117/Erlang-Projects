%Alex Marlow, pr2_A tests file, 6/7/2019

-module(pr2_A_tests).

-include_lib("eunit/include/eunit.hrl").

%as my algorithm is not random in the way it finds the paths, this test case will not give any false negatives
driver_1_test() -> 
	?assertEqual("[ {4, 4}, {4, 3}, {3, 3}, {3, 2}, {2, 2}, {2, 4}, {4, 1}, {1, 3}, {3, 0}, {0, 2}, {2, 1}, {1, 1}, {1, 0}, {0, 0}, {0, 4} ]",pr2_A:driver(fun pr2_A:listAsString/1,fun pr2_A:solution/1, 4)).

driver_2_test() -> 
	?assertEqual("[ {2, 2}, {2, 1}, {1, 1}, {1, 0}, {0, 0}, {0, 2} ]",pr2_A:driver(fun pr2_A:listAsString/1,fun pr2_A:solution/1, 2)).

%test for flip function
flip_1_test() ->
	?assertEqual([{2, 2}, {2, 1}, {1, 1}, {1, 0}, {0, 0}, {0, 2}],pr2_A:flip([{2, 2}, {1, 2}, {1, 1}, {0, 1}, {0, 0}, {2, 0}])).


%As the dominoes are created in a non-random way, this test will not give false negatives
dominoes_1_test() ->
	?assertEqual([{4,4},{4,3},{4,2},{4,1},{4,0},{3,3},{3,2},{3,1},{3,0},{2,2},{2,1},{2,0},{1,1},{1,0},{0,0}],pr2_A:dominoes(4)).

%As eulers finds a path in a non random way, it will consistantly give the same output for a variation of order of dominoes as input
eulers_1_test() ->
	?assertEqual([{2,2},{2,1},{1,1},{1,0},{0,0},{0,2}],pr2_A:eulers([{2,2},{2,1},{2,0},{1,1},{1,0},{0,0}])).

%tests for eulers function
eulers_2_test() ->
	?assertEqual([{1,1},{1,2},{2,2},{2,0},{0,0},{0,1}],pr2_A:eulers([{1,1},{2,1},{2,0},{2,2},{1,0},{0,0}])).

%tests for list to string function
listAsString_1_test() ->
	?assertEqual("[ {2, 2}, {2, 1}, {1, 1}, {1, 0}, {0, 0}, {0, 2} ]", pr2_A:listAsString([{2,2},{2,1},{1,1},{1,0},{0,0},{0,2}])).

%tests for solution function
solution_1_test() ->
	?assertEqual([],pr2_A:solution(3)).

solution_2_test() ->
	?assertEqual([{4,4},{4,3},{3,3},{3,2},{2,2},{2,4},{4,1},{1,3},{3,0},{0,2},{2,1},{1,1},{1,0},{0,0},{0,4}],pr2_A:solution(4)).






	
