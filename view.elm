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
                        , a [class "navbar-brand title-tvbox", href "#"][text "tvbox",text model.mensagem]
                    ]
                    , div [class "collapse navbar-collapse"]
                        (if (model.usuario.loginToken /= "") then
                            [ul [class "nav navbar-nav navbar-right"]
                                [ viewSearch model
                                ,li [] [ a [href "#", onClick (MudarPagina PagStock)]       [text "Home"]]
                                ,li [] [ a [href "#", onClick (MudarPagina PagMinhaLista)]  [text "Minha Lista"]]
                                ,li [] [ a [href "#", onClick (MudarPagina PagLogin)]       [text "Sair"]]]
                            , div [id "genres-select", class "navbar-form navbar-right"] [
                                    div [class "form-group"] [
                                        select [onInput GeneroEscolhido] (List.map viewGeneros model.generos)
                                    ]
                                ]
                            ]
                        else
                            [ul [class "nav navbar-nav navbar-right"]
                                [ li [] [ a [href "#", onClick (MudarPagina PagLogin)]      [text "Login"]]
                                , li [] [ a [href "#", onClick (MudarPagina PagCadastro)]   [text "Cadastro"]]
                                ]
                            ])
                        ]
                    ]
                ]
        , case model.view of
            PagCadastro -> viewCadastro model
            PagValidation -> viewValidation model
            PagLogin -> viewLogin model
            PagSearch -> viewStock2 model
            PagStock -> div [] [viewPopulares2 model, viewAiringToday2 model]
            PagIndex -> viewIndex model
            PagSerie -> viewSerie model
            PagSerieGenero -> viewSeriesGenero model
            PagMinhaLista -> viewMinhaLista2 model
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
-- ---------------------------------------------------------
-- LOGIN USUÁRIO
-- ---------------------------------------------------------
viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if model.usuario.senha == model.usuario.confirmarSenha then
        ("green", "")
      else
        ("white", "As senhas são diferentes!")
  in
    div [ style [("color", color), ("text-align","center"),("margin-top","10px")] ] [ text message ]
    
viewLogin : Model -> Html Msg
viewLogin model =
  div [class "container align"] [
    h1 [class "title-tvbox text-center"] [text "tvbox"]
    , form [class "col-md-4 col-md-offset-4 col-xs-12", onSubmit (Login model.usuario)]
        [
        input [class "input-custom-register", type_ "text", required True, value model.usuario.email, placeholder "Email", onInput Email] []
        , input [class "input-custom-register", type_ "password", required True, value model.usuario.senha, placeholder "Senha", onInput Senha ] []
        , button [class "btn-padrao"] [text "Login"]
        ]
   ]
-- ---------------------------------------------------------
-- STOCK
-- ---------------------------------------------------------    
viewStock : Stock -> Html Msg
viewStock stock =
        div [class "col-lg-4 col-md-4 col-sm-6 col-xs-12 mb30"] [ 
            div [class "tutor-block resultados"] [
                div [class "tutor-img"] [
                    img [src ("http://image.tmdb.org/t/p/w185/" ++  (tiraAspas <| toString <| Maybe.withDefault "" stock.poster))] []
                ]
                , div [class "tutor-content"] [
                    h5 [class "tutor-title"] [text <| tiraAspas <| toString stock.nome]
                    , div [] [a [href "#"] [button [class "btn-ver", onClick (VerSerie stock)] [text "Visualizar"]]]
                    -- , div [] [button [onClick (CadastrarSerie stock)] [text "+"]]
                ]
            ]
        ]
viewStock2 : Model -> Html Msg
viewStock2 model =
    div [class "espac"] [
        div [class "container"] [
            h1 [class "title-tvbox"] [text "SÉRIES"]
        ]
        , div [] (List.map viewStock model.stocks)
    ]
-- --------------------------------------------------------- 
-- PESQUISA
-- ---------------------------------------------------------    
viewSearch : Model -> Html Msg
viewSearch model =
    div [class "container"] [
        div []
            [ form [class "form-search", onSubmit SubmitSearch]
                [ 
                    div [class "input-group"] [
                        input [class "input-custom", type_ "text", required True, placeholder "Pesquisar", onInput SymbolSearch] []
                        , span [class "input-group-btn"] [
                            button [] [
                                i [class "fa fa-search"] []
                            ]
                        ]
                    ]
                ]
                --    , div [] (List.map viewStock model.stocks)
            ]
    ]
-- ---------------------------------------------------------
-- POPULARES
-- ---------------------------------------------------------        
viewPopulares : Populares -> Html Msg
viewPopulares popular =
    div [class "item"] [ 
        div [class "tutor-block project wow animated animated4 fadeInLeft"] [
            div [class "tutor-img"] [
                img [src ("http://image.tmdb.org/t/p/w185/" ++  (tiraAspas <| toString <| Maybe.withDefault "" popular.poster))] []
                , div [class "project-hover"] [
                    h1 [class "title-item-carousel"] [text <| tiraAspas <| toString popular.nome]
                    , hr [] []
                    , p [] []
                    , button [class "ver-mais", onClick (VerSerie popular)] [text "visualizar"]
                ]
            ]
        ]
    ]

viewPopulares2 : Model -> Html Msg
viewPopulares2 model =
    div [class "espac"] [
        div [class "container"] [
            h1 [class "title-tvbox"] [text "AS MAIS POPULARES"]
        ]
        , div [id "owl-populares", class "owl-carousel owl-theme"] (List.map viewPopulares model.seriespopulares)
    ]
-- ---------------------------------------------------------
-- EPÍSODIOS
-- ---------------------------------------------------------
viewEpisodios : Int -> Html Msg
viewEpisodios idE =
    div [class "episodio"] [text ("Episódio " ++ (tiraAspas <| toString idE))]
-- ---------------------------------------------------------
-- TEMPORADAS
-- ---------------------------------------------------------
viewTemporada : Temporadas -> Html Msg
viewTemporada model =
    div [class "row temporada"] [
        div [class "col-lg-3 col-md-3 col-sm-3 col-xs-12"] [
            img [class "img-responsive", src ("http://image.tmdb.org/t/p/w185/" ++  (tiraAspas <| toString model.poster_path))] []
        ]
        , div [class "col-lg-9 col-md-9 col-sm-9 col-xs-12"] [
            h1 [] [text ("TEMPORADA " ++ (tiraAspas <| toString model.season_number))]
            , p [] [text ("Número de episódios: " ++ (tiraAspas <| toString model.episode_count))]
            -- , div [] [button [onClick (SubmitEpisodios 1402 model.season_number)] [text "Visualizar Episodios"]]
            , div [] (List.map viewEpisodios (List.range 1 model.episode_count))
        ]
    ]
-- ---------------------------------------------------------
-- SÉRIE
-- ---------------------------------------------------------
viewSerie : Model -> Html Msg
viewSerie model = 
    div [] [
    div [id "mostra-serie"] [
    div [class "container"] [
        div [class "col-lg-3 col-md-3 col-sm-3 col-xs-12"] [ 
            div [class "tutor-img"] [
                img [class "img-responsive", src ("http://image.tmdb.org/t/p/w185/" ++  (tiraAspas <| toString <| Maybe.withDefault "" model.serieAtual.poster))] []
            ]
        ]
        , div [class "col-lg-9 col-md-9 col-sm-9 col-xs-12"] [
            div [class "col-lg-12"] [
                    h5 [class "tutor-title"] [text <| tiraAspas <| toString model.serieAtual.nome]
                    
                   , div [id "rate"] [
                    img [class "img-responsive", src ("/imagens/favorite.png")] []
                    , span [class "tutor-designation"] [text <| toString model.serieAtual.mediaNota]
                    ]
                ]
            , div [class "col-lg-12 sinopse"] [
                p [] [text <| tiraAspas <| toString model.serieAtual.sinopse]
                , div [] [button [onClick (CadastrarSerie model.serieAtual)] [text "Adicionar a minha lista"]]
                -- , div [] [button [onClick (SubmitTemporada model.serieAtual.id_)] [text "Visualizar Temporadas"]]
            ]
        ]
    ]
    ]
    , div [class "page-scroll text-center"] [
                    h1 [] [text "Visualizar Temporadas"]
                    , a [href "#temporadas", class "btn btn-circle", onClick (SubmitTemporada model.serieAtual.id_)] [
                        i [class "fa fa-angle-down fa-2x animated"] []
                    ]
                ]
    , div [id "temporadas", class "container"] (List.map viewTemporada model.temporadas)
    ]
-- ---------------------------------------------------------
-- AIRING TODAY
-- ---------------------------------------------------------
viewAiringToday : AiringToday -> Html Msg
viewAiringToday airingtodayy =
    div [class "item"] [ 
        div [class "tutor-block project wow animated animated4 fadeInLeft"] [
            div [class "tutor-img"] [
                img [src ("http://image.tmdb.org/t/p/w185/" ++  (tiraAspas <| toString <| Maybe.withDefault "" airingtodayy.poster))] []
                , div [class "project-hover"] [
                    h1 [class "title-item-carousel"] [text <| tiraAspas <| toString airingtodayy.nome]
                    , hr [] []
                    , button [class "ver-mais", onClick (VerSerie airingtodayy)] [text "visualizar"]
                ]
            ]
        ]
    ]

viewAiringToday2 : Model -> Html Msg
viewAiringToday2 model =
    div [class "espac"] [
        div [class "container"][
            h1 [class "title-tvbox"] [text "NO AR HOJE"]
        ]
        , div [id "owl-airingtoday", class "owl-carousel owl-theme"] (List.map viewAiringToday model.seriesairingtoday)
    ]
-- ---------------------------------------------------------
-- GÊNEROS
-- ---------------------------------------------------------
viewGeneros : (Generos) -> Html Msg
viewGeneros (genero) =
    option [value <| toString genero.id] [text genero.nome]

viewSeriesG : Generos -> Html Msg
viewSeriesG model =
        div [class "col-lg-4 col-md-4 col-sm-6 col-xs-12 mb30"] [ 
            div [class "tutor-block"] [
                div [class "tutor-block"] [
                     div [class "tutor-content"] [
                        h5 [class "tutor-title"] [text <| tiraAspas <| toString model.nome]
                        , span [class "tutor-designation"] [text <| toString model.id]
                    ]
                ]
            ]
        ]

viewSeriesGenero : Model -> Html Msg
viewSeriesGenero model =
        div [] (List.map viewSeriesG model.seriesGenero)
-- ---------------------------------------------------------
-- MINHA LISTA
-- ---------------------------------------------------------    
viewMinhaLista : Stock -> Html Msg
viewMinhaLista stock =
        div [class "col-lg-4 col-md-4 col-sm-6 col-xs-12 mb30"] [ 
            div [class "tutor-block resultados"] [
                div [class "tutor-img"] [
                    img [src ("http://image.tmdb.org/t/p/w185/" ++  (tiraAspas <| toString <| Maybe.withDefault "" stock.poster))] []
                ]
                , div [class "tutor-content"] [
                    h5 [class "tutor-title"] [text <| tiraAspas <| toString stock.nome]
                    , div [] [a [href "#"] [button [class "btn-ver", onClick (VerSerie stock)] [text "Visualizar"]]]
                    -- , div [] [button [onClick (CadastrarSerie stock)] [text "+"]]
                ]
            ]
        ]
viewMinhaLista2 : Model -> Html Msg
viewMinhaLista2 model =
    div [class "espac"] [
        div [class "container"] [
            h1 [class "title-tvbox"] [text "MINHA LISTA"]
        ]
        , div [] (List.map viewMinhaLista model.minhalista)
    ]
-- ----------------------------------------------------------------------------------------------------------------------
--
-- ----------------------------------------------------------------------------------------------------------------------