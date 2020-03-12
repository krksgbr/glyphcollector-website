module GetStarted exposing (..)

import Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html as H
import Html.Attributes as HA
import Types exposing (NavItem)
import UI


navItem : NavItem
navItem =
    { label = "Getting Started"
    , id = "getting-started"
    }


images =
    List.range 1 7
        |> List.map (\it -> "/step_" ++ String.fromInt it ++ "_t-01.svg")


view device =
    let
        headingFontSize =
            case device.class of
                UI.Phone ->
                    20

                _ ->
                    30

        heading t =
            el
                [ Border.widthEach { top = 1, left = 0, bottom = 0, right = 0 }
                , width fill
                , paddingXY 0 10
                , Font.size headingFontSize
                , Font.color Color.white
                , Border.color Color.white
                ]
            <|
                text t
    in
    UI.section device
        [ Background.color Color.darkBackground
        , UI.id navItem.id
        ]
    <|
        column [ Font.color Color.white, width fill ]
            [ UI.sectionTitle device.class navItem.label
            , column [ spacing 30 ] <|
                List.indexedMap
                    (\i im ->
                        column
                            [ spacing 10
                            ]
                            [ heading <| "Step " ++ (String.fromInt <| i + 1)
                            , image [ width fill ] { src = im, description = "" }
                            ]
                    )
                    images
            , column [ width fill, spacing 30 ]
                [ heading "An example workflow"
                , el [ centerX ] <|
                    html <|
                        let
                            dimensions =
                                if device.width >= 560 then
                                    Just ( 560, 315 )

                                else
                                    Nothing
                        in
                        H.iframe
                            ((dimensions
                                |> Maybe.map
                                    (\( w, h ) ->
                                        [ HA.width w, HA.height h ]
                                    )
                                |> Maybe.withDefault []
                             )
                                ++ [ HA.src
                                        "https://www.youtube.com/embed/eG9wsK8WNs4"
                                   , HA.attribute "frameborder" "0"
                                   , HA.attribute "allow" "accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
                                   , HA.attribute "allowfullscreen" "true"
                                   ]
                            )
                            []
                ]
            ]
