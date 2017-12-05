module Main exposing (..)
-- ----------------------------------------------------------------------------------------------------------------------
-- IMPORT
-- ----------------------------------------------------------------------------------------------------------------------
import Html exposing (table, thead,h1,b, tbody, a, li,ul, tr, td, text, input, label, fieldset, div, form, button, Html, program,img,p,h5,span,i,hr,option,select)
import Html.Events exposing (onSubmit, onInput, onClick, on)
import Html.Attributes exposing (type_, placeholder,href, value, required, style, min,height,src,class,id,target)
import Http exposing (post, send, get,jsonBody,Request,Body,expectJson,request,header)
import Json.Decode exposing (string,int, field, float, list, Decoder,map6,keyValuePairs, nullable)
import Regex exposing (..)
import Aliases exposing (..)
import Encodes exposing (..)
import Decodes exposing (..)
import Functions exposing (..)
import Get exposing (..)
import Model exposing (..)
import Portas exposing (..)
import Post exposing (..)
import Type exposing(..)
import Update exposing (..)
import View exposing (..)
-- ----------------------------------------------------------------------------------------------------------------------
-- INIT
-- ----------------------------------------------------------------------------------------------------------------------
init : Model
init = Model
    (DadosUsuario "" "" "" "" "" "")
    (Stock 0 "" 0 Nothing "" 0 "")
    [] [] "" "" [] []
    (SerieAtual 0 "" 0 Nothing "" 0 "")
    (AiringToday 0 "" 0 Nothing "" 0 "")
    [Temporadas 0 0 "" "" 0]
    [Episodios 0 0 ""]
    [Generos 0 ""]
    ""
    (SeriesGenero "" 0)
    [SeriesGenero "" 0]
    PagIndex
-- ----------------------------------------------------------------------------------------------------------------------
-- MAIN
-- ----------------------------------------------------------------------------------------------------------------------
main =
  program 
    { 
        init = (init, getGeneros)
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
    }
-- ----------------------------------------------------------------------------------------------------------------------
-- 
-- ----------------------------------------------------------------------------------------------------------------------