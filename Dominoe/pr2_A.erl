% Alex Marlow, pr2_A , 6/7/2019
%The following functions are used to create a circular train out of dominoes. The Algorithm used is Hierholzer's

-module(pr2_A).

-export([flip/1,dominoes/1,eulers/1,solution/1,listAsString/1,driver/3]).



%main driver gets solution and list to string funcitons and uses N to get the programs solution
driver(LAS,S,N) -> LAS(S(N)).



%This function takes in the desired max dominoe value and gives back the circular list of dominoes
solution(N) when (N rem 2) == 1 -> [];
solution(N) when (N rem 2) == 0 -> flip(eulers(dominoes(N))).



%This function talkes in a list of touples and turns it into a string by calling its helper function
listAsString(MyList) -> lists:flatten("[ " ++ stringHelper(MyList)).



%This function is the end case for the following delclaration of the function
stringHelper([{I1,I2}|[]]) -> io_lib:format("{~p, ~p} ]",[I1,I2]);
%This function helps turn a list of touples into a string by recursively adding a touple to the string
stringHelper([{I1,I2}|T]) -> io_lib:format("{~p, ~p}, ",[I1,I2]) ++ stringHelper(T).



%This function takes in a lost of dominoes and returns them in an order that creates a circular train
eulers(MyList) ->
	%gets head for starting vertex/node
	{CurrentNode,_} = hd(MyList),
	%calls helper function for recursive calls
	eulerHelp([], MyList, -1, CurrentNode).



%Helper function that returns whole list when recursion is complete
eulerHelp(MyPath,[],_,_) -> MyPath;
%Helper function forverry first case of recursive call
eulerHelp([], MyList, ReturnFNode, CurrentNode) ->
	%gets the edge leaving the current vetex with the lowest valued next vertex
	{FirstEl, LastEl} = getEdge(MyList,CurrentNode,ReturnFNode + 1),
		%case statement does recursive call, depending on which of the two numbers in the touple we want to match next
		case CurrentNode of
			FirstEl -> eulerHelp([{FirstEl, LastEl}],removeFlipItem(MyList,{FirstEl, LastEl}), -1, LastEl);
		
			LastEl -> eulerHelp([{FirstEl, LastEl}],removeFlipItem(MyList,{FirstEl, LastEl}), -1, FirstEl)
		end;
%helper function for euler that does the repeating recursive call
eulerHelp([{Path1, Path2}|PathT], MyList, ReturnFNode, CurrentNode) ->
	%gets the touple that connects current node with the lowest value node that has not been backtraveled from
	V2Travel = getEdge(MyList,CurrentNode,ReturnFNode + 1),
	case V2Travel of
		%In the case of travel being stuck, backtrack to last vertex and try again
		{-1,-1} -> 
			case CurrentNode of
				Path1 -> eulerHelp(PathT, [{Path1, Path2}|MyList], CurrentNode, Path2);

				Path2 -> eulerHelp(PathT, [{Path1, Path2}|MyList], CurrentNode, Path1)
			end;
		%In case that there is a possible edge/touple to travel down, take it
		{FirstEl,LastEl} -> 
			case CurrentNode of
				FirstEl -> eulerHelp([V2Travel|[{Path1, Path2}|PathT]],removeFlipItem(MyList,V2Travel), -1, LastEl);
			
				LastEl -> eulerHelp([V2Travel|[{Path1, Path2}|PathT]],removeFlipItem(MyList,V2Travel), -1, FirstEl)
			end
	end.



%This function removes a touple from a list of touples, disregarding the ordering of the items in the touples
removeFlipItem([{H1, H2}|T],{I1, I2}) when (I1 == H1) and (I2 == H2) -> T;
removeFlipItem([{H1, H2}|T],{I1, I2}) when (I2 == H1) and (I1 == H2) -> T;
%This part of the function is for when there is no match
removeFlipItem([{H1, H2}|T],{I1, I2}) -> [{H1, H2}|removeFlipItem(T,{I1, I2})].



%returns the edge you can travel on from your vetex to another of minimum value, that is at least Min to avoid going up backtracked paths
getEdge(MyList,Vertex, Min) ->
	%Get list of unused touples that travel away from current vertex
	FilterList = lists:sort(filterEdges(MyList,Vertex, Min)),
	case FilterList of
		%case that we are stuck return 'stuck' to original function
		[] -> {-1,-1};

	%use the first touple as the list has been sorted acording to the vertex we are traveling to(therefore keeping minimum consistant)
		_ -> hd(FilterList)
	end.
	



%filters out list so only remaining touples are connected to the vertex we are currently at
%ending case
filterEdges([],_,_) -> [];
%checks the two different possible combinations of valid edges/touples
filterEdges([{H1, H2}|T], Vertex, Min) when (H1 == Vertex) and (H2 >= Min) -> [{H2,H1}|filterEdges(T,Vertex,Min)]; %H2 and H1  are flipped for sorting
filterEdges([{H1, H2}|T], Vertex, Min) when (H2 == Vertex) and (H1 >= Min) -> [{H1,H2}|filterEdges(T,Vertex,Min)];
%This is an else liek statement for when tehre is no match
filterEdges([{_, _}|T], Vertex, Min) -> filterEdges(T,Vertex, Min).
	



%calls helper function to create all unique dominoes with a maximum half value of N
dominoes(N) -> dominoesHelp(N,N).

%case where all dominoes are generated
dominoesHelp(0, 0) -> [{0,0}|[]];
%case where M is 0, so decrease N and restart
dominoesHelp(N, 0) -> [{N,0}|dominoesHelp(N-1,N-1)];
%case to decrease M	
dominoesHelp(N, M) -> [{N,M}|dominoesHelp(N,M-1)].



%function flips the touples in a list of touples as to make the side element of one touple match
% the side element of the one next to it.
flip(MyList) -> 
	%gets values fo first two touples
	{First, Second} = hd(MyList),
	{Third, Fourth} = hd(tl(MyList)),
	%case checks if first touple is in correct orientation then calls recursive call, or flips first.
	case Second of
		Third -> [{First, Second } | flipHelper(Second,tl(MyList))];

		Fourth -> [{First, Second } | flipHelper(Second,tl(MyList))];
	
		_ -> [{Second, First } | flipHelper(First,tl(MyList))]

	end.


%helper function for flip, does the final cases of recursive call
flipHelper(Second, [{Third, Fourth}|[]]) when Second == Third -> [{Third, Fourth}|[]];
flipHelper(Second, [{Third, Fourth}|[]]) when Second == Fourth -> [{Fourth, Third}|[]];
%helper function for flip, does the recursive calls, flipping the touples if needed
flipHelper(Second, [{Third, Fourth}|T]) when Second == Third -> [{Third, Fourth} | flipHelper(Fourth, T)];
flipHelper(Second, [{Third, Fourth}|T]) when Second == Fourth -> [{Fourth, Third} | flipHelper(Third, T)].
	
