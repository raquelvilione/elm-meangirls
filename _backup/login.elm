module LoginUsuario exposing (..)

import Html exposing (table, thead, tbody, tr, td, text, input, label, fieldset, div, form, button, Html, program,img,p,h5,span,i)
import Html.Events exposing (onSubmit, onInput, onClick, on)
import Html.Attributes exposing (type_, placeholder, value, required, style, min,height,src,class)
import Http exposing (post, send, get,jsonBody,Request,Body,expectJson,request,header)
import Json.Decode exposing (string,int, field, float, list, Decoder,map6,keyValuePairs, nullable)
import Regex exposing (..)
import Aliases exposing (..)
import Encodes exposing (..)
import Decodes exposing (..)

type alias Model =
  {
      email : String
    , senha : String
    , mensagem : String
  }

init : Model
init  = Model "" "" ""

type Msg
    =  Email String
    | Senha String
    | Resposta (Result Http.Error Int)
    | Login Model

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
      Email x ->
        ({ model | email = x }, Cmd.none)
  
      Senha x ->
         ({ model | senha = x }, Cmd.none)
        
      Resposta resp ->
         case resp of
            Err x -> ({ model | mensagem = toString x}, Cmd.none)
            -- Ok lista -> ({model | dados = lista}, Cmd.none)
            Ok x -> ({ model | mensagem = "LOGADO" }, Cmd.none)

      Login dados ->
          (model, Http.send Resposta <| post "https://meangirls-raquelvilione.c9users.io/login/" (jsonBody (encodeDadosUsuario model.email model.senha)) decodeRespLogin)

view : Model -> Html Msg
view model =
  div [class "col-md-4 col-md-offset-4 col-xs-12"]
    [
    input [class "input-custom-register", type_ "text", placeholder "Email", onInput Email] []
    , input [class "input-custom-register", type_ "password", placeholder "Senha", onInput Senha ] []
    , button [class "btn-padrao",  onClick (Login model)] [text "Login"]
    , div [] [text model.mensagem]
    ]
    
main =
  program 
    { 
      init = (init, Cmd.none)
      , view = view
      , update = update
      , subscriptions = \_ -> Sub.none
    }