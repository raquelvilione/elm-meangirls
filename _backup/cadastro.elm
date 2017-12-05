module CadastroUsuario exposing (..)

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
      nome : String
    , sobrenome : String
    , email : String
    , senha : String
    , confirmarSenha : String
  }

init : Model
init  = Model "" "" "" "" ""

type Msg
    = Nome String
    | Sobrenome String
    | Email String
    | Senha String
    | ConfirmarSenha String
    | Resposta (Result Http.Error Int)
    | CadastrarUsuario Model

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
      Nome x ->
         ({ model | nome = x}, Cmd.none)
      
      Sobrenome x ->
         ({ model | sobrenome = x}, Cmd.none)
      
      Email x ->
        ({ model | email = x }, Cmd.none)
  
      Senha x ->
         ({ model | senha = x }, Cmd.none)
  
      ConfirmarSenha x ->
         ({ model | confirmarSenha = x }, Cmd.none)
        
      Resposta resp ->
         case resp of
            Err x -> (model, Cmd.none)
            -- Ok lista -> ({model | dados = lista}, Cmd.none)
            Ok x -> (model, Cmd.none)
      
      CadastrarUsuario dados ->
          (model, Http.send Resposta <| post "https://meangirls-raquelvilione.c9users.io/usuario/inserir" (jsonBody (encodeUsuario dados)) int)

view : Model -> Html Msg
view model =
  div [class "col-md-4 col-md-offset-4 col-xs-12"]
    [ input [class "input-custom-register", type_ "text", placeholder "Nome", onInput Nome ] []
    , input [class "input-custom-register", type_ "text", placeholder "Sobrenome", onInput Sobrenome] []
    , input [class "input-custom-register", type_ "text", placeholder "Email", onInput Email] []
    , input [class "input-custom-register", type_ "password", placeholder "Senha", onInput Senha ] []
    , input [class "input-custom-register", type_ "password", placeholder "Confirme sua senha", onInput ConfirmarSenha ] []
    , button [class "btn-padrao",  onClick (CadastrarUsuario model)] [text "Cadastrar"]
    , viewValidation model
    ]

viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if model.senha == model.confirmarSenha then
        ("green", "")
      else
        ("white", "As senhas são diferentes!")
  in
    div [ style [("color", color), ("text-align","center"),("margin-top","10px")] ] [ text message ]
    
main =
  program 
    { 
      init = (init, Cmd.none)
      , view = view
      , update = update
      , subscriptions = \_ -> Sub.none
    }