module SeriesPopulares exposing (..)

import Html exposing (table, thead, tbody, tr, td, text, input, label, fieldset, div, form, button, Html, program,img,p,h5,span,i)
import Html.Events exposing (onSubmit, onInput, onClick, on)
import Html.Attributes exposing (type_, placeholder, value, required, style, min,height,src,class,id)
import Http exposing (post, send, get,jsonBody,Request,Body,expectJson,request,header)
import Json.Decode exposing (string,int, field, float, list, Decoder,map6,keyValuePairs, nullable)
import Regex exposing (..)
import Aliases exposing (..)
import Encodes exposing (..)
import Decodes exposing (..)

type alias Model =
  {
        mensagem : String
      , populares : List Populares
    --   , idSerie : String
      , temporadas : (List Temporadas)
      , serieFinal : Serie
  }


init : Model
init = 
    let
        popular = Populares 0 "" 0.0 (Just "") "" 0.0 ""
    in
    Model "" [] [] (Serie popular [])

getPopulares : Cmd Msg
getPopulares = send Resposta <| get ("https://api.themoviedb.org/3/tv/popular?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=en-US&page=1") decodePopulares

getTemporadas : String -> Cmd Msg
getTemporadas valor = send RespostaTemp <| get ("https://api.themoviedb.org/3/tv/" ++ valor ++ "?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=en-US") decodeTemporadas

type Msg 
  = Resposta (Result Http.Error (List Populares))
  | CadSerie Populares
  | ResCadSerie (Result Http.Error Int)
--   | BuscaTemporadas (Result Http.Error (List Temporadas))
--   | SubmitTemporada
  | SubmitTemporada Int
  | RespostaTemp (Result Http.Error (List Temporadas))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Resposta resp ->
            case resp of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok lista -> ({model | populares = lista, mensagem = "ok" }, Cmd.none)
                
        CadSerie popular ->
            (model, Http.send ResCadSerie <| post "https://meangirls-raquelvilione.c9users.io/serie/inserir" (jsonBody (encodePopulares popular)) int)
            
        ResCadSerie resposta ->
            case resposta of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok lista -> (model, Cmd.none)
                
        -- SubmitTemporada -> 
        --     let
        --         lstRequestTemporadas = List.map getTemporadas (List.map (\pop -> toString pop.id_) lista)
        --     in
        --     (model, get)
        
        SubmitTemporada id ->
            (model, getTemporadas <| toString id)
                
        RespostaTemp x ->
            case x of
                Err y -> ({model | mensagem = "hioyioshjdf"}, Cmd.none)
                Ok y  -> ({model | temporadas = y}, Cmd.none)

tiraAspas : String -> String
tiraAspas palavra = String.filter (\x -> x /= '\"') palavra

viewPopulares : Populares ->  Html Msg
viewPopulares popular =
    div [class "item"] [ 
        div [class "tutor-block"] [
            div [class "tutor-img"] [
                img [src ("http://image.tmdb.org/t/p/w185/" ++  (tiraAspas <| toString <| Maybe.withDefault "" popular.poster))] []
            ]
            ,button [onClick <| SubmitTemporada popular.id_] [text "oi"]
        ]
    ]

view : Model -> Html Msg
view model =
    div [] [
    div [] (List.map viewPopulares model.populares)
    , div [] [text <| model.mensagem]
    , div [] [text <| toString model.temporadas]
    ]
    
main =
  program 
    { 
        init = (init, getPopulares)
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
    }