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
  , airingtoday: List AiringToday
  }

init : Model
init = Model "" [] 

getPopulares : Cmd Msg
getPopulares = send Resposta1 <| get ("https://api.themoviedb.org/3/tv/popular?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=pt-BR&page=1") decodePopulares

getAiringToday : Cmd Msg
getAiringToday = send Resposta2 <| get ("https://api.themoviedb.org/3/tv/airing_today?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=en-US&page=1") decodePopulares

type Msg 
  = Resposta1 (Result Http.Error (List Populares))
  | Resposta2 (Result Http.Error (List AiringToday))
  | CadSerieP Populares
  | CadSerieA AiringToday
  | ResCadSerie (Result Http.Error Int)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of

        Resposta1 resp ->
            case resp of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok lista -> ({model | populares = lista, mensagem = "ok"}, Cmd.none)
                
        Resposta2 resp ->
            case resp of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok lista -> ({model | airingtoday = lista, mensagem = "ok"}, Cmd.none)
        
        CadSerieP popular ->
            (model, Http.send ResCadSerie <| post "https://meangirls-raquelvilione.c9users.io/serie/inserir" (jsonBody (encodePopulares popular)) int)
            
        CadSerieA airingtoday ->
            (model, Http.send ResCadSerie <| post "https://meangirls-raquelvilione.c9users.io/serie/inserir" (jsonBody (encodeAiringToday airingtoday)) int)
            
        ResCadSerie resposta ->
            case resposta of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok lista -> (model, Cmd.none)

tiraAspas : String -> String
tiraAspas palavra = String.filter (\x -> x /= '\"') palavra

viewPopulares : (Populares) -> Html Msg
viewPopulares (popular) =
    div [class "item"] [ 
        div [class "tutor-block"] [
            div [class "tutor-img"] [
                img [src ("http://image.tmdb.org/t/p/w185/" ++  (tiraAspas <| toString <| Maybe.withDefault "" popular.poster))] []
            ]
        ]
    ]
    
viewAiringToday : (AiringToday) -> Html Msg
viewAiringToday (airingtodayy) =
    div [class "item"] [ 
        div [class "tutor-block"] [
            div [class "tutor-img"] [
                img [src ("http://image.tmdb.org/t/p/w185/" ++  (tiraAspas <| toString <| Maybe.withDefault "" airingtodayy.poster))] []
            ]
        ]
    ]

view : Model -> Html Msg
view model =
    div [id "owl-populares", class "owl-carousel owl-theme"] (List.map viewPopulares model.populares)
    div [id "owl-populares", class "owl-carousel owl-theme"] (List.map viewAiringToday model.populares)
    
main =
  program 
    { init = (init, getPopulares, getAiringToday)
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }