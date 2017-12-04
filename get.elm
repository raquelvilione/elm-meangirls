module Get exposing (..)
-- ----------------------------------------------------------------------------------------------------------------------
-- IMPORT
-- ----------------------------------------------------------------------------------------------------------------------
import Html exposing (table, thead,h1,b, tbody, a, li,ul, tr, td, text, input, label, fieldset, div, form, button, Html, program,img,p,h5,span,i,hr,option,select)
import Html.Events exposing (onSubmit, onInput, onClick, on)
import Html.Attributes exposing (type_, placeholder,href, value, required, style, min,height,src,class,id,target)
import Http exposing (post, send, get,jsonBody,Request,Body,expectJson,request,header)
import Json.Decode exposing (string,int, field, float, list, Decoder,map6,keyValuePairs, nullable)
import Regex exposing (..)
import Decodes exposing (..)
import Functions exposing (..)
import Type exposing (..)
-- ----------------------------------------------------------------------------------------------------------------------
-- GET
-- ----------------------------------------------------------------------------------------------------------------------
getStocks : String -> Cmd Msg
getStocks symb = send RespostaSearch <| get ("https://api.themoviedb.org/3/search/tv?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=pt-BR&query=" ++ (mudaString symb)) decodeStock

getPopulares : Cmd Msg
getPopulares = send RespostaSeriesPopulares <| get ("https://api.themoviedb.org/3/tv/popular?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=pt-BR") decodePopulares

getAiringToday : Cmd Msg
getAiringToday = send RespostaAiringToday <| get ("https://api.themoviedb.org/3/tv/airing_today?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=pt-BR") decodePopulares

getTemporadas : String -> Cmd Msg
getTemporadas valor = send RespostaTemp <| get ("https://api.themoviedb.org/3/tv/" ++ valor ++ "?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=en-US") decodeTemporadas

getEpisodios : (String, String) -> Cmd Msg
getEpisodios (x,y) = send RespostaEps <| get ("https://api.themoviedb.org/3/tv/" ++ x ++ "/season/" ++ y ++ "?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=pt-BR") decodeEpisodios

getGeneros : Cmd Msg
getGeneros = send RespostaG <| get ("https://api.themoviedb.org/3/genre/tv/list?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=pt-BR") decodeGeneros

getSeriesGenero : String -> Cmd Msg
getSeriesGenero s = send RespostaSG <| get ("https://api.themoviedb.org/3/discover/tv?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=pt-BR&sort_by=popularity.desc&with_genres=" ++ s ++ "&include_null_first_air_dates=false") decodeSeriesGenero
-- ----------------------------------------------------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------------------------------------------------