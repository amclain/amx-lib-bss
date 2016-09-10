(***********************************************************
    An example include file for a project that uses
    amx-lib-bss
************************************************************)

#if_not_defined EXAMPLE_PROJECT_AUDIO
#define EXAMPLE_PROJECT_AUDIO 1
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(*           DEVICE NUMBER DEFINITIONS GO BELOW            *)
(***********************************************************)
DEFINE_DEVICE

vdvBSS = 0:2:0; // BSS BLU-160

(***********************************************************)
(*              CONSTANT DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_CONSTANT

BSS_IP_ADDRESS[] = '192.168.1.3'; // BSS BLU-160

// Audio Sources
AUDIO_SRC_WLS_1        = 1;
AUDIO_SRC_WLS_2        = 2;
AUDIO_SRC_WLS_3        = 3;
AUDIO_SRC_WLS_4        = 4;

MAX_AUDIO_SOURCES      = 4;

// Audio Zones
AUDIO_ZONE_ROOM_1      = 1;
AUDIO_ZONE_ROOM_2      = 2;
AUDIO_ZONE_ROOM_3      = 3;

MAX_AUDIO_ZONES        = 3;

// Audio EQ Seclector Options
AUDIO_EQ_LAV           = 1;
AUDIO_EQ_HEADSET       = 2;

// Room Combine Presets
AUDIO_PRESET_CMB_1_2_3 = 0;
AUDIO_PRESET_CMB_12_3  = 1;
AUDIO_PRESET_CMB_1_23  = 2;
AUDIO_PRESET_CMB_123   = 3;

// BSS Addresses
HIQ_FADERS[][] = {
    {$10, $02, $03, $00, $01, $51, $00, $00}, // AUDIO_SRC_WLS_1
    {$10, $02, $03, $00, $01, $53, $00, $00}, // AUDIO_SRC_WLS_2
    {$10, $02, $03, $00, $01, $54, $00, $00}, // AUDIO_SRC_WLS_3
    {$10, $02, $03, $00, $01, $55, $00, $00}, // AUDIO_SRC_WLS_4
};

HIQ_MUTES[][] = {
    {$10, $02, $03, $00, $01, $51, $00, $01}, // AUDIO_SRC_WLS_1
    {$10, $02, $03, $00, $01, $53, $00, $01}, // AUDIO_SRC_WLS_2
    {$10, $02, $03, $00, $01, $54, $00, $01}, // AUDIO_SRC_WLS_3
    {$10, $02, $03, $00, $01, $55, $00, $01}, // AUDIO_SRC_WLS_4
};

HIQ_EQ_SELECT[][] = {
    {$10, $02, $03, $00, $01, $03, $00, $00}, // AUDIO_SRC_WLS_1
    {$10, $02, $03, $00, $01, $0A, $00, $00}, // AUDIO_SRC_WLS_2
    {$00, $00, $00, $00, $00, $00, $00, $00}, // AUDIO_SRC_WLS_3
    {$00, $00, $00, $00, $00, $00, $00, $00}, // AUDIO_SRC_WLS_4
};

HIQ_ROUTING[][][] = {
    // AUDIO_ZONE_ROOM_1
    {
        {$10, $02, $03, $00, $01, $81, $00, $00}, // AUDIO_SRC_WLS_1
        {$10, $02, $03, $00, $01, $81, $00, $01}, // AUDIO_SRC_WLS_2
        {$10, $02, $03, $00, $01, $81, $00, $02}, // AUDIO_SRC_WLS_3
        {$10, $02, $03, $00, $01, $81, $00, $03}, // AUDIO_SRC_WLS_4
    },
    // AUDIO_ZONE_ROOM_2
    {
        {$10, $02, $03, $00, $01, $81, $00, $80}, // AUDIO_SRC_WLS_1
        {$10, $02, $03, $00, $01, $81, $00, $81}, // AUDIO_SRC_WLS_2
        {$10, $02, $03, $00, $01, $81, $00, $82}, // AUDIO_SRC_WLS_3
        {$10, $02, $03, $00, $01, $81, $00, $83}, // AUDIO_SRC_WLS_4
    },
    // AUDIO_ZONE_ROOM_3
    {
        {$10, $02, $03, $00, $01, $81, $01, $00}, // AUDIO_SRC_WLS_1
        {$10, $02, $03, $00, $01, $81, $01, $01}, // AUDIO_SRC_WLS_2
        {$10, $02, $03, $00, $01, $81, $01, $02}, // AUDIO_SRC_WLS_3
        {$10, $02, $03, $00, $01, $81, $01, $03}, // AUDIO_SRC_WLS_4
    }

};

(***********************************************************)
(*                    INCLUDES GO BELOW                    *)
(***********************************************************)

#include 'amx-lib-bss'
#include 'amx-lib-volume-sc'

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*              VARIABLE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_VARIABLE

persistent char    bss_persistent_data_initialized;
persistent volume  audio_input_levels[MAX_AUDIO_SOURCES];
persistent integer audio_eq_selection[MAX_AUDIO_SOURCES];
persistent integer audio_routing[MAX_AUDIO_SOURCES];
persistent integer audio_room_combine_state;

volatile integer bss_is_online = false;

(***********************************************************)
(*         SUBROUTINE/FUNCTION DEFINITIONS GO BELOW        *)
(***********************************************************)

define_function bss_initialize_persistent_data()
{
    integer i, len;
    
    print(LOG_LEVEL_INFO, 'Initializing audio persistent data.');
    
    // Limit 0%-100% for BSS interface.
    // Set fader limits in London Architect.
    vol_array_init(audio_input_levels, 0, VOL_UNMUTED, 0, 100, 50);
    
    for (i = 1, len = max_length_array(audio_eq_selection); i <= len; i++)
        audio_eq_selection[i] = AUDIO_EQ_LAV;
    
    for (i = 1, len = max_length_array(audio_routing); i <= len; i++)
        audio_routing[i] = AUDIO_ZONE_ROOM_1;
    
    audio_room_combine_state = AUDIO_PRESET_CMB_1_2_3;
    
    bss_persistent_data_initialized = true;
}

/*
 *  Open a TCP/IP socket to the BSS device.
 *  Connection is persistent.
 */
define_function bss_connect()
{
    ip_client_open(2, BSS_IP_ADDRESS, BSS_TCP_PORT, IP_TCP);
}

/*
 *  Initialize the BSS unit with the current states.
 */
define_function bss_init()
{
    integer i, len;
    
    print(LOG_LEVEL_INFO, 'Synchronizing state to BSS...');
    
    // Room Combine
    audio_room_combine(audio_room_combine_state);
    
    // Source Routing
    for (i = 1, len = max_length_array(audio_routing); i <= len; i++)
        audio_route(i, audio_routing[i]);
    
    // EQ Selectors
    for (i = 1, len = max_length_array(audio_eq_selection); i <= len; i++)
        audio_select_eq(i, audio_eq_selection[i]);
    
    // Channel Strips
    for (i = 1, len = max_length_array(audio_input_levels); i <= len; i++)
    {
        _bss_update_volume(i);
        _update_mute(i);
    }
}

/*
 *  Sync local volume level to BSS.
 */
define_function _bss_update_volume(integer index)
{
    if (bss_is_online == false)
    {
        print(LOG_LEVEL_WARNING, "'Cannot set volume ', index, ': BSS offline.'");
        return;
    }
    
    bssSetPercent(HIQ_FADERS[index], vol_get_level(audio_input_levels[index]));
}

/*
 *  Sync local mute state to BSS.
 */
define_function _update_mute(integer index)
{
    if (bss_is_online == false)
    {
        print(LOG_LEVEL_WARNING, "'Cannot set mute ', index, ': BSS offline.'");
        return;
    }
    
    // Send 0% for unmuted, 100% for muted.
    bssSetPercent(HIQ_MUTES[index], type_cast(vol_get_mute_state(audio_input_levels[index])) * 100);
}

/*
 *  Increment volume level one step.
 *
 *  Accepts an AUDIO_SRC constant.
 */
define_function audio_increment_volume(integer index)
{
    vol_increment(audio_input_levels[index]);
    _bss_update_volume(index);
}

/*
 *  Decrement volume level one step.
 *
 *  Accepts an AUDIO_SRC constant.
 */
define_function audio_decrement_volume(integer index)
{
    vol_decrement(audio_input_levels[index]);
    _bss_update_volume(index);
}

/*
 *  Toggle an input's mute button.
 *
 *  Accepts an index of the audio_input_levels[] array.
 */
define_function audio_toggle_mute(integer index)
{
    vol_toggle_mute(audio_input_levels[index]);
    _update_mute(index);
    
    if (vol_get_mute_state(audio_input_levels[index]))
    {
        print(LOG_LEVEL_INFO, "'Muted input ', itoa(index), '.'");
    }
    else
    {
        print(LOG_LEVEL_INFO, "'Unmuted input ', itoa(index), '.'");
    }
}

/*
 *  Recall a room combine preset.
 *  
 *  Accepts an AUDIO_PRESET_CMB constant.
 */
define_function audio_room_combine(integer preset)
{
    audio_room_combine_state = preset;
    bssPresetRecall(preset);
    
    print(LOG_LEVEL_INFO, "'Room combine preset: ', itoa(preset)");
}

/*
 *  Route a source to a zone.
 *  
 *  Accepts an AUDIO_SRC constant followed by an AUDIO_ZONE constant.
 */
define_function audio_route(integer source, integer zone)
{
    integer crosspoint[MAX_AUDIO_ZONES];
    
    if (zone == AUDIO_ZONE_ROOM_1) crosspoint[AUDIO_ZONE_ROOM_1] = 1; else crosspoint[AUDIO_ZONE_ROOM_1] = 0;
    if (zone == AUDIO_ZONE_ROOM_2) crosspoint[AUDIO_ZONE_ROOM_2] = 1; else crosspoint[AUDIO_ZONE_ROOM_2] = 0;
    if (zone == AUDIO_ZONE_ROOM_3) crosspoint[AUDIO_ZONE_ROOM_3] = 1; else crosspoint[AUDIO_ZONE_ROOM_3] = 0;
    
    audio_routing[source] = zone;
    
    bssSet(HIQ_ROUTING[AUDIO_ZONE_ROOM_1][source], crosspoint[AUDIO_ZONE_ROOM_1]);
    bssSet(HIQ_ROUTING[AUDIO_ZONE_ROOM_2][source], crosspoint[AUDIO_ZONE_ROOM_2]);
    bssSet(HIQ_ROUTING[AUDIO_ZONE_ROOM_3][source], crosspoint[AUDIO_ZONE_ROOM_3]);
    
    print(LOG_LEVEL_INFO, "'Routed source ', itoa(source), ' to zone ', itoa(zone)");
}

/*
 *  Select an EQ curve for a source.
 *  
 *  Accepts an AUDIO_SRC constant followed by an AUDIO_EQ constant.
 */
define_function audio_select_eq(integer source, integer eq)
{
    audio_eq_selection[source] = eq
    bssSet(HIQ_EQ_SELECT[source], eq);
    
    print(LOG_LEVEL_INFO, "'Audio eq: ', itoa(eq), ' selected for source: ', itoa(source)");
}

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

if (bss_persistent_data_initialized != true)
{
    bss_initialize_persistent_data();
}

bss_connect();

(***********************************************************)
(*                   THE EVENTS GO BELOW                   *)
(***********************************************************)
DEFINE_EVENT

/*
 * Handle BSS connect/disconnect/reconnect.
 * Data processing is handled in the amx-lib-bss library.
 */
data_event[vdvBSS]
{
    online:
    {
        integer i;
        
        bss_is_online = true;
        print(LOG_LEVEL_INFO, 'Connected to BSS.');
        
        // Initialize volume and mute states to local values.
        bss_init();
    }
    
    offline:
    {
        bss_is_online = false;
        print(LOG_LEVEL_WARNING, 'BSS disconnected.');
        bss_connect();
    }
    
    onerror:
    {
        switch (data.number)
        {
            // Errors to retry connection.
            case 4: // Unknown host.
            case 6: // Connection refused.
            case 7: // Connection timed out.
            case 8: // Unknown connection error (happens on BSS segfault).
            {
                wait 100
                {
                    print(LOG_LEVEL_WARNING, 'Retrying BSS connection...');
                    bss_connect();
                }
            }
            
            default:
            {
                print(LOG_LEVEL_ERROR, "'BSS error: ', itoa(data.number)");
            }
        }
    }
    
    string: {}
}

(***********************************************************)
(*                 THE MAINLINE GOES BELOW                 *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*          DO NOT PUT ANY CODE BELOW THIS COMMENT         *)
(***********************************************************)
#end_if
