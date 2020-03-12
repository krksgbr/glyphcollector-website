module Colophon exposing (..)

import Element exposing (..)
import Html as H
import Types exposing (NavItem)
import UI


navItem : NavItem
navItem =
    { label = "Colophon"
    , id = "colophon"
    }


view : UI.Device -> Element msg
view device =
    let
        link txt url =
            UI.newTabLink UI.underLine
                { url = url
                , label = text <| txt
                }
    in
    UI.section device
        [ UI.id navItem.id
        ]
    <|
        column []
            [ UI.sectionTitle device.class navItem.label
            , column [ spacing 20 ]
                [ paragraph []
                    [ text "GlyphCollector is being developed by "
                    , link "Gábor Kerekes" "https://krks.info"
                    , text ". Its initial prototype was made for the Renaissance module of "
                    , link "Dr. Frank Blokland" "https://www.lettermodel.org/ "
                    , text " in the LetterStudio class at The Royal Academy of Art, The Hague. "
                    ]
                , paragraph []
                    [ text " GlyphCollector's user interface and this website was designed by "
                    , link "Dóra Kerekes" "http://www.dorakerekes.info/"
                    , text " and "
                    , link "Noémi Biró." "http://noemibiro.com/"
                    , text " Both the interface and this website uses the "
                    , link "Whois mono" "https://github.com/raphaelbastide/Whois-mono/"
                    , text " font by  "
                    , link "Raphael Bastide" "https://raphaelbastide.com/"
                    , text "."
                    ]
                , paragraph []
                    [ text "If you enjoy GlyphCollector you will also like "
                    , link "Reviving Type" "http://revivingtype.com/"
                    , text ", a publication on archive research and contemporary type design by "
                    , link "Céline Hurka" "http://celinehurka.com/"
                    , text " and "
                    , link "Nóra Békés." "http://www.norabekes.nl/"
                    ]
                , paragraph []
                    [ text " For support, please "
                    , link "open a new issue on GitHub" "https://github.com/krksgbr/glyphcollector/issues/new"
                    , text ", or "
                    , link "drop by our Discord channel" "https://discord.gg/JwjZDvG"
                    , text " (no registration is necessary)."
                    ]
                ]
            ]
