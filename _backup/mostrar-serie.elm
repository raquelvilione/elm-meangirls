module ProcurarSerie exposing (..)

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
      symbol : String
      , stocks : List Stock
      , temporadas : List Temporadas
  }

init : Model
init = Model "" []

getStocks : String -> Cmd Msg
getStocks symb = send Resposta <| get ("https://api.themoviedb.org/3/search/tv?api_key=45167e2360d3bc4cac7f0e985b36bae5&query=" ++ (mudaString symb)) decodeStock

getTemporadas : String -> Cmd Msg
getTemporadas idS = send RespostaDecTemp <| get ("https://api.themoviedb.org/3/tv/" ++ idS ++ "?api_key=45167e2360d3bc4cac7f0e985b36bae5&language=en-US") decodeTemp


type Msg 
  = Submit
  | Symbol String
  | Resposta (Result Http.Error (List Stock))
  | CadSerie Stock
  | ResCadSerie (Result Http.Error Int)
  | GetTemporada String
  | RespostaDecTemp (Result Http.Error (List Temporadas))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Symbol digitado ->
            ({ model | symbol = digitado }, Cmd.none)

        Submit ->
            (model, getStocks model.symbol)

        Resposta resp ->
            case resp of
                Err x -> ({ model | symbol = toString x}, Cmd.none)
                Ok lista -> ({model | stocks = lista}, Cmd.none)
        
        CadSerie stock ->
            (model, Http.send ResCadSerie <| post "https://meangirls-raquelvilione.c9users.io/serie/inserir" (jsonBody (encodeSerie stock)) int)
            
        ResCadSerie resposta ->
            case resposta of
                Err x -> ({ model | symbol = toString x}, Cmd.none)
                Ok lista -> ({model | symbol = toString lista}, Cmd.none)
                
        GetTemporada idSerie ->
            (model, getTemporadas idSerie)
            
        RespostaDecTemp r ->
            case r of
                Err x -> ({ model | symbol = toString x}, Cmd.none)
                Ok listaTemps -> ({model | temporadas = toString listaTemps}, Cmd.none)
        

tiraAspas : String -> String
tiraAspas palavra = String.filter (\x -> x /= '\"') palavra

mudaString = replace All (Regex.regex " ") (\_ -> "%20")

viewStock : (Stock) -> Html Msg
viewStock (stock) =
    div [class "col-lg-4 col-md-4 col-sm-6 col-xs-12 mb30"] [ 
        div [class "tutor-block"] [
            div [class "tutor-img"] [
                img [src ("http://image.tmdb.org/t/p/w185/" ++  (tiraAspas <| toString <| Maybe.withDefault "" stock.poster))] []
            ]
            , div [class "tutor-content"] [
                h5 [class "tutor-title"] [text <| tiraAspas <| toString stock.nome]
                , span [class "tutor-designation"] [text <| toString stock.mediaNota]
                , p [] []
                , div [] [button [onClick (GetTemporada (tiraAspas <| toString stock.id_))] [text "+"]]
            ]
        ]
    ]

view : Model -> Html Msg
view model =
    div []
        [ form [class "form-search", onSubmit Submit]
            [ 
                div [class "input-group"] [
                    input [class "input-custom", type_ "text", required True, placeholder "Pesquisar", onInput Symbol] []
                    , span [class "input-group-btn"] [
                        button [] [
                            i [class "fa fa-search"] []
                        ]
                    ]
                ]
            ]
                , div [] (List.map viewStock model.stocks)
        ]

main =
  program 
    { 
        init = (init, Cmd.none)
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
    }







