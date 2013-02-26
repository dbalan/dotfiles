
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

ws_eclipse = "3:eclipse"
ws_im = "8:pidgin"

myWorkspaces = ["1:emacs","2:terminal",ws_eclipse,"4:eclipse-2","5:firefox","6:chrome","7:mail",ws_im,"9:gitk","0:misc","-","="]
isFullscreen = (== "fullscreen")

-- myManageHook :: ManageHook
myManageHook = composeAll
                 -- Don't tile GNOME Do
               [ resource  =? "Do"   --> doIgnore
               , className =? "Emacs" --> doShift "1:emacs"
               , resource  =? "gnome-terminal" --> doShift "2:terminal"
               , className =? "Eclipse" --> doShift ws_eclipse
               , (className =? "Firefox" <||> className =? "Opera") --> doShift "5:firefox"
               , (className =? "Google-chrome" <||> className =? "Chromium-browser") --> doShift "6:chrome"
               , className =? "Thunderbird" --> doShift "7:mail"
               , className =? "Pidgin" --> doShift ws_im
               , className =? "Gitk" --> doShift "9:gitk"
               , className =? "Xmessage"  --> doFloat
               ]

 -- LAYOUTS

-- basicLayout = Tall nmaster delta ratio where
--     nmaster = 1
--     delta   = 3/100
--     ratio   = 1/2
-- tallLayout = named "tall" $ basicLayout
-- wideLayout = named "wide" $ Mirror basicLayout
-- singleLayout = named "single" $ avoidStruts $ noBorders Full
pidginLayout = withIM ratio roster chatLayout where
    chatLayout      = Grid ||| simpleTabbed
    ratio           = (1 % 6)
    roster          = (Role "buddy_list")
myLayoutHook =  avoidStruts $ eclipse $ pidgin $ normal 
  where
    normal = Full           
    eclipse = onWorkspace ws_eclipse Full
    pidgin = onWorkspace ws_im pidginLayout   
 

--main = do  
--   xmproc <- spawnPipe "/usr/bin/xmobar /home/dhananjay/.xmobarrc"  

   --spawn "xcompmgr -Cf"  
  -- xmonad $ azertyConfig  
  --   { manageHook = manageDocks <+> myManageHook -- make sure to include myManageHook definition from above  
  --           <+> manageHook defaultConfig  
  --   , layoutHook = avoidStruts $ eclipse $ pidgin $ normal 
  --where
  --  normal = Full           
  --  eclipse = onWorkspace ws_eclipse Full
  --  pidgin = onWorkspace ws_im pidginLayout 
    
  --  , logHook = dynamicLogWithPP xmobarPP  
  --           { ppOutput = hPutStrLn xmproc  
  --           , ppTitle = xmobarColor "#2CE3FF" "" . shorten 50  
  --              , ppLayout = const "" -- to disable the layout info on xmobar  
  --           }  
  --   , modMask = mod4Mask  
  --    , workspaces     = myWorkspaces  
  --   , normalBorderColor = "#60A1AD"  
  --   , focusedBorderColor = "#68e862"  
  --    , borderWidth    = 2  
  --   }`additionalKeys`

  --myKeys = [ ((mod1Mask, xK_space), spawn "exe=`dmenu_run -b -nb black -nf yellow -sf yellow` && eval \"exec $exe\"") -- spawn dmenu 
    --  , ((mod4Mask, xK_Return), spawn "gnome-terminal") ] -- spawn terminator terminal ]
      --, ((mod4Mask, xK_w), spawn "google-chrome")    
      --, ((mod4Mask, xK_q), kill) -- to kill app  
      --, ((mod4Mask, xK_x), spawn "xchat")  
      --, ((mod4Mask, xK_f), spawn "thunar")
      --, ((mod4Mask .|. shiftMask, xK_c), spawn "gnome-session-quit")  
      ---- , ((0, xK_Help), spawn "/home/lulz/scripts/xmonad.open") -- hit a button to open the xmonad.hs file  
      ---- , ((mod4Mask, xK_m), spawn "/home/lulz/scripts/mpd.run") -- hit a button to run mpd with ncmpcpp  
      --, ((mod4Mask .|. shiftMask, xK_F4), spawn "sudo shutdown -h now") -- to shutdown  
      --, ((mod4Mask .|. shiftMask, xK_r), spawn "sudo reboot") -- to restart  
      --, ((controlMask, xK_space), spawn "exe=`hotrecoll` && eval \"exec $exe\"") -- play/pause mpd  
      --, ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 3%-") -- decrease volume  
      --, ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 3%+") -- increase volume  
      --, ((mod4Mask .|. shiftMask, xK_l), spawn "slimlock")  
      --, ((0, xF86XK_AudioMute), spawn "amixer set Master toggle") -- mute volume  
      --, ((controlMask .|. shiftMask, xK_Right), spawn "ncmpcpp next") -- play next song in mpd  
      --, ((controlMask .|. shiftMask, xK_Left), spawn "ncmpcpp prev") -- play previous song  
      --, ((mod4Mask, xK_a ), windows W.swapUp) -- swap up window  
      --, ((mod4Mask, xK_z ), windows W.swapDown) -- swap down window  
      --, ((mod4Mask, xK_KP_Add ), sendMessage (IncMasterN 1)) -- increase the number of window on master pane  
      --, ((mod4Mask, xK_KP_Subtract ), sendMessage (IncMasterN (-1))) -- decrease the number of window  
      --, ((controlMask,        xK_Right   ), sendMessage Expand) -- expand master pane  
      --, ((controlMask,        xK_Left   ), sendMessage Shrink) -- shrink master pane  

      ---- , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s") -- capture screenshot of focused window       
      ----, ((0, xK_Print), spawn "scrot") -- capture screenshot of full desktop  
      ----, ((0, xF86XK_HomePage), spawn "iron") -- run iron  
      ----, ((mod4Mask, xK_p), spawn "/home/lulz/scripts/pidgin.open")  
      --]
     -- `removeKeys`     -- keys to remove  
     -- [ (mod4Mask .|. shiftMask, xK_c)  
     --, (mod4Mask .|. shiftMask, xK_j)  
     -- , (mod4Mask .|. shiftMask, xK_k)  
     -- , (mod4Mask, xK_j)  
     -- , (mod4Mask, xK_k)  
     -- , (mod4Mask, xK_h)  
     -- , (mod4Mask, xK_l)  
     -- , (mod4Mask, xK_comma)  
     -- , (mod4Mask, xK_period)  
     -- ]`additionalMouseBindings`  
     -- [--((mod4Mask, button4),\_-> nextWS)  
     -- --,((mod4Mask, button5),\_-> prevWS)  
     -- ((mod4Mask, button4),\_-> spawn "amixer set Master 3%+")  
     -- ,((mod4Mask, button5),\_-> spawn "amixer set Master 3%-")  
     -- ,((mod4Mask, button3),\_-> return())  
     -- ,((mod4Mask, button1),\_-> return())  
     -- ]


alt key = "M1-" ++ key
win key = "M-" ++ key

myKeys =
  [ (win "<Space>", spawn "gnome-do")
  , (win "l", spawn "xflock4")
  , (win "`", sendMessage NextLayout)
  , (win "w", spawn "google-chrome")
    -- , ("M-S-`", setLayout $ XMonad.layoutHook baseConf)

    -- use classic "WIN"+TAB
  , (win "<Tab>", windows W.focusDown)
  , (win "S-<Tab>", windows W.focusUp)

    -- mac-ish windows
  , (win "q", kill) -- kil the current app
  
    -- moving workspaces
  , ("C-S-<Left>", prevWS)
  , ("C-S-<Right>", nextWS)
  , (win "S-<Left>", shiftToPrev)
  , (win "S-<Right>", shiftToNext)
  ]
main :: IO ()
main = do 
  xmproc <- spawnPipe "/usr/bin/xmobar /home/dhananjay/.xmobarrc"  

  xmonad $ baseConf
                           { terminal    = "gnome-terminal"
                           , manageHook = manageHook baseConf <+> myManageHook
                           , modMask     = mod4Mask
                           , focusFollowsMouse = False
                           , workspaces = myWorkspaces
                           , layoutHook = myLayoutHook
                           }
                           `additionalKeysP` myKeys

