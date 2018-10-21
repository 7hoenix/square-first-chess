module Session exposing (Session, init)

import Browser.Navigation as Nav


type Session
    = Guest Nav.Key


init : Nav.Key -> Session
init key =
    Guest key
