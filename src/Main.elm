module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation as Nav
import Colophon
import Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import GA
import Gallery
import GetStarted
import Html.Attributes as HA
import Intro
import Task
import Types exposing (NavItem)
import UI
import Url


type alias WindowSize =
    { width : Int, height : Int }


type alias Flags =
    { isMobile : Bool
    , windowSize : WindowSize
    }


type alias Model =
    { navKey : Nav.Key
    , url : Url.Url
    , introModel : Intro.Model
    , device : UI.Device
    }


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | IntroMsg Intro.Msg
    | ScrollTo Float
    | WindowResized Int Int
    | NoOp


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        ( downloadModel, downloadCmd ) =
            Intro.init
    in
    ( { url = url
      , navKey = navKey
      , introModel = downloadModel
      , device = UI.classifyDevice flags.isMobile flags.windowSize
      }
    , Cmd.map IntroMsg downloadCmd
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IntroMsg subMsg ->
            let
                ( newIntroModel, downloadCmd ) =
                    Intro.update subMsg model.introModel
            in
            ( { model | introModel = newIntroModel }
            , Cmd.map IntroMsg downloadCmd
            )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    let
                        id =
                            url.path |> String.replace "/" ""

                        getSectionY =
                            if id == Intro.navItem.id then
                                Task.succeed 0

                            else
                                Browser.Dom.getElement id
                                    |> Task.map (\{ element } -> element.y)

                        scroll =
                            getSectionY
                                |> Task.attempt
                                    (Result.map (\it -> it - headerHeight model.device + headerStroke)
                                        >> Result.map ScrollTo
                                        >> Result.withDefault NoOp
                                    )
                    in
                    ( model
                    , Cmd.batch
                        [ Nav.pushUrl model.navKey (Url.toString url)
                        , scroll
                        ]
                    )

                Browser.External href ->
                    ( model
                    , Cmd.batch
                        [ Nav.load href
                        , if String.contains "download" href then
                            GA.download ()

                          else
                            Cmd.none
                        ]
                    )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        ScrollTo y ->
            ( model
            , Browser.Dom.setViewport 0 y
                |> Task.perform (always NoOp)
            )

        NoOp ->
            ( model, Cmd.none )

        WindowResized w h ->
            ( { model
                | device = UI.classifyDevice model.device.isMobile { width = w, height = h }
              }
            , Cmd.none
            )


headerHeight : UI.Device -> number
headerHeight device =
    case device.class of
        UI.Phone ->
            0

        _ ->
            50


headerStroke =
    2


header : UI.Device -> List NavItem -> Element msg
header device navItems =
    if device.class == UI.Phone then
        none

    else
        let
            viewNavItems items =
                items
                    |> List.map
                        (\{ label, id } ->
                            UI.link []
                                { url = "/" ++ id
                                , label = text label
                                }
                        )
        in
        row
            [ spaceEvenly
            , Background.color Color.background
            , Border.widthEach { top = 2, bottom = 2, left = 0, right = 0 }
            , Border.color Color.black
            , centerY
            , height <| px (headerHeight device)
            , width fill
            , paddingXY (UI.pageMargin device) 0
            , alignTop
            ]
            [ el [] <| text "GlyphCollector"
            , row [ Font.size 16, spacing 20 ] <|
                (viewNavItems navItems
                    ++ [ UI.newTabLink []
                            { url = "https://github.com/krksgbr/glyphcollector"
                            , label = text "GitHub"
                            }
                       ]
                )
            ]


view : Model -> Browser.Document Msg
view model =
    let
        sections =
            [ .intro
            , .getStarted
            , .gallery
            , .colophon
            ]

        sectionConfig =
            { intro =
                { nav = Intro.navItem
                , view =
                    Intro.view model.device model.introModel
                        |> Element.map IntroMsg
                }
            , getStarted =
                { nav = GetStarted.navItem
                , view = GetStarted.view model.device
                }
            , colophon =
                { nav = Colophon.navItem
                , view = Colophon.view model.device
                }
            , gallery =
                { nav = Gallery.navItem
                , view = Gallery.view model.device
                }
            }

        getSectionProp prop section =
            sectionConfig |> (section >> prop)
    in
    { title = "GlyphCollector"
    , body =
        [ Element.layout
            [ htmlAttribute <| HA.style "font-family" "whoismono"
            , Background.color Color.background
            , sections
                |> List.map (getSectionProp .nav)
                |> header model.device
                |> inFront
            ]
          <|
            Element.column
                [ width fill
                , paddingEach
                    { top = headerHeight model.device
                    , left = 0
                    , right = 0
                    , bottom = 0
                    }
                ]
            <|
                List.map (getSectionProp .view) sections
        ]
    }


subscriptions _ =
    Sub.batch
        [ Browser.Events.onResize WindowResized
        ]


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
