module Gallery exposing (..)

import Element exposing (..)
import Types exposing (NavItem)
import UI


navItem : NavItem
navItem =
    { id = "gallery"
    , label = "Gallery"
    }


view : UI.Device -> Element msg
view device =
    UI.section device [ UI.id "gallery" ] <|
        column []
            [ UI.sectionTitle device.class "Gallery"
            , paragraph []
                [ text "If you have an interesting project in which you're making use of GlyphCollector, and would like to feature it on this website, please get in touch: krks.gbr@gmail.com"
                ]
            ]
