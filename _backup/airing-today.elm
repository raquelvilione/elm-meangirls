module AiringToday exposing (..)

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
      , airingtoday: List AiringToday
  }

init : Model
init = Model "" []

getAiringToday : Cmd Msg
getAiringToday = send Resposta <| get ("https://api.themoviedb.org/3/tv/airing_today?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=en-US&page=1") decodePopulares

type Msg 
  = Resposta (Result Http.Error (List AiringToday))
  | CadSerie AiringToday
  | ResCadSerie (Result Http.Error Int)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Resposta resp ->
            case resp of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok lista -> ({model | airingtoday = lista, mensagem = "ok"}, Cmd.none)
            
        CadSerie airingtodayy ->
            (model, Http.send ResCadSerie <| post "https://meangirls-raquelvilione.c9users.io/serie/inserir" (jsonBody (encodeAiringToday airingtodayy)) int)
            
        ResCadSerie resposta ->
            case resposta of
                Err x -> ({ model | mensagem = toString x}, Cmd.none)
                Ok lista -> (model, Cmd.none)

tiraAspas : String -> String
tiraAspas palavra = String.filter (\x -> x /= '\"') palavra
    
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
    div [id "owl-airingtoday", class "owl-carousel owl-theme"] (List.map viewAiringToday model.airingtoday)
    
main =
  program 
    { 
        init = (init, getAiringToday)
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
    }