module View exposing (..)
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
import Model exposing (..)
import Portas exposing (..)
import Type exposing (..)
-- ----------------------------------------------------------------------------------------------------------------------
-- VIEW
-- ----------------------------------------------------------------------------------------------------------------------
view : Model -> Html Msg
view model = 
    div [] [
        Html.header [id "header", class "headroom"] [
            div [class "navbar navbar-fixed-top navbar-inverse"][
                div [class "container-fluid"][
                    div [class "navbar-header"][
                        button [class "navbar-toggle", type_ "button"][
                             span [class "icon-bar"][]
                             , span [class "icon-bar"][]
                             , span [class "icon-bar"][]
                        ]
                        , a [class "navbar-brand title-tvbox", href "#"][text "tvbox"]
                    ]
                    , div [class "collapse navbar-collapse"][
                        ul [class "nav navbar-nav navbar-right"][
                            li [] [ a [href "#", onClick (MudarPagina PagLogin)]      [text "Login"]]
                            , li [] [ a [href "#", onClick (MudarPagina PagCadastro)]      [text "Cadastro"]]
                            , li [] [ a [href "#", onClick (MudarPagina PagStock)]      [text "Logado"]]
                            -- , li [] [ a [href "#sair"]  [span [class "glyphicon glyphicon-off"] [b [] [text "SAIR"]]]]
                        ]
                        , div [id "genres-select", class "navbar-form navbar-right"] [
                            div [class "form-group"] [
                            select [onInput GeneroEscolhido] (List.map viewGeneros model.generos)
                            ]
                            , button [onClick (Buscar)] [i [class "fa fa-search"] []]
                        ]
                    ]
                ]
            ]
        ]
        , case model.view of
            PagCadastro -> viewCadastro model
            PagValidation -> viewValidation model
            PagLogin -> viewLogin model
            PagStock -> div [] [viewSearch model, viewPopulares2 model, viewAiringToday2 model]
            PagIndex -> viewIndex model
            PagSerie -> viewSerie model
            PagSerieGenero -> viewSeriesGenero model
    ]
-- ---------------------------------------------------------
-- INDEX
-- ---------------------------------------------------------
viewIndex : Model -> Html Msg
viewIndex model = 
    span [][]
-- ---------------------------------------------------------
-- CADASTRO USUÁRIO
-- ---------------------------------------------------------
viewCadastro : Model -> Html Msg
viewCadastro model =
  div [class "container align"] [
     h1 [class "title-tvbox text-center"] [text "cadastro"]
     , div [class "col-md-4 col-md-offset-4 col-xs-12"]
        [ input [class "input-custom-register", type_ "text", required True, placeholder "Nome", onInput Nome ] []
        , input [class "input-custom-register", type_ "text", required True, placeholder "Sobrenome", onInput Sobrenome] []
        , input [class "input-custom-register", type_ "text", required True, placeholder "Email", onInput Email] []
        , input [class "input-custom-register", type_ "password", required True, placeholder "Senha", onInput Senha ] []
        , input [class "input-custom-register", type_ "password", required True, placeholder "Confirme sua senha", onInput ConfirmarSenha ] []
        , button [class "btn-padrao",  onClick (CadastrarUsuario model.usuario)] [text "Cadastrar"]
        , viewValidation model
        ]
  ]
-- ----------------------------------------------------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------------------------------------------------