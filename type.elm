module Type exposing (..)
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
-- ----------------------------------------------------------------------------------------------------------------------
-- TYPE
-- ----------------------------------------------------------------------------------------------------------------------
type Msg
    = Nome String
    | Sobrenome String
    | Email String
    | Senha String
    | ConfirmarSenha String
    | RespostaCadastro (Result Http.Error (Http.Response String))
    | CadastrarUsuario DadosUsuario
    | RespostaLogin (Result Http.Error Int)
    | Login DadosUsuario
    | SubmitSearch
    | SymbolSearch String
    | RespostaSearch (Result Http.Error (List Stock))
    | CadastrarSerie Stock
    | ResCadastrarSerie (Result Http.Error Int)
    | RespostaSeriesPopulares (Result Http.Error (List Populares))
    | CadSeriePopulares Populares
    | ResCadSeriesPopulares (Result Http.Error Int)
    | RespostaAiringToday (Result Http.Error (List AiringToday))
    | CadSerieAiringToday AiringToday
    | ResCadSerieAiringToday (Result Http.Error Int)
    | MudarPagina Pagina
    | VerSerie Populares
    | SubmitTemporada Int
    | RespostaTemp (Result Http.Error (List Temporadas))
    | SubmitEpisodios Int Int
    | RespostaEps (Result Http.Error (List Episodios))
    | RespostaG (Result Http.Error (List Generos))
    | GeneroEscolhido String
    | Buscar
    | RespostaSG (Result Http.Error (List SeriesGenero))

type Pagina = PagIndex | PagCadastro | PagValidation | PagLogin | PagStock | PagSerie | PagSerieGenero
-- ----------------------------------------------------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------------------------------------------------
