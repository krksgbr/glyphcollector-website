module Intro exposing (..)

import Color
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html.Attributes as HA
import Http
import Json.Decode as JD
import Types exposing (NavItem)
import UI


type alias Release =
    { tag : String
    , assets : List String
    }


type alias Asset =
    { url : String
    , tag : String
    }


type alias Downloads =
    { win : Maybe Asset
    , mac : Maybe Asset
    , linux : Maybe Asset
    }


type Data
    = Loading
    | Loaded Downloads
    | Error


type alias Model =
    Data


type Msg
    = GotDownloads (Result Http.Error Downloads)


decodeReleases : JD.Decoder (List Release)
decodeReleases =
    let
        decodeRelease =
            JD.map2
                (\t a ->
                    { tag = t, assets = a }
                )
                (JD.field "tag_name" JD.string)
                (JD.field "assets" <| JD.list <| JD.field "browser_download_url" JD.string)
    in
    JD.list decodeRelease


findDownloads : List Release -> Downloads
findDownloads releases =
    releases
        |> List.sortBy (\{ tag } -> tag)
        |> List.foldl
            (\a b ->
                let
                    find s { tag, assets } =
                        assets
                            |> List.filter (String.toLower >> String.contains s)
                            |> List.head
                            |> Maybe.map (\url -> { tag = tag, url = url })
                in
                { win = find "exe" a :: b.win
                , mac = find "mac" a :: b.mac
                , linux = find "deb" a :: b.linux
                }
            )
            { win = [], mac = [], linux = [] }
        |> (\{ win, mac, linux } ->
                let
                    pluck =
                        List.filterMap identity >> List.head
                in
                { win = pluck win
                , mac = pluck mac
                , linux = pluck linux
                }
           )


init =
    ( Loading
    , Http.get
        { url = "https://api.github.com/repos/krksgbr/glyphcollector/releases"
        , expect =
            Http.expectJson GotDownloads
                (decodeReleases
                    |> JD.map findDownloads
                )
        }
    )


update : Msg -> Model -> ( Data, Cmd Msg )
update msg model =
    case msg of
        GotDownloads downloads ->
            ( downloads
                |> Result.map Loaded
                |> Result.withDefault Error
            , Cmd.none
            )


navItem : NavItem
navItem =
    { label = "Download"
    , id = "download"
    }


viewRelease data =
    let
        buttons downloads =
            [ ( "macOS", downloads.mac )
            , ( "Windows", downloads.win )
            , ( "Linux", downloads.linux )
            ]
                |> List.filterMap
                    (\( label, maybeDownload ) ->
                        maybeDownload |> Maybe.map (\download -> ( label, download ))
                    )
                |> List.map
                    (\( label, { url, tag } ) ->
                        link []
                            { url = url
                            , label =
                                UI.button []
                                    { label =
                                        column []
                                            [ el [ centerX ] <| text <| label
                                            , el
                                                [ Font.size 12
                                                , centerX
                                                ]
                                              <|
                                                text tag
                                            ]
                                    , onPress = Nothing
                                    }
                            }
                    )
    in
    case data of
        Loaded release ->
            column
                [ spacing 20 ]
                [ el [] <| text <| "Download the latest version:"
                , row [ spacing 10 ] <| buttons release
                , el [ Font.size 13 ] <|
                    UI.newTabLink UI.underLine
                        { url = "https://github.com/krksgbr/glyphcollector/releases"
                        , label = text "Older versions"
                        }
                ]

        Loading ->
            text ""

        Error ->
            text ""


viewIntroText fontSize =
    paragraph [ Font.size fontSize ]
        [ text "GlyphCollector is a desktop application for typeface revival projects both as a production and research tool."
        ]


viewFundLogo attrs logoSize =
    column attrs
        [ text "Made possible by the support of:"
        , newTabLink []
            { url = "https://stimuleringsfonds.nl/en/"
            , label =
                image [ width <| px logoSize ]
                    { src = "/stimuleringsfonds_black.svg"
                    , description = "stimuleringsfonds logo"
                    }
            }
        ]


viewAppLogo attrs =
    image attrs
        { src = "/temp_1024x1024_Black_transparency.png"
        , description = "logo"
        }


view : UI.Device -> Data -> Element msg
view device model =
    let
        defaultLayout { introTextSize } =
            row [ width fill, spacing 50 ]
                [ column [ alignTop, spacing 50, width <| fillPortion 2 ]
                    [ viewIntroText introTextSize
                    , if device.isMobile then
                        none

                      else
                        viewRelease model
                    , viewFundLogo [ spacing 10 ] 200
                    ]
                , viewAppLogo [ alignTop, width fill ]
                ]

        layout =
            case ( device.class, device.orientation ) of
                ( UI.Phone, _ ) ->
                    column [ width fill, spacing 30 ]
                        [ viewAppLogo [ width <| px 150 ]
                        , viewIntroText 25
                        , viewFundLogo [ Font.size 15, spacing 10 ] 100
                        ]

                ( UI.Tablet, _ ) ->
                    defaultLayout { introTextSize = 25 }

                _ ->
                    defaultLayout { introTextSize = 30 }
    in
    UI.section device [] <|
        column
            [ htmlAttribute <| HA.id "download"
            , width fill
            , spacing 75
            ]
        <|
            [ layout ]
