module Donate exposing (..)

import Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html as H
import Types exposing (NavItem)
import UI


navItem : NavItem
navItem =
    { id = "donate"
    , label = "Donate"
    }


view device =
    let
        donateButton txt url =
            newTabLink []
                { url = url
                , label =
                    UI.button
                        [ Background.color Color.white
                        , Font.color Color.black
                        , mouseOver
                            [ Background.color Color.green
                            ]
                        , focused
                            [ Border.color Color.transparent
                            ]
                        , width fill
                        ]
                        { onPress = Nothing
                        , label = text txt
                        }
                }
    in
    UI.section device
        [ width fill
        , Background.color Color.accent
        , Font.color Color.white
        , UI.id navItem.id
        ]
    <|
        column [ width fill ]
            [ el [ Font.bold ] <|
                UI.sectionTitle device.class "Donate"
            , paragraph [ paddingEach { bottom = 30, top = 0, left = 0, right = 0 } ]
                [ text "The development of GlyphCollector depends on the support of its community."
                , html <| H.br [] []
                , text "Please consider making a donation."
                , html <| H.br [] []
                , text "Donations of fonts are also welcome :)"
                ]
            , paragraph []
                []
            , column [ width fill, spacing 10 ]
                [ donateButton "Make a donation" "https://useplink.com/payment/kbEX893ImxPbV4oFV46g/"
                ]
            ]
