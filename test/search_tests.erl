%% @author Jose Arias
%% [www.csproj13.student.it.uu.se]
%% @version 1.0
%% @copyright [Copyright information]
%%
%% @doc == streams_tests ==
%% This module contains several tests to test the functionallity
%% in the module streams which is done by calling the webbmachine.
%%
%% @end

-module(search_tests).
-include_lib("eunit/include/eunit.hrl").
-export([]).

%% @doc
%% Function: inti_test/0
%% Purpose: Used to start the inets to be able to do HTTP requests
%% Returns: ok | {error, term()}
%%
%% Side effects: Start inets
%% @end
-spec init_test() -> ok | {error, term()}.

init_test() ->
    inets:start().



%% @doc
%% Function: process_search_post_test/0
%% Purpose: Test the process_post_test function by doing some HTTP requests
%% Returns: ok | {error, term()}
%% @end
process_search_post_test() ->
        {ok, {{_Version1, 200, _ReasonPhrase1}, _Headers1, Body1}} = httpc:request(post, {"http://localhost:8000/streams", [],"application/json", "{\"test\" : \"search\",\"resource_id\" : \"0\", \"private\" : \"false\"}"}, [], []),
        {ok, {{_Version2, 200, _ReasonPhrase2}, _Headers2, Body2}} = httpc:request(post, {"http://localhost:8000/streams", [],"application/json", "{\"test\" : \"search\",\"resource_id\" : \"0\", \"private\" : \"true\"}"}, [], []),
        DocId1 = lib_json:get_field(Body1,"_id"),
        DocId2 = lib_json:get_field(Body2,"_id"),
        timer:sleep(1000),
        {ok, {{_Version3, 200, _ReasonPhrase3}, _Headers3, Body3}} = httpc:request(post, {"http://localhost:8000/_search", [],"application/json", "{\"query\":{\"match_all\":{}}}"}, [], []),
        {ok, {{_Version8, 200, _ReasonPhrase8}, _Headers8, _Body8}} = httpc:request(delete, {"http://localhost:8000/streams/" ++ lib_json:to_string(DocId1), []}, [], []),
        {ok, {{_Version9, 200, _ReasonPhrase9}, _Headers9, _Body9}} = httpc:request(delete, {"http://localhost:8000/streams/" ++ lib_json:to_string(DocId2), []}, [], []),
        ?assertEqual(true,lib_json:get_field(Body3,"streams.hits.total") >= 1).
