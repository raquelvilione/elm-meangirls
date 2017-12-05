module BuscaTemporadas exposing (..)

import Html exposing (table, thead, tbody, tr, td, text, input, label, fieldset, div, form, button, Html, program,img,p,h5,span,i,select,option)
import Html.Events exposing (onSubmit, onInput, onClick, on)
import Html.Attributes exposing (type_, placeholder, value, required, style, min,height,src,class,id,disabled)
import Http exposing (post, send, get,jsonBody,Request,Body,expectJson,request,header)
import Json.Decode exposing (string,int, field, float, list, Decoder,map6,keyValuePairs, nullable)
import Regex exposing (..)
import Aliases exposing (..)
import Encodes exposing (..)
import Decodes exposing (..)


-- import Html.Events.Extra exposing (..)

type alias Model =
  {
        mensagem : String
      , temporadas : List Temporadas
      , generoEscolhido : String
      , seriesGenero : List SeriesGenero
  }

init : Model
init = Model "" [] "" []

getGeneros : Cmd Msg
getGeneros = send RespostaG <| get ("https://api.themoviedb.org/3/genre/tv/list?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=pt-BR") decodeGeneros

getSeriesGenero : String -> Cmd Msg
getSeriesGenero s = send RespostaSG <| get ("https://api.themoviedb.org/3/discover/tv?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=pt-BR&sort_by=popularity.desc&with_genres=" ++ s ++ "&include_null_first_air_dates=false") decodeSeriesGenero

type Msg 
  = RespostaG (Result Http.Error (List Generos))
    | GeneroEscolhido String
    | Buscar
    | RespostaSG (Result Http.Error (List SeriesGenero))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        RespostaG resp ->
            case resp of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok lista -> ({model | generos = lista, mensagem = "ok"}, Cmd.none)
        
        GeneroEscolhido g ->
            ({ model | generoEscolhido = g }, Cmd.none)
        
        Buscar ->
            (model, getSeriesGenero model.generoEscolhido)
        
        RespostaSG r ->
            case r of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok l -> ({model | seriesGenero = l, mensagem = "blz"}, Cmd.none)
            

tiraAspas : String -> String
tiraAspas palavra = String.filter (\x -> x /= '\"') palavra

viewGeneros : (Generos) -> Html Msg
viewGeneros (genero) =
    option [value <| toString genero.id] [text genero.nome]

viewStock : (SeriesGenero) -> Html Msg
viewStock (model) =
    div [class "col-lg-4 col-md-4 col-sm-6 col-xs-12 mb30"] [ 
        div [class "tutor-block"] [
             div [class "tutor-content"] [
                h5 [class "tutor-title"] [text <| tiraAspas <| toString model.nome]
                , span [class "tutor-designation"] [text <| toString model.id]
            ]
        ]
    ]

view : Model -> Html Msg
view model =
    div [] [
    select [onInput GeneroEscolhido] (List.map viewGeneros model.generos)
    , button [onClick (Buscar)] [text "ok"]
    , p [] [text model.mensagem]
    , div [] (List.map viewStock model.seriesGenero)
    ]
    
    
main =
  program 
    { 
        init = (init, getGeneros)
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
    }