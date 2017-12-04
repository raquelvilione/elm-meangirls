module Model exposing (..)
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
import Type exposing (..)
-- ----------------------------------------------------------------------------------------------------------------------
-- MODEL
-- ----------------------------------------------------------------------------------------------------------------------
type alias Model =
  {
      usuario : DadosUsuario
    , pesqserie : Stock
    , seriespopulares : List Populares
    , seriesairingtoday : List AiringToday
    , mensagem : String
    , symbol : String
    , stocks : List Stock
    , serieAtual : SerieAtual
    , airingtoday : AiringToday
    , temporadas : List Temporadas
    , episodios : List Episodios
    , generos : List Generos
    , generoEscolhido : String
    , genero : Generos
    , seriesGenero : List SeriesGenero
    , view : Pagina
  }
-- ----------------------------------------------------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------------------------------------------------