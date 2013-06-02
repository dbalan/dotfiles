
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

import XMonad.Layout.IM
import Data.Ratio ((%))
import XMonad.Layout.Grid
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Hooks.ManageDocks (avoidStruts)
import XMonad.Actions.CopyWindow

baseConf = gnomeConfig

myWorkspaces = ["1:terminal","2:browser","3:editor","4:runtime","5:files","6:runtime","7:graphics","8:mail","9:misc","0:misc","-","="]
isFullscreen = (== "fullscreen")

myManageHook = composeAll
                 -- Don't tile GNOME Do
               [ resource  =? "Do"   --> doIgnore
               , className =? "Emacs" --> doShift "3:editor"
               , resource  =? "gnome-terminal" --> doShift "1:terminal"
               , className =? "Eclipse" --> doShift "3:editor"
               , (className =? "Firefox" <||> className =? "Opera") --> doShift "2:browser"
               , (className =? "Google-chrome" <||> className =? "Chromium-browser") --> doShift "2:browser"
               , className =? "Thunderbird" --> doShift "8:mail"
               , className =? "Pidgin" --> doShift "8:mail"
               , className =? "Gitk" --> doShift "9:gitk"
               , className =? "Xmessage"  --> doFloat
               , className =? "qemu" --> doFloat
               , className =? "terminator" --> doShift "1:terminal"
               ]

pidginLayout = withIM ratio roster chatLayout where
    chatLayout      = Grid ||| simpleTabbed
    ratio           = (1 % 6)
    roster          = (Role "buddy_list")
myLayoutHook =  avoidStruts $ eclipse $ pidgin $ normal
  where
    normal = Full
    eclipse = onWorkspace "3:editor" Full
    pidgin = onWorkspace "8:mail" pidginLayout

-- Run xmobar

myLogHook d = dynamicLogWithPP xmobarPP
	{ ppOutput = hPutStrLn d
	,  ppTitle = xmobarColor "#2CE3FF" "" . shorten 50
	, ppLayout = const "" -- to disable the layout info on xmobar
        }



alt key = "M1-" ++ key
win key = "M-" ++ key

myKeys =
  [ (win "<Space>", spawn "synapse")
  , (win "`", sendMessage NextLayout)

  , (win "w", spawn "google-chrome")
  , (win "t", spawn "terminator")
  , (win "f", spawn "thunar")

  , ("M-S-`", setLayout $ XMonad.layoutHook baseConf)

  -- use classic "WIN"+TAB
  , (win "<Tab>", windows W.focusDown)
  , (win "S-<Tab>", windows W.focusUp)

  -- mac-ish windows
  , (win "q", kill) -- kil the current app
  , ("C-S-q", spawn "gnome-session-quit")
  -- moving workspaces
  , ("C-S-<Left>", prevWS)
  , ("C-S-<Right>", nextWS)
  , (win "S-<Left>", shiftToPrev)
  , (win "S-<Right>", shiftToNext)
  ]

main :: IO ()
main = do
  d <- spawnPipe $ "xmobar /home/dhananjay/.xmobarrc"

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

