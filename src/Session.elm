module Session exposing (Session, init, navKey)

import Browser.Navigation as Nav


type Session
    = Guest Nav.Key


init : Nav.Key -> Session
init key =
    Guest key


navKey : Session -> Nav.Key
navKey session =
    case session of
        Guest key ->
            key
