import XMonad
import XMonad.Config.Azerty
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import Graphics.X11.ExtraTypes.XF86
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders(smartBorders)
import XMonad.Layout.PerWorkspace
import XMonad.Layout.IM
import XMonad.Layout.Grid
--import XMonad.Actions.GridSelect
import Data.Ratio ((%))
import XMonad.Actions.CycleWS
import qualified XMonad.StackSet as W
import System.IO
import XMonad.Actions.CycleWS
import XMonad.Config.Gnome
import XMonad.Util.EZConfig
import qualified XMonad.StackSet as W
import XMonad.Actions.Promote

import XMonad.Layout.IM
import Data.Ratio ((%))
import XMonad.Layout.Grid
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Hooks.ManageDocks (avoidStruts)
import XMonad.Actions.CopyWindow

baseConf = gnomeConfig

myWorkspaces = ["1:terminal","2:browser","3:editor","4:runtime","5:files","6:music","7:graphics","8:im","9:misc","0:misc","-","="]
isFullscreen = (== "fullscreen")

myManageHook = composeAll

               [ resource  =?   "Synapse"   --> doIgnore
               , className =?   "Thunar"    --> doShift "5:files"
               , className =?   "Emacs"   --> doShift "3:editor"
               , resource  =?   "gnome-terminal"    --> doShift "1:terminal"
               , className =? "Terminator" --> doShift "1:terminal"
               , className =?   "Eclipse" --> doShift "3:editor"
               , (className =?  "Firefox" <||> className =? "Opera") --> doShift "2:browser"
               , (className =?  "Google-chrome" <||> className =? "Chromium-browser") --> doShift "2:browser"
               , className =? "Thunderbird" --> doShift "8:mail"
               , className =? "Pidgin" --> doShift "8:im"
               , className =? "Gitk" --> doShift "9:gitk"
               , className =? "Xmessage"  --> doFloat
               , className =? "qemu" --> doFloat
               , className =? "eadbeef" --> doShift "6:music"
               , className =? "Deadbeef" --> doShift "6:music"
               , className =? "Sublime Text 2" --> doShift "3:editor"
               ]




myLayoutHook =  avoidStruts $ terminal $ runtime $ normal
  where
    terminal = onWorkspace "1:terminal" Full
    runtime = onWorkspace "4:runtime" (halftiled ||| Full)
    normal = (tiled ||| Full)
    tiled       = Tall nmaster delta ratio
    halftiled   = Tall nmaster delta halfratio

    -- default number of windows in the master pane
    nmaster     = 1

    -- default proportion of screen occupied by master pane
    ratio      = toRational (2/(1+sqrt(5)::Double))  -- golden ratio
    halfratio = 1/2

    -- Percent of screen to increment by when resizing panes
    delta      = 0.05

-- Run xmobar

myLogHook d = dynamicLogWithPP xmobarPP
	{ ppOutput = hPutStrLn d
	,  ppTitle = xmobarColor "#2CE3FF" "" . shorten 50
	, ppLayout = const "" -- to disable the layout info on xmobar
        }

trayerConfig = "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand false --width 70 --widthtype pixel --transparent true --tint 0x000000 --alpha 1 --height 17"

xmobarConfig = "xmobar /home/dhananjay/.xmobarrc"

alt key = "M1-" ++ key
win key = "M-" ++ key

myKeys =
  [ (win "<Space>", spawn "synapse")
  , (win "`", sendMessage NextLayout)

  , (win "w", spawn "google-chrome")
  , (win "t", spawn "terminator")
  , (win "f", spawn "thunar")
  , (win "e", spawn "subl")
  , (win "m", spawn "deadbeef")

  -- use classic "WIN"+TAB
  , (win "<Tab>", windows W.focusDown)
  , (win "S-<Tab>", windows W.focusUp)

  -- mac-ish windows
  , (win "q", kill) -- kil the current app
  , ("C-S-q", spawn "gnome-session-quit")

  -- Promoting the master pane
  , (win "p", promote)
  -- moving workspaces
  , ("C-S-<Left>", prevWS)
  , ("C-S-<Right>", nextWS)
  , (win "S-<Left>", shiftToPrev)
  , (win "S-<Right>", shiftToNext)
  ]

main :: IO ()
main = do
  d <- spawnPipe xmobarConfig
  trayer <- spawnPipe trayerConfig

  xmonad $ baseConf
                           { terminal    = "terminator"
                           , manageHook = manageHook baseConf <+> myManageHook
                           , modMask     = mod4Mask
                           , focusFollowsMouse = False
                           , workspaces = myWorkspaces
                           , layoutHook = myLayoutHook
			   , logHook = myLogHook d
                           }
                           `additionalKeysP` myKeys
