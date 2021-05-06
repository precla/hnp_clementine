# Copyright (C) 2006-2015 Craciun Dan (C) 2010 John Aylward
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc., 51
# Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA

use URI::Escape;
HexChat::register("HNP Clementine", "1.0.0", "HexChat Now Playing Script for 2.x, based on HNP 2.0.1");

HexChat::hook_command("TOGGLE_ALBUM", call_toggle_album);
HexChat::hook_command("TOGGLE_YEAR", call_toggle_year);
HexChat::hook_command("TOGGLE_TRACK", call_toggle_track);
HexChat::hook_command("TOGGLE_LENGTH", call_toggle_length);
HexChat::hook_command("TOGGLE_BITRATE", call_toggle_bitrate);
HexChat::hook_command("TOGGLE_SIZE", call_toggle_size);
HexChat::hook_command("TOGGLE_SHOW_MENU", call_toggle_show_menu);
HexChat::hook_command("TOGGLE_SHOW_TEXT_STYLE", call_toggle_show_text_style);
HexChat::hook_command("TOGGLE_SHOW_TEXT_COLOR", call_toggle_show_text_color);
HexChat::hook_command("BROWSER1", call_browser1);
HexChat::hook_command("BROWSER2", call_browser2);
HexChat::hook_command("BROWSER3", call_browser3);
HexChat::hook_command("BROWSER4", call_browser4);

HexChat::hook_command("HNPMUTE", cmd_hnpmute);
HexChat::hook_command("HNPVOL1", cmd_hnpvol1);
HexChat::hook_command("HNPVOL2", cmd_hnpvol2);
HexChat::hook_command("HNPVOL3", cmd_hnpvol3);
HexChat::hook_command("HNPVOL4", cmd_hnpvol4);
HexChat::hook_command("HNPVOL5", cmd_hnpvol5);
HexChat::hook_command("HNPVOL6", cmd_hnpvol6);
HexChat::hook_command("HNPVOL7", cmd_hnpvol7);
HexChat::hook_command("HNPVOL8", cmd_hnpvol8);
HexChat::hook_command("HNPVOL9", cmd_hnpvol9);
HexChat::hook_command("HNPMAX", cmd_hnpmax);
HexChat::hook_command("HNPVOL", cmd_hnpvol);
HexChat::hook_command("HNPPLAY", cmd_hnpplay);
HexChat::hook_command("HNPPAUSE", cmd_hnppause);
HexChat::hook_command("HNPSTOP", cmd_hnpstop);
HexChat::hook_command("HNPPREV", cmd_hnpprev);
HexChat::hook_command("HNPNEXT", cmd_hnpnext);
HexChat::hook_command("HNPRUN", cmd_hnprun);
HexChat::hook_command("HNPQUIT", cmd_hnpquit);

HexChat::hook_command("HNP", cmd_hnp);
HexChat::hook_command("HNPS", cmd_hnps);
HexChat::hook_command("HNPSTATS", cmd_hnpstats);
HexChat::hook_command("HNPINFO", cmd_hnpinfo);
HexChat::hook_command("ALL_ON", cmd_all_on);
HexChat::hook_command("ALL_OFF", cmd_all_off);
HexChat::hook_command("HNPMODES", cmd_hnpmodes);
HexChat::hook_command("HNPHELP", cmd_hnphelp);
HexChat::hook_command("HNPABOUT", cmd_hnpabout);

HexChat::hook_command("HNPHOME", cmd_hnphome);

#HexChat::hook_command("HNPHOWTO", cmd_hnphowto);
#HexChat::hook_command("HNPFAQ", cmd_hnpfaq);

load_messages();
load_integrity();
load_menus();

sub configFile {
return HexChat::get_info("configdir") . "/hnp.conf";
}

sub load_messages {
    HexChat::print("---");
    HexChat::print("\cC02HNP:\cC01 HNP Clementine 1.0.0 by Antonio Prcela, based on HNP 2.0.1, loaded.");
    HexChat::print("\cC02HNP:\cC01 HexChat Now Playing Script for 2.x is a Perl script that displays info about the currently playing track in and the music collection.");
    HexChat::print("\cC02HNP:\cC01 Type /HNP to use and /HNPHELP for a full list of commands.");
    HexChat::print("\cC02HNP:\cC01 For suggestions, feature requests and bug reports please contact me at github.com/precla.");
    HexChat::print("---");
}

sub load_integrity {
if (integrity_check() == 1) {
    $openval = open(CONF, ">" . configFile());
    if ($openval == 1) {
    print CONF "show_album=1\n";
    print CONF "show_year=1\n";
    print CONF "show_track=1\n";
    print CONF "show_length=1\n";
    print CONF "show_bitrate=1\n";
    print CONF "show_size=1\n";
    print CONF "show_menu=1\n";
    print CONF "show_text_style=1\n";
    print CONF "show_text_color=1\n";
    print CONF "browser=firefox\n";
    close(CONF);
    HexChat::print("\cC02HNP:\cC01 Created the HNP configuration file (" . configFile() . ") with default values.");
    return 0;
    } else {
    HexChat::print("\cC02HNP:\cC01 Could not read/create the HNP configuration file (" . configFile() . "). Please check disk space and file permissions.");
    HexChat::print("\cC02HNP:\cC01 Without the HNP configuration file, the /HNP command cannot work.");
    return 1;
    }
} else {
    return 0;
}
}

sub integrity_check {
    $openval = open(CONF, configFile());
    if ($openval == 1) {
        $is_album = 0;
        $is_year = 0;
        $is_track = 0;
        $is_length = 0;
        $is_bitrate = 0;
        $is_size = 0;
        $is_menu = 0;
        $is_browser = 0;
        $is_text_style = 0;
        $is_text_color = 0;

        while (<CONF>) {
        @array = split("=", $_);
        $opt = $array[0];
        $val = $array[1];
            chomp($opt);
            chomp($val);

            if ($opt eq "show_album") { if ($is_album == 0) { $is_album = 1; } else { close(CONF); return 1; } }
            if ($opt eq "show_year") { if ($is_year == 0) { $is_year = 1; } else { close(CONF); return 1; } }
            if ($opt eq "show_track") { if ($is_track == 0) { $is_track = 1; } else { close(CONF); return 1; } }
            if ($opt eq "show_length") { if ($is_length == 0) { $is_length = 1; } else { close(CONF); return 1; } }
            if ($opt eq "show_bitrate") { if ($is_bitrate == 0) { $is_bitrate = 1; } else { close(CONF); return 1; } }
            if ($opt eq "show_size") { if ($is_size == 0) { $is_size = 1; } else { close(CONF); return 1; } }
            if ($opt eq "show_menu") { if ($is_menu == 0) { $is_menu = 1; } else { close(CONF); return 1; } }
            if ($opt eq "show_text_style") { if ($is_text_style == 0) { $is_text_style = 1; } else { close(CONF); return 1; } }
            if ($opt eq "show_text_color") { if ($is_text_color == 0) { $is_text_color = 1; } else { close(CONF); return 1; } }
            if ($opt eq "browser") { if ($is_browser == 0) { $is_browser = 1; } else { close(CONF); return 1; } }

            if ($opt ne "show_album" && $opt ne "show_year" && $opt ne "show_track" && $opt ne "show_length" &&
            $opt ne "show_bitrate" && $opt ne "show_size" && $opt ne "show_menu" && $opt ne "show_text_style" &&
            $opt ne "show_text_color" && $opt ne "browser") {
            close(CONF); return 1;
            }

            if ($opt ne "browser" && $val != 0 && $val != 1) { close(CONF); return 1; }
            if ($opt eq "browser") {
                if ($val ne "firefox" && $val ne "epiphany" && $val ne "konqueror" && $val ne "opera") {
                    close(CONF); return 1;
                }
            }
        }

        if ($is_album == 1 && $is_year == 1 && $is_track == 1 && $is_length == 1 && $is_bitrate == 1 &&
            $is_size == 1 && $is_menu == 1 && $is_text_style == 1 && $is_text_color == 1 && $is_browser == 1) {
                close(CONF); return 0;
        } else {
            close(CONF); return 1;
        }
    } else {
        return 1;
    }
}

sub load_menus {
    if (load_integrity() == 0) {
        $openval = open(CONF, configFile());
        while (<CONF>) {
            @array = split("=", $_);
            $opt = $array[0];
            $val = $array[1];
            chomp($opt);
            chomp($val);
            if ($opt eq "show_menu") {
                if ($val == 1) {
                    HexChat::command("MENU DEL HNP");
                    HexChat::command("MENU -p6 ADD HNP");
                    HexChat::command ("MENU ADD \"HNP/Show\"");
                    HexChat::command("MENU ADD \"HNP/Show/Standard\" \"HNP\"");
                    HexChat::command("MENU ADD \"HNP/Show/Simple\" \"HNPS\"");
                    HexChat::command("MENU ADD \"HNP/Show/Stats\" \"HNPSTATS\"");
                    HexChat::command("MENU ADD \"HNP/Show/Info\" \"HNPINFO\"");
                    HexChat::command("MENU ADD \"HNP/-\"");
                    HexChat::command("MENU ADD \"HNP/Clementine\"");
                    HexChat::command("MENU ADD \"HNP/-\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Volume\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Volume/Mute\" \"HNPMUTE\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Volume/10%\" \"HNPVOL1\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Volume/20%\" \"HNPVOL2\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Volume/30%\" \"HNPVOL3\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Volume/40%\" \"HNPVOL4\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Volume/50%\" \"HNPVOL5\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Volume/60%\" \"HNPVOL6\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Volume/70%\" \"HNPVOL7\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Volume/80%\" \"HNPVOL8\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Volume/90%\" \"HNPVOL9\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Volume/Max\" \"HNPMAX\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/-\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Play\" \"HNPPLAY\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Pause\" \"HNPPAUSE\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Stop\" \"HNPSTOP\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/-\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Prev\" \"HNPPREV\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Next\" \"HNPNEXT\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/-\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Start\" \"HNPRUN\"");
                    HexChat::command("MENU ADD \"HNP/Clementine/Quit\" \"HNPQUIT\"");
                    HexChat::command("MENU ADD \"HNP/Toggle\"");
                    HexChat::command("MENU ADD \"HNP/Toggle/Album\" \"TOGGLE_ALBUM\"");
                    HexChat::command("MENU ADD \"HNP/Toggle/Year\" \"TOGGLE_YEAR\"");
                    HexChat::command("MENU ADD \"HNP/Toggle/Track\" \"TOGGLE_TRACK\"");
                    HexChat::command("MENU ADD \"HNP/Toggle/Length\" \"TOGGLE_LENGTH\"");
                    HexChat::command("MENU ADD \"HNP/Toggle/Bitrate\" \"TOGGLE_BITRATE\"");
                    HexChat::command("MENU ADD \"HNP/Toggle/Size\" \"TOGGLE_SIZE\"");
                    HexChat::command("MENU ADD \"HNP/Toggle/Text Color\" \"TOGGLE_SHOW_TEXT_COLOR\"");
                    HexChat::command("MENU ADD \"HNP/Toggle/Text Style\" \"TOGGLE_SHOW_TEXT_STYLE\"");
                    HexChat::command("MENU ADD \"HNP/Set\"");
                    HexChat::command("MENU ADD \"HNP/Set/All ON\" \"ALL_ON\"");
                    HexChat::command("MENU ADD \"HNP/Set/All OFF\" \"ALL_OFF\"");
                    HexChat::command("MENU ADD \"HNP/Set/-");
                    HexChat::command("MENU ADD \"HNP/Set/Help Browser\"");
                    HexChat::command("MENU ADD \"HNP/Set/Help Browser/Firefox\" \"BROWSER1\"");
                    HexChat::command("MENU ADD \"HNP/Set/Help Browser/Epiphany\" \"BROWSER2\"");
                    HexChat::command("MENU ADD \"HNP/Set/Help Browser/Konqueror\" \"BROWSER3\"");
                    HexChat::command("MENU ADD \"HNP/Set/Help Browser/Opera\" \"BROWSER4\"");
                    HexChat::command("MENU ADD \"HNP/View\"");
                    HexChat::command("MENU ADD \"HNP/View/Modes\" \"HNPMODES\"");
                    HexChat::command("MENU ADD \"HNP/View/-");
                    HexChat::command("MENU ADD \"HNP/View/Homepage\" \"HNPHOME\"");
                    #HexChat::command("MENU ADD \"HNP/View/HNP How-To\" \"HNPHOWTO\"");
                    #HexChat::command("MENU ADD \"HNP/View/HNP FAQ\" \"HNPFAQ\"");
                    HexChat::command("MENU ADD \"HNP/View/-");
                    HexChat::command("MENU ADD \"HNP/View/Help\" \"HNPHELP\"");
                    HexChat::command("MENU ADD \"HNP/-\"");
                    HexChat::command("MENU ADD \"HNP/About\" \"HNPABOUT\"");
                }
            }
        }
        close(CONF);
    }
    return 0;
}

sub call_toggle_album {
    cmds_toggle("show_album");
}
sub call_toggle_year {
    cmds_toggle("show_year");
}
sub call_toggle_track {
    cmds_toggle("show_track");
}
sub call_toggle_length {
    cmds_toggle("show_length");
}
sub call_toggle_bitrate {
    cmds_toggle("show_bitrate");
}
sub call_toggle_size {
    cmds_toggle("show_size");
}
sub call_toggle_show_menu {
    cmds_toggle("show_menu");
}
sub call_toggle_show_text_color {
    cmds_toggle("show_text_color");
}
sub call_toggle_show_text_style {
    cmds_toggle("show_text_style");
}
sub call_browser1 {
    cmd_browser("firefox");
}
sub call_browser2 {
    cmd_browser("epiphany");
}
sub call_browser3 {
    cmd_browser("konqueror");
}
sub call_browser4 {
    cmd_browser("opera");
}

sub cmds_toggle {
    $toggle_opt = $_[0];
    if (load_integrity() == 0) {
        $openval = open(CONF, configFile());
        $i = 0;
        while (<CONF>) {
            @array = split("=", $_);
            $opt = $array[0];
            $val = $array[1];
            chomp($opt);
            chomp($val);

            if ($toggle_opt eq $opt) {
                if ($val == 1) {
                    $ison = 1;
                } elsif ($val == 0) {
                    $ison = 0;
                }
            } else {
                $hold[$i] = "$_";
                $i = $i + 1;
            }
        }

        close(CONF);

        $openval = open(CONF, ">" . configFile());
        if ($ison == 1) {
            print CONF "$toggle_opt=0\n";
        } elsif ($ison == 0) {
            print CONF "$toggle_opt=1\n";
        }
        $total = $i;
        $i = 0;
        while ($i < $total) {
            print CONF "$hold[$i]";
            $i = $i + 1;
        }
        close(CONF);
    }
    if ($ison == 1) {
        if ($toggle_opt eq "show_menu") {
            HexChat::command("MENU DEL HNP");
        }
        HexChat::print("\cC02HNP:\cC01 \cB$toggle_opt\cB is now \cBOFF\cB.");
    } elsif ($ison == 0) {
        if ($toggle_opt eq "show_menu") {
            load_menus();
        }
        HexChat::print("\cC02HNP:\cC01 \cB$toggle_opt\cB is now \cBON\cB.");
    }
    return HexChat::EAT_ALL;
}
sub cmd_hnpabout {
    HexChat::command ("GUI MSGBOX \"HNP 2.0.1\n\nHexChat Now Playing Script for Clementine 2.x\n\n(C) 2006-2015 Craciun Dan\n(C) 2010 John Aylward\n\nhttp://www.tuxarena.com/intro/xnp.php\"");
    return HexChat::EAT_ALL;
}

sub cmd_browser {
    $browser_opt = $_[0];
    if (browser_installed("$browser_opt") == 0) {
        if (load_integrity() == 0) {
            $openval = open(CONF, configFile());

            $change = "false";
            $i = 0;
            while (<CONF>) {
                @array = split("=", $_);
                $opt = $array[0];
                $val = $array[1];
                chomp($opt);
                chomp($val);

                if ($opt eq "browser") {
                    if ($val ne "$browser_opt") {
                        $change = "true";
                    }
                } else {
                    $hold[$i] = "$_";
                    $i = $i + 1;
                    $total = $i;
                }
            }
            close(CONF);
            if ($change eq "true") {
                $i = 0;
                $openval = open(CONF, ">" . configFile());
                while ($i <= $total) {
                    print CONF "$hold[$i]";
                    $i = $i + 1;
                }
                print CONF "browser=$browser_opt\n";
                close(CONF);
                HexChat::print("\cC02HNP:\cC01 The help \cBbrowser\cB is now set to \cB$browser_opt\cB.");
            } else {
                HexChat::print("\cC02HNP:\cC01 The help \cBbrowser\cB is already set to \cB$browser_opt\cB.");
            }
        }
    } else {
        HexChat::print("\cC02HNP:\cC01 The \cB$browser_opt\cB browser is not installed. Install it or try another browser.");
        return HexChat::EAT_ALL;
    }
    return HexChat::EAT_ALL;
}

sub isRunning {
    $META = `qdbus org.mpris.MediaPlayer2`;
    return $META =~ /\/.*/
}

sub isPlaying {
    $META = `qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Metadata`;
    return $META =~ /title: (.*)/
}

sub cmd_hnpmute {
    if (isRunning()) {
        system("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Mute");
    } else {
        HexChat::print("\cC02HNP:\cC01 Clementine is not running.");
    }
    return HexChat::EAT_ALL;
}

sub cmd_hnpplay {
    if (isRunning()) {
        if (!isPlaying()) {
            system ("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Play");
        }
    } else {
        HexChat::print ("\cC02HNP:\cC01 Clementine is not running.");
    }
    return HexChat::EAT_ALL;
}

sub cmd_hnppause {
    if (isPlaying()) {
        system ("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Pause");
    } else {
        HexChat::print ("\cC02HNP:\cC01 Clementine is not running or is already paused or stopped.");
    }
    return HexChat::EAT_ALL;
}

sub cmd_hnpstop {
    if (isPlaying()) {
        system ("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Stop");
    } else {
        HexChat::print ("\cC02HNP:\cC01 Clementine is not running.");
    }
    return HexChat::EAT_ALL;
}

sub cmd_hnpprev {
    system ("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Prev");
    return HexChat::EAT_ALL;
}

sub cmd_hnpnext {
    system ("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Next");
    return HexChat::EAT_ALL;
}

sub cmd_hnprun {
    system ("amarok");
    return HexChat::EAT_ALL;
}

sub cmd_hnpquit {
    system ("qdbus org.mpris.MediaPlayer2 /amarok/MainWindow close");
    return HexChat::EAT_ALL;
}

sub cmd_hnpmax {
    if (isRunning()) {
        system ("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 VolumeSet 100");
        HexChat::print("\cC02HNP:\cC01 Clementine volume is now maximum.");
    } else {
        HexChat::print("\cC02HNP:\cC01 Clementine is not running.");
    }
    return HexChat::EAT_ALL;
}

sub cmd_hnpvol {
    if (isRunning()) {
        $val = $_[0][1];
        if ($val ne "") {
            system("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 VolumeSet $val");
            HexChat::print("\cC02HNP:\cC01 Clementine volume is now $val%.");
        } else {
            HexChat::print("\cC02HNP:\cC01 Usage: /HNPVOL <VOLUME>");
        }
    } else {
        HexChat::print("\cC02HNP:\cC01 Clementine is not running.");
    }
    return HexChat::EAT_ALL;
}

sub cmd_hnpvol1 {
    if (isRunning()) {
        system("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 VolumeSet 10");
        HexChat::print("\cC02HNP:\cC01 Clementine volume is now 10%.");
    } else {
        HexChat::print("\cC02HNP:\cC01 Clementine is not running.");
    }
    return HexChat::EAT_ALL;
}
sub cmd_hnpvol2 {
    if (isRunning()) {
        system("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 VolumeSet 20");
        HexChat::print("\cC02HNP:\cC01 Clementine volume is now 20%.");
    } else {
        HexChat::print("\cC02HNP:\cC01 Clementine is not running.");
    }
    return HexChat::EAT_ALL;
}
sub cmd_hnpvol3 {
    if (isRunning()) {
        system("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 VolumeSet 30");
        HexChat::print("\cC02HNP:\cC01 Clementine volume is now 30%.");
    } else {
        HexChat::print("\cC02HNP:\cC01 Clementine is not running.");
    }
    return HexChat::EAT_ALL;
}
sub cmd_hnpvol4 {
    if (isRunning()) {
        system("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 VolumeSet 40");
        HexChat::print("\cC02HNP:\cC01 Clementine volume is now 40%.");
    } else {
        HexChat::print("\cC02HNP:\cC01 Clementine is not running.");
    }
    return HexChat::EAT_ALL;
}
sub cmd_hnpvol5 {
    if (isRunning()) {
        system("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 VolumeSet 50");
        HexChat::print("\cC02HNP:\cC01 Clementine volume is now 50%.");
    } else {
        HexChat::print("\cC02HNP:\cC01 Clementine is not running.");
    }
    return HexChat::EAT_ALL;
}
sub cmd_hnpvol6 {
    if (isRunning()) {
        system("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 VolumeSet 60");
        HexChat::print("\cC02HNP:\cC01 Clementine volume is now 60%.");
    } else {
        HexChat::print("\cC02HNP:\cC01 Clementine is not running.");
    }
    return HexChat::EAT_ALL;
}
sub cmd_hnpvol7 {
    if (isRunning()) {
        system("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 VolumeSet 70");
        HexChat::print("\cC02HNP:\cC01 Clementine volume is now 70%.");
    } else {
        HexChat::print("\cC02HNP:\cC01 Clementine is not running.");
    }
    return HexChat::EAT_ALL;
}
sub cmd_hnpvol8 {
    if (isRunning()) {
        system("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 VolumeSet 80");
        HexChat::print("\cC02HNP:\cC01 Clementine volume is now 80%.");
    } else {
        HexChat::print("\cC02HNP:\cC01 Clementine is not running.");
    }
    return HexChat::EAT_ALL;
}
sub cmd_hnpvol9 {
    if (isRunning()) {
        system("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 VolumeSet 90");
        HexChat::print("\cC02HNP:\cC01 Clementine volume is now 90%.");
    } else {
        HexChat::print("\cC02HNP:\cC01 Clementine is not running.");
    }
    return HexChat::EAT_ALL;
}

sub bold {
    my ($str) = @_;
    return "\cB" . $str . "\cB";
}
sub underline {
    my ($str) = @_;
    return "\c_" . $str . "\c_";
}
sub color1 {
    my ($str) = @_;
    return "\cC02" . $str . "\cO";
}
sub color2 {
    my ($str) = @_;
    return "\cC03" . $str . "\cO";
}

sub cmd_hnp {
    if (load_integrity() == 0) {
    if (isPlaying()) {
        $openval = open(CONF, configFile());
        while (<CONF>) {
        @array = split("=", $_);
        $opt = $array[0];
        $val = $array[1];
        chomp($opt);
        chomp($val);
        if ($opt eq "show_album") { if ($val == 0) { $show_album = 0; } else { $show_album = 1; } }
        if ($opt eq "show_year") { if ($val == 0) { $show_year = 0; } else { $show_year = 1; } }
        if ($opt eq "show_track") { if ($val == 0) { $show_track = 0; } else { $show_track = 1; } }
        if ($opt eq "show_length") { if ($val == 0) { $show_length = 0; } else { $show_length = 1; } }
        if ($opt eq "show_bitrate") { if ($val == 0) { $show_bitrate = 0; } else { $show_bitrate = 1; } }
        if ($opt eq "show_size") { if ($val == 0) { $show_size = 0; } else { $show_size = 1; } }
        if ($opt eq "show_text_color") { if ($val == 0) { $show_text_color = 0; } else { $show_text_color = 1; } }
        if ($opt eq "show_text_style") { if ($val == 0) { $show_text_style = 0; } else { $show_text_style = 1; } }
        }
        close(CONF);

        $QDBUS_POSITION = `qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Position`;
        $META = `qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Metadata`;
        $tmp_title = ( $META =~ /title: (.*)/   ? $1 : "" );
        $tmp_artist = ( $META =~ /artist: (.*)/  ? $1 : "" );

        chomp($tmp_title);
        chomp($tmp_artist);
        if ($tmp_title eq "" && $tmp_artist eq "") {
            $tmp_filename = filename();
            $artist = "";
            $title = "$tmp_filename";
            if ($show_text_style) {
                $title = bold($title);
            }
            if ($show_text_color) {
                $title = color1($title);
            }
            $title .= " ";
        } else {
            if ($tmp_title eq "") {
                $title = "";
                $artist = "by $artist ";
            } else {
                if ($tmp_artist eq "") {
                    $artist = "";
                } else {
                    $title = $tmp_title;
                    $artist = $tmp_artist;
                    if ($show_text_style) {
                        $title = underline($title);
                        $artist = bold($artist);
                    }
                    if ($show_text_color) {
                        $title = color1($title);
                        $artist = color1($artist);
                    }
                    $title .= " ";
                    $artist = "by $artist ";
                }
            }
        }

        if ($show_album == 1) {
            $tmp_album = ( $META =~ /album: (.*)/  ? $1 : "" );
            chomp($tmp_album);
            if ($tmp_album ne "") {
                $album = $tmp_album;
                if ($show_text_style) {
                    $album = underline($album);
                }
                if ($show_text_color) {
                    $album = color1($album);
                }
                $album = "from $album ";
            } else {
                $album = "";
            }
        } else {
            $album = "";
        }

        if ($show_year == 1) {
            $tmp_year = ( $META =~ /year: (\d{2,4})/  ? $1 : "" );
            chomp($tmp_year);
            if ($tmp_year != 0) {
                $year = $tmp_year;
                if ($show_text_style) {
                    $year = bold($year);
                }
                if ($show_text_color) {
                    $year = color2($year);
                }
                $year = "[$year] ";
            } else {
                $year = "";
            }
        } else {
            $year = "";
        }

        if ($show_track == 1) {
            $tmp_track = ( $META =~ /tracknumber: (\d*)/  ? $1 : "" );
            chomp($tmp_track);
            if ($tmp_track != 0) {
                $track = $tmp_track;
                if ($show_text_style) {
                    $track = bold($track);
                }
                if ($show_text_color) {
                    $track = color2($track);
                }
                $track = "[Track: $track] ";
            } else {
                $track = "";
            }
        } else {
            $track = "";
        }

        if ($show_length == 1) {
            $tmp_length = ( $META =~ /length: (\d*)/  ? $1 : "" );
            chop($tmp_length);
            if ($tmp_length ne "") {
                use integer;
                $tmp_length = $tmp_length / 100;

                $seconds = sprintf("%02d", ($tmp_length / 1000) % 60);
                $minutes = sprintf("%02d", ($tmp_length / 60000) % 60);
                $hours = $tmp_length / 3600000;

                if ($hours > 0) {
                    $duration = "$hours:$minutes:$seconds";
                } else {
                    $duration = "$minutes:$seconds";
                }

                if ($show_text_style) {
                    $duration = bold($duration);
                }
                if ($show_text_color) {
                    $duration = color2($duration);
                }

            }

            $tmp_duration = ( $QDBUS_POSITION =~ /(\d*)/  ? $1 : "" );
            chop($tmp_duration);
            if ($tmp_duration ne "") {
                use integer;
                $tmp_duration = $tmp_duration / 100;

                $seconds = sprintf("%02d", ($tmp_duration / 1000) % 60);
                $minutes = sprintf("%02d", ($tmp_duration / 60000) % 60);
                $hours = $tmp_duration / 3600000;

                if ($hours > 0) {
                    $position = "$hours:$minutes:$seconds";
                } else {
                    $position = "$minutes:$seconds";
                }

                if ($show_text_style) {
                    $position = bold($position);
                }
                if ($show_text_color) {
                    $position = color2($position);
                }
            }

            if ($position ne "" && $duration ne "") {
                $length = "[$position / $duration] ";
            } elsif ($position == "" && $duration ne "") {
                $length = "[Duration: $duration] ";
            } elsif ($position ne "" && $duration == "") {
                $length = "[@ $position] ";
            } else {
                $length = "";
            }

        } else {
            $length = "";
        }
        if ($show_bitrate == 1) {
            $tmp_bitrate = ( $META =~ /bitrate: (.*)/  ? $1 : "" );
            chomp($tmp_bitrate);
            if ($tmp_bitrate ne "") {
                $bitrate = $tmp_bitrate;
                if ($show_text_style) {
                    $bitrate = bold($bitrate);
                }
                if ($show_text_color) {
                    $bitrate = color2($bitrate);
                }
                $bitrate = "[$bitrate kbps] ";
            } else {
                $bitrate = "";
            }

        } else {
            $bitrate = "";
        }
        if ($show_size == 1) {
            $size = filesize();
            if ($size > 1) {
                if ($show_text_style) {
                    $size = bold($size);
                }
                if ($show_text_color) {
                    $size = color2($size);
                }
                $size = "[Size: $size] ";
            } else {
                $size = "";
            }
        } else {
            $size = "";
        }

        $line_HNP = "is listening to: $title$artist$album$year$track$length$bitrate$size";
        chomp($line_HNP);
        HexChat::command("ME $line_HNP");
    } else {
        HexChat::print("\cC02HNP:\cO Clementine is either stopped or paused.");
    }

    }
    return HexChat::EAT_ALL;
}

sub cmd_hnps {
    if (isPlaying()) {
        $META = `qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Metadata`;
        $title = ( $META =~ /title: (.*)/   ? $1 : "(No Title)" );
        $line_HNPs = "\cBRocks\cB with: \c_$title\c_";
        HexChat::command("ME $line_HNPs");
    } else {
        HexChat::print("\cC02HNP:\cO Clementine is either stopped or paused.");
    }
    return HexChat::EAT_ALL;
}

sub cmd_hnpstats {
    if (isPlaying()) {
        HexChat::print("Not supported in Clementine 2.x at this time");

        #$totalAlbums = `dcop Clementine collection totalAlbums`;
        #$totalArtists = `dcop Clementine collection totalArtists`;
        #$totalCompilations = `dcop Clementine collection totalCompilations`;
        #$totalGenres = `dcop Clementine collection totalGenres`;
        #$totalTracks = `dcop Clementine collection totalTracks`;
        #chomp($totalAlbums);
        #chomp($totalArtists);
        #chomp($totalCompilations);
        #chomp($totalGenres);
        #chomp($totalTracks);
        #$line_HNPstats = "\cOClementine Collection: [Tracks: \cC03$totalTracks\cO] [Artists: \cC03$totalArtists\cO] [Albums: \cC03$totalAlbums\cO] [Compilations: \cC03$totalCompilations\cO] [Genres: \cC03$totalGenres\cO] ";
        #HexChat::command("SAY $line_HNPstats");
    } else {
        HexChat::print("\cC02HNP:\cO Clementine is not running or is paused.");
    }
    return HexChat::EAT_ALL;
}

sub cmd_hnpinfo {
    if (isRunning()) {
        #$totalAlbums = `dcop Clementine collection totalAlbums`;
        #$totalArtists = `dcop Clementine collection totalArtists`;
        #$totalCompilations = `dcop Clementine collection totalCompilations`;
        #$totalGenres = `dcop Clementine collection totalGenres`;
        #$totalTracks = `dcop Clementine collection totalTracks`;

        #chomp($totalAlbums);
        #chomp($totalArtists);
        #chomp($totalCompilations);
        #chomp($totalGenres);
        #chomp($totalTracks);

        if (isPlaying()) {
            $META = `qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Metadata`;
            $tmp_title = ( $META =~ /title: (.*)/   ? $1 : "" );
            $tmp_artist = ( $META =~ /artist: (.*)/  ? $1 : "" );

            chomp($tmp_title);
            chomp($tmp_artist);

            if ($tmp_title eq "" && $tmp_artist eq "") {
                $tmp_filename = filename();
                $artist = "\cC02(No Title Field)\cO";
                $title = "\cC02$tmp_filename\cO ";
            } else {
                if ($tmp_title eq "") {
                    $title = "\cC02(No Title Field\cO) ";
                    $artist = "\cC02$tmp_artist\cO";
                } else {
                    if ($tmp_artist eq "") {
                        $title = "\cC02$tmp_title\cO";
                        $artist = "\cC02(No Artist Field)";
                    } else {
                        $title = "\cC02$tmp_title\cO";
                        $artist = "\cC02$tmp_artist\cO";
                    }
                }
            }
            $tmp_album = ( $META =~ /album: (.*)/  ? $1 : "" );
            chomp($tmp_album);
            if ($tmp_album ne "") {
                $album = "\cC02$tmp_album\cO";
            } else {
                $album = "\cC02(No Album Field)\cO";
            }
            $tmp_year = ( $META =~ /year: (.*)/  ? $1 : "" );
            chomp($tmp_year);
            if ($tmp_year != 0) {
                $year = "\cC03$tmp_year\cO";
            } else {
                $year = "\cC03(No Year Field)\cO";
            }
            $tmp_track = ( $META =~ /tracknumber: (.*)/  ? $1 : "" );
            chomp($tmp_track);
            if ($tmp_track != 0) {
                $track = "\cC03$tmp_track\cO";
            } else {
                $track = "\cC03(No Track Field)\cO";
            }
            $tmp_length = ( $META =~ /mtime: (.*)/  ? $1 : "" );
            chop($tmp_length);
            if ($tmp_length ne "") {
                use integer;
                $minutes = $tmp_length / 6000;
                if ($minutes < 10) {
                    $minutes = "0" . $minutes;
                }
                $seconds = ($tmp_length / 100) % 60;
                if ($seconds < 10) {
                    $seconds = "0" . $seconds;
                }
                $length = "\cC03$minutes:$seconds\cO";
            } else {
                $length = "\cC03(No Length Field)\cO";
            }

            $tmp_bitrate = ( $META =~ /audio-bitrate: (.*)/  ? $1 : "" );
            chomp($tmp_bitrate);
            if ($tmp_bitrate ne "") {
                $bitrate = "\cC03$tmp_bitrate\cO";
            } else {
                $bitrate = "\cC03(No Bitrate Field)\cO";
            }
            $tmp_size = filesize();
            $size = "\cC03$tmp_size\cO";

            HexChat::print("---");
            HexChat::print("\cC02HNP:\cO \cBRocks!\cB");
            HexChat::print("\cC02HNP:\cO Title:   \cC02$title");
            HexChat::print("\cC02HNP:\cO Artist:  \cC02$artist");
            HexChat::print("\cC02HNP:\cO Album:   \cC02$album");
            HexChat::print("\cC02HNP:\cO Year:    \cC03$year");
            HexChat::print("\cC02HNP:\cO Track:   \cC03$track");
            HexChat::print("\cC02HNP:\cO Length:  \cC03$length");
            HexChat::print("\cC02HNP:\cO Bitrate: \cC03$bitrate");
            HexChat::print("\cC02HNP:\cO Size:    \cC03$size");
            #HexChat::print("\cC02HNP:\cO \cBClementine Collection:\cB");
            #HexChat::print("\cC02HNP:\cO Tracks:       \cC03$totalTracks");
            #HexChat::print("\cC02HNP:\cO Artists:      \cC03$totalArtists");
            #HexChat::print("\cC02HNP:\cO Albums:       \cC03$totalAlbums");
            #HexChat::print("\cC02HNP:\cO Compilations: \cC03$totalCompilations");
            #HexChat::print("\cC02HNP:\cO Genres:       \cC03$totalGenres");
            HexChat::print("---");
        } else {
            HexChat::print("---");
            HexChat::print("\cC02HNP:\cO Clementine is either stopped or paused.");
            #HexChat::print("\cC02HNP:\cO \cBClementine Collection:\cB");
            #HexChat::print("\cC02HNP:\cO Tracks:       \cC03$totalTracks");
            #HexChat::print("\cC02HNP:\cO Artists:      \cC03$totalArtists");
            #HexChat::print("\cC02HNP:\cO Albums:       \cC03$totalAlbums");
            #HexChat::print("\cC02HNP:\cO Compilations: \cC03$totalCompilations");
            #HexChat::print("\cC02HNP:\cO Genres:       \cC03$totalGenres");
            HexChat::print("---");
        }
    } else {
        HexChat::print("---");
        HexChat::print("\cC02HNP:\cO Clementine is not running.");
        HexChat::print("---");
    }
    return HexChat::EAT_ALL;
}

sub cmd_all_on {
    if (load_integrity() == 0) {
        $openval = open(CONF, configFile());
        $allon = 1;
        while (<CONF>) {
            @array = split("=", $_);
            $opt = $array[0];
            $val = $array[1];
            chomp($val);
            if ($opt ne "browser" && $opt ne "show_menu" && $val == 0) {
                $allon = 0;
            }
            if ($opt eq "show_menu" && $val == 0) {
                $menu = 0;
            }
            if ($opt eq "show_menu" && $val == 1) {
                $menu = 1;
            }
            if ($opt eq "browser") {
                $browser = $val;
            }
        }
        close(CONF);
        if ($allon == 0) {
            $openval = open(CONF, ">" . configFile());
            print CONF "show_album=1\n";
            print CONF "show_year=1\n";
            print CONF "show_track=1\n";
            print CONF "show_length=1\n";
            print CONF "show_bitrate=1\n";
            print CONF "show_size=1\n";
            print CONF "show_menu=$menu\n";
            print CONF "browser=$browser\n";
            close(CONF);
            HexChat::print("\cC02HNP:\cO Displaying all the info is now \cBON\cB.");
        } elsif ($allon == 1) {
            HexChat::print("\cC02HNP:\cO Displaying all the info is already \cBON\cB.");
        }
    }
    return HexChat::EAT_ALL;
}

sub cmd_all_off {
    if (load_integrity() == 0) {
        $openval = open(CONF, configFile());
        $allon = 0;
        while (<CONF>) {
            @array = split("=", $_);
            $opt = $array[0];
            $val = $array[1];
            chomp($opt);
            chomp($val);
            if ($opt ne "show_menu" && $opt ne "browser" && $val == 1) {
                $allon = 1;
            }
            if ($opt eq "show_menu" && $val == 0) {
                $menu = 0;
            }
            if ($opt eq "show_menu" && $val == 1) {
                $menu = 1;
            }
            if ($opt eq "browser") {
                $browser = $val;
            }
        }
        close(CONF);
        if ($allon == 1) {
            $openval = open(CONF, ">" . configFile());
            print CONF "show_album=0\n";
            print CONF "show_year=0\n";
            print CONF "show_track=0\n";
            print CONF "show_length=0\n";
            print CONF "show_bitrate=0\n";
            print CONF "show_size=0\n";
            print CONF "show_menu=$menu\n";
            print CONF "browser=$browser\n";
            close(CONF);
            HexChat::print("\cC02HNP:\cO Displaying all the info is now \cBOFF\cB.");
        } elsif ($allon == 0) {
            HexChat::print("\cC02HNP:\cO Displaying all the info is already \cBOFF\cB.");
        }
    }
    return HexChat::EAT_ALL;
}

sub cmd_hnpmodes {
    if (load_integrity() == 0) {
        HexChat::print("---");
        HexChat::print("\cC02HNP:\cO\cB HNP Modes\cB");
        $openval = open(CONF, configFile());
        while (<CONF>) {
            chomp($_);
            HexChat::print("\cC02HNP:\cO $_");
        }
        close(CONF);
        HexChat::print("---");
    }
    return HexChat::EAT_ALL;
}

# obsolete
sub cmd_hnphowto {
    if (load_integrity() == 0) {
        $openval = open(CONF, configFile());
        while (<CONF>) {
            @array = split("=", $_);
            $opt = $array[0];
            $val = $array[1];
            chomp($opt);
            chomp($val);
            if ($opt eq "browser") {
                if (browser_installed($val) == 0) {
                    HexChat::command("EXEC $val " . HexChat::get_info("configdir") . "/HNP-help/howto-HNP.html");
                    return HexChat::EAT_ALL;
                } else {
                    HexChat::print("\cC02HNP:\cO The \cB$browser_opt\cB browser is not installed.");
                    if ($val ne "firefox") {
                        $cmd_browser = `firefox --version`;
                        if ($cmd_browser ne "") {
                            HexChat::command("BROWSER1");
                            HexChat::command("EXEC firefox " . HexChat::get_info("configdir") . "/HNP-help/howto-HNP.html");
                            return HexChat::EAT_ALL;
                        }
                    }
                    if ($val ne "epiphany") {
                        $cmd_browser = `epiphany --version`;
                        if ($cmd_browser ne "") {
                            HexChat::command("BROWSER2");
                            HexChat::command("EXEC epiphany " . HexChat::get_info("configdir") . "/HNP-help/howto-HNP.html");
                            return HexChat::EAT_ALL;
                        }
                    }
                    if ($val ne "konqueror") {
                        $cmd_browser = `konqueror --version`;
                        if ($cmd_browser ne "") {
                            HexChat::command("BROWSER3");
                            HexChat::command("EXEC konqueror " . HexChat::get_info("configdir") . "/HNP-help/howto-HNP.html");
                            return HexChat::EAT_ALL;
                        }
                    }
                    if ($val ne "opera") {
                        $cmd_browser = `opera --version`;
                        if ($cmd_browser ne "") {
                            HexChat::command("BROWSER4");
                            HexChat::command("EXEC opera " . HexChat::get_info("configdir") . "/HNP-help/howto-HNP.html");
                            return HexChat::EAT_ALL;
                        }
                    }
                    return HexChat::EAT_ALL;
                }
            }
        }
    }
    return HexChat::EAT_ALL;
}

# obsolete
sub cmd_hnpfaq {
    if (load_integrity() == 0) {
        $openval = open(CONF, configFile());
        while (<CONF>) {
            @array = split("=", $_);
            $opt = $array[0];
            $val = $array[1];
            chomp($opt);
            chomp($val);
            if ($opt eq "browser") {
                if (browser_installed($val) == 0) {
                    HexChat::command("EXEC $val " . HexChat::get_info("configdir") . "/HNP-help/faq-HNP.html");
                    return HexChat::EAT_ALL;
                } else {
                    HexChat::print("\cC02HNP:\cO The \cB$browser_opt\cB browser is not installed.");
                    if ($val ne "firefox") {
                        $cmd_browser = `firefox --version`;
                        if ($cmd_browser ne "") {
                            HexChat::command("BROWSER1");
                            HexChat::command("EXEC firefox " . HexChat::get_info("configdir") . "/HNP-help/faq-HNP.html");
                            return HexChat::EAT_ALL;
                        }
                    }
                    if ($val ne "epiphany") {
                        $cmd_browser = `epiphany --version`;
                        if ($cmd_browser ne "") {
                            HexChat::command("BROWSER2");
                            HexChat::command("EXEC epiphany " . HexChat::get_info("configdir") . "/HNP-help/faq-HNP.html");
                            return HexChat::EAT_ALL;
                        }
                    }
                    if ($val ne "konqueror") {
                        $cmd_browser = `konqueror --version`;
                        if ($cmd_browser ne "") {
                            HexChat::command("BROWSER3");
                            HexChat::command("EXEC konqueror " . HexChat::get_info("configdir") . "/HNP-help/faq-HNP.html");
                            return HexChat::EAT_ALL;
                        }
                    }
                    if ($val ne "opera") {
                        $cmd_browser = `opera --version`;
                        if ($cmd_browser ne "") {
                            HexChat::command("BROWSER4");
                            HexChat::command("EXEC opera " . HexChat::get_info("configdir") . "/HNP-help/faq-HNP.html");
                            return HexChat::EAT_ALL;
                        }
                    }
                }
            }
        }
    }
    return HexChat::EAT_ALL;
}

sub cmd_hnphome {
    if (load_integrity() == 0) {
        $openval = open(CONF, configFile());
        while (<CONF>) {
            @array = split("=", $_);
            $opt = $array[0];
            $val = $array[1];
            chomp($opt);
            chomp($val);
            if ($opt eq "browser") {
                if (browser_installed($val) == 0) {
                    HexChat::command("EXEC $val " . "http://www.tuxarena.com/intro/xnp.php 2> /dev/null");
                    return HexChat::EAT_ALL;
                } else {
                    HexChat::print("\cC02HNP:\cO The \cB$browser_opt\cB browser is not installed.");
                    if ($val ne "firefox") {
                        $cmd_browser = `firefox --version`;
                        if ($cmd_browser ne "") {
                            HexChat::command("BROWSER1");
                            HexChat::command("EXEC firefox " . "http://www.tuxarena.com/intro/xnp.php 2> /dev/null");
                            return HexChat::EAT_ALL;
                        }
                    }
                    if ($val ne "epiphany") {
                        $cmd_browser = `epiphany --version`;
                        if ($cmd_browser ne "") {
                            HexChat::command("BROWSER2");
                            HexChat::command("EXEC epiphany " . "http://www.tuxarena.com/intro/xnp.php 2> /dev/null");
                            return HexChat::EAT_ALL;
                        }
                    }
                    if ($val ne "konqueror") {
                        $cmd_browser = `konqueror --version`;
                        if ($cmd_browser ne "") {
                            HexChat::command("BROWSER3");
                            HexChat::command("EXEC konqueror " . "http://www.tuxarena.com/intro/xnp.php 2> /dev/null");
                            return HexChat::EAT_ALL;
                        }
                    }
                    if ($val ne "opera") {
                        $cmd_browser = `opera --version`;
                        if ($cmd_browser ne "") {
                            HexChat::command("BROWSER4");
                            HexChat::command("EXEC opera " . "http://www.tuxarena.com/intro/xnp.php 2> /dev/null");
                            return HexChat::EAT_ALL;
                        }
                    }
                    return HexChat::EAT_ALL;
                }
            }
        }
    }
    return HexChat::EAT_ALL;
}

sub cmd_hnphelp {
$arg = $_[0][1];
if ($arg eq "") {
    HexChat::print("---");
    HexChat::print("\cC02HNP:\cO \cBHNP 2.0.1\cB - \cBH\cBexChat \cBN\cBow \cBP\cBlaying Script for Clementine 2.x");
    HexChat::print("\cC02HNP:\cO -");
    HexChat::print("\cC02HNP:\cO \cBNow Playing Commands:\cB");
    HexChat::print("\cC02HNP:\cO /HNP  /HNPS  /HNPSTATS  /HNPINFO");
    HexChat::print("\cC02HNP:\cO -");
    HexChat::print("\cC02HNP:\cO \cBControl Clementine:\cB");
    HexChat::print("\cC02HNP:\cO /HNPPLAY  /HNPPAUSE  /HNPSTOP  /HNPRUN  /HNPQUIT  /HNPMUTE  /HNPMAX  /HNPPREV  /HNPNEXT");
    HexChat::print("\cC02HNP:\cO /HNPVOL <VOLUME>  /HNPVOL1 - /HNPVOL9");
    HexChat::print("\cC02HNP:\cO -");
    HexChat::print("\cC02HNP:\cO \cBDisplay Configuration and Toggling:\cB");
    HexChat::print("\cC02HNP:\cO /TOGGLE_ALBUM  /TOGGLE_YEAR  /TOGGLE_TRACK  /TOGGLE_LENGTH  /TOGGLE_BITRATE  /TOGGLE_SIZE  /ALL_ON  /ALL_OFF");
    HexChat::print("\cC02HNP:\cO /TOGGLE_SHOW_MENU  /HNPMODES  /BROWSER1  /BROWSER2  /BROWSER3  /BROWSER4");
    HexChat::print("\cC02HNP:\cO -");
    HexChat::print("\cC02HNP:\cO \cBGetting Help:\cB");
    HexChat::print("\cC02HNP:\cO /HNPHELP [COMMAND]  /HNPABOUT  /HNPHOME");
    HexChat::print("\cC02HNP:\cO -");
    HexChat::print("\cC02HNP:\cO Type \cB/HNPHELP COMMAND\cB to see detailed help on each command.");
    HexChat::print("\cC02HNP:\cO -");
    HexChat::print("\cC02HNP:\cO For updates visit the homepage: http://www.tuxarena.com/intro/xnp.php");
    HexChat::print("\cC02HNP:\cO To load this script when HexChat starts, copy the hnp.pl file into your ~/.config/hexchat/ directory.");
    HexChat::print("\cC02HNP:\cO For suggestions, feature requests and bug reports please contact me at floydian.embryo\@yahoo.com.");
    HexChat::print("---");
}
    if (lc($arg) eq "hnp") {
        HexChat::print("\cC02HNP:\cO \cB/HNP\cB message the current channel/query");
    }
    if (lc($arg) eq "hnps") {
        HexChat::print("\cC02HNP:\cO \cB/HNPS\cB message the current channel/query in a very simplistic format");
    }
    if (lc($arg) eq "hnpstats") {
        HexChat::print("\cC02HNP:\cO \cB/HNPSTATS\cB message the current channel/query info about the Clementine collection");
    }
    if (lc($arg) eq "hnpinfo") {
        HexChat::print("\cC02HNP:\cO \cB/HNPINFO\cB echo in the current window info about the current playing track and collection");
    }
    if (lc($arg) eq "toggle_album") {
        HexChat::print("\cC02HNP:\cO \cB/TOGGLE_ALBUM\cB toggle displaying the album");
    }
    if (lc($arg) eq "toggle_year") {
        HexChat::print("\cC02HNP:\cO \cB/TOGGLE_YEARcB toggle displaying the year");
    }
    if (lc($arg) eq "toggle_track") {
        HexChat::print("\cC02HNP:\cO \cB/TOGGLE_TRACK\cB toggle displaying the track");
    }
    if (lc($arg) eq "toggle_length") {
        HexChat::print("\cC02HNP:\cO \cB/TOGGLE_LENGTH\cB toggle displaying the length");
    }
    if (lc($arg) eq "toggle_bitrate") {
        HexChat::print("\cC02HNP:\cO \cB/TOGGLE_BITRATE\cB toggle displaying the bitrate");
    }
    if (lc($arg) eq "toggle_size") {
        HexChat::print("\cC02HNP:\cO \cB/TOGGLE_SIZE\cB toggle displaying the size");
    }
    if (lc($arg) eq "toggle_show_menu") {
        HexChat::print("\cC02HNP:\cO \cB/TOGGLE_SHOW_MENU\cB toggle the HNP menu ON/OFF");
    }
    if (lc($arg) eq "all_on") {
        HexChat::print("\cC02HNP:\cO \cB/ALL_ON\cB toggle ON displaying all the info");
    }
    if (lc($arg) eq "all_off") {
        HexChat::print("\cC02HNP:\cO \cB/ALL_OFF\cB toggle OFF displaying all the info");
    }
    if (lc($arg) eq "browser1") {
        HexChat::print("\cC02HNP:\cO \cB/BROWSER1\cB change the help browser to Firefox");
    }
    if (lc($arg) eq "browser2") {
        HexChat::print("\cC02HNP:\cO \cB/BROWSER2\cB change the help browser to Epiphany");
    }
    if (lc($arg) eq "browser3") {
        HexChat::print("\cC02HNP:\cO \cB/BROWSER3\cB change the help browser to Konqueror");
    }
    if (lc($arg) eq "browser4") {
        HexChat::print("\cC02HNP:\cO \cB/BROWSER4\cB change the help browser to Opera");
    }
    if (lc($arg) eq "hnphome") {
        HexChat::print("\cC02HNP:\cO \cB/HNPHOME\cB open the homepage with a web browser.");
    }
    if (lc($arg) eq "hnpvol") {
        HexChat::print("\cC02HNP:\cO \cB/HNPVOL\cB change Clementine volume to any value (ie. /HNPVOL 73)");
    }
    if (lc($arg) eq "hnpmute") {
        HexChat::print("\cC02HNP:\cO \cB/HNPMUTE\cB mute Clementine");
    }
    if (lc($arg) eq "hnpmax") {
        HexChat::print("\cC02HNP:\cO \cB/HNPMAX\cB change Clementine volume to maximum (100%)");
    }
    if (lc($arg) eq "hnpvol1") {
        HexChat::print("\cC02HNP:\cO \cB/HNPVOL1\cB change Clementine volume to 10%");
    }
    if (lc($arg) eq "hnpvol2") {
        HexChat::print("\cC02HNP:\cO \cB/HNPVOL2\cB change Clementine volume to 20%");
    }
    if (lc($arg) eq "hnpvol3") {
        HexChat::print("\cC02HNP:\cO \cB/HNPVOL3\cB change Clementine volume to 30%");
    }
    if (lc($arg) eq "hnpvol4") {
        HexChat::print("\cC02HNP:\cO \cB/HNPVOL4\cB change Clementine volume to 40%");
    }
    if (lc($arg) eq "hnpvol5") {
        HexChat::print("\cC02HNP:\cO \cB/HNPVOL5\cB change Clementine volume to 50%");
    }
    if (lc($arg) eq "hnpvol6") {
        HexChat::print("\cC02HNP:\cO \cB/HNPVOL6\cB change Clementine volume to 60%");
    }
    if (lc($arg) eq "hnpvol7") {
        HexChat::print("\cC02HNP:\cO \cB/HNPVOL7\cB change Clementine volume to 70%");
    }
    if (lc($arg) eq "hnpvol8") {
        HexChat::print("\cC02HNP:\cO \cB/HNPVOL8\cB change Clementine volume to 80%");
    }
    if (lc($arg) eq "hnpvol9") {
        HexChat::print("\cC02HNP:\cO \cB/HNPVOL9\cB change Clementine volume to 90%");
    }
    if (lc($arg) eq "hnpmodes") {
        HexChat::print("\cC02HNP:\cO \cB/HNPMODES\cB echo in the current window which info are ON and which are OFF");
    }
    if (lc($arg) eq "hnphelp") {
        HexChat::print("\cC02HNP:\cO \cB/HNPHELP\cB get a list of commands or help on a specific command (ie. /HNPHELP HNP)");
    }
    if (lc($arg) eq "hnpabout") {
        HexChat::print("\cC02HNP:\cO \cB/HNPABOUT\cB show the about message box");
    }
    if (lc($arg) eq "hnpplay") {
        HexChat::print("\cC02HNP:\cO \cB/HNPPLAY\cB start playing a track in Clementine");
    }
    if (lc($arg) eq "hnppause") {
        HexChat::print("\cC02HNP:\cO \cB/HNPPAUSE\cB pause Clementine");
    }
    if (lc($arg) eq "hnpstop") {
        HexChat::print("\cC02HNP:\cO \cB/HNPSTOP\cB stop Clementine");
    }
    if (lc($arg) eq "hnpprev") {
        HexChat::print("\cC02HNP:\cO \cB/HNPPREV\cB select/play previous track in Clementine");
    }
    if (lc($arg) eq "hnpnext") {
        HexChat::print("\cC02HNP:\cO \cB/HNPNEXT\cB select/play next track in Clementine");
    }
    if (lc($arg) eq "hnprun") {
        HexChat::print("\cC02HNP:\cO \cB/HNPRUN\cB run Clementine");
    }
    if (lc($arg) eq "hnpquit") {
        HexChat::print("\cC02HNP:\cO \cB/HNPQUIT\cB quit Clementine");
    }
    return HexChat::EAT_ALL;
}

sub filesize {
    $META = `qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Metadata`;
    $path = ( $META =~ /location: file:\/\/(.*)/  ? uri_unescape($1) : "" );
    chomp($path);
    @array_tmp = split("/", $path);
    $len = @array_tmp;
    $ls = `ls -l \"$path\"`;
    @array = split(" ", $ls);
    $size_bytes = $array[4];
    $size_kb = $size_bytes/1024;
    $size_mb = $size_bytes/(1024*1024);
    if ($size_mb < 0.01) {
        if ($size_kb < 0.01) {
            $size_bytes = substr($size_bytes, 0, 4);
            return "$size_bytes Bytes";
        }
        if ($size_kb >= 0.01) {
            $size_kb = substr($size_kb, 0, 4);
            return "$size_kb KB";
        }
    }
    if ($size_mb >= 0.01) {
        if ($size_mb >= 10) {
            $size_mb = substr($size_mb, 0, 5);
        } else {
            $size_mb = substr($size_mb, 0, 4);
        }
        return "$size_mb MB";
    }
}

sub filename {
    $META = `org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 Metadata`;
    $path = ( $META =~ /location: (.*)/  ? $1 : "");
    chomp($path);
    @array_tmp = split("/", $path);
    $len = @array_tmp;
    $filename = $array_tmp[$len - 1];
    return $filename;
}

sub browser_installed {
    $browser_opt = $_[0];
    $cmd_output = `$browser_opt --version`;
    chomp($cmd_output);
    if ($cmd_output ne "") {
        return 0;
    } else {
        return 1;
    }
    return 1;
}
