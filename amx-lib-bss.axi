(***********************************************************
    AMX BSS LIBRARY
    v0.0.1
    
    Website: https://sourceforge.net/projects/[Future]
    
    
 -- THIS IS A THIRD-PARTY LIBRARY AND IS NOT AFFILIATED WITH --
 --               THE AMX ORGANIZATION OR BSS                --
    
    
    This library contains the code to interface with a
    BSS Soundweb London device, like the BLU series products.
    
    It is assumed the developer has read the Soundweb London
    Interface Kit documentation (London DI Kit.pdf) provided
    by BSS.  The conventions used in this library try to
    follow the terminology used by BSS.  A copy of the PDF
    is installed in the London Architect application
    directory, which by default is:
    C:\Program Files\Harman Pro\London Architect\London DI Kit.pdf
    
    CONVENTIONS
    
    All elements exposed globally by this library are prefixed with "BSS".
    
    Underscores prefixing function names indicate low-level
    functions used by this library.  These functions typically
    won't need to be used by the control system developer.
    
    BSS controls are referenced by an 8-byte array consisting of the
    object's 6-byte HiQnet Address (node, virtual device, object)
    followed by the parameter's 2-byte state variable ID.  This looks
    like:
    
    MY_FADER[] = {$05, $f1, $03, $00, $01, $07, $4e, $20}
                  ------ HiQnet Address ------  -- SV --
    
    A network connection only needs to be established from AMX to one
    BSS device, since HiQnet can pass messages between nodes.  Bind
    vdvBSS to one physical device.
*************************************************************
    Copyright 2012 Alex McLain
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
************************************************************)

PROGRAM_NAME='amx-lib-bss'

#if_not_defined AMX_LIB_BSS
#define AMX_LIB_BSS 1
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    History: See changelog.txt or version control repository.
*)
(***********************************************************)
(*                    INCLUDES GO BELOW                    *)
(***********************************************************)

(***********************************************************)
(*           DEVICE NUMBER DEFINITIONS GO BELOW            *)
(***********************************************************)
DEFINE_DEVICE

vdvBSS = 36999:1:0;

(***********************************************************)
(*              CONSTANT DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_CONSTANT

BSS_TCP_PORT = 1023;

// Message acknowledgement mode.
// Off for TCP, on for serial.
BSS_MSG_ACK_OFF = 0;
BSS_MSG_ACK_ON  = 1;

//   BSS DIRECT INJECT MESSAGING PROTOCOL DEFINITIONS   //

// Special bytes.
BSS_STX	= $02;	// Start of packet.
BSS_ETX	= $03;	// End of packet.
BSS_ACK	= $06;  // Packet acknowledgement (not used for TCP/IP).
BSS_NAK	= $15;	// Negative acknowledgement.
BSS_ESC	= $18;	// Escape character.

// Command bytes.
BSS_DI_SETSV			= $88;	// Set state variable.
BSS_DI_SUBSCRIBESV		= $89;	// Subscribe to state variable.
BSS_DI_UNSUBSCRIBESV		= $8A;	// Unsubscribe from state variable.
BSS_DI_VENUE_PRESET_RECALL	= $8B;  // Recall a venue preset.
BSS_DI_PARAM_PRESET_RECALL	= $8C;	// Recall a parameter preset.
BSS_DI_SETSVPERCENT		= $8D;	// Set state variable by percentage.
BSS_DI_SUBSCRIBESVPERCENT	= $8E;	// Subscribe to state variable as a percentage.
BSS_DI_UNSUBSCRIBESVPERCENT	= $8F;	// Unsubscribe from a state variable as a percentage.
BSS_DI_BUMPSVPERCENT		= $90;	// Bump the SV by the given signed percentage.

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*              VARIABLE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_VARIABLE

bssMsgAck = BSS_MSG_ACK_OFF;	// Message acknowledgement mode.  Off for TCP, on for serial.

(***********************************************************)
(*              LATCHING DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*         MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW         *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*         SUBROUTINE/FUNCTION DEFINITIONS GO BELOW        *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

/*
 *  Set state variable.
 */
define_function bssSet(char control[], slong value)
{
    // Msg body: <DI_SETSV> <node> <virtual device> <object> <state variable> <data>
}

/*
 *  Subscribe to variable.
 */
define_function bssSubscribe(char control[], slong rate)
{
    // Msg body: <DI_SUBSCRIBESV> <node> <virtual device> <object> <state variable> <rate>
}

/*
 *  Unsubscribe from variable.
 */
define_function bssUnsubscribe(char control[])
{
    // Msg body: <DI_UNSUBSCRIBESV> <node> <virtual device> <object> <state variable> <0>
}

/*
 *  Recall a venue preset.
 */
define_function bssVenueRecall(long value)
{
    // Msg body: <DI_VENUE_PRESET_RECALL> <data>
}

/*
 *  Recall a parameter preset.
 */
define_function bssPresetRecall(long value)
{
    // Msg body: <DI_PARAM_PRESET_RECALL> <data>
}

/*
 *  Set state variable as percent.
 */
define_function bssSetPercent(char control[], slong value)
{
    // Msg body: <DI_SETSVPERCENT> <node> <virtual device> <object> <state variable> <percentage>
}

/*
 *  Subscribe to variable as percent.
 */
define_function bssSubscribePercent(char control[], long rate)
{
    // Msg body: <DI_SUBSCRIBESVPERCENT> <node> <virtual device> <object> <state variable> <rate>
}

/*
 *  Unsubscribe from variable as percent.
 */
define_function bssUnsubscribePercent(char control[])
{
    // Msg body: <DI_UNSUBSCRIBESVPERCENT> <node> <virtual device> <object> <state variable> <0>
}

/*
 *  Bump the state variable by the given percent.
 *  += up, -= down
 */
define_function bssBumpPercent(char control[], long value)
{
    // Msg body: <DI_BUMPSVPERCENT> <node> <virtual device> <object> <state variable> <+/- percentage>
}

/*
 *  Calculate data checksum.
 */
define_function char _bssChecksum(str[])
{

}

/*
 *  Send packet to the DSP device.
 */
define_function _bssSend(char body[])
{
    char packet[16];
    
    // Wrap body data with STX, checksum, and ETX bytes.
    // Escape special characters.
}

/*
 *  Convert long to byte.
 */
define_function char[4] _bssLongToByte(slong value)
{

}

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                   THE EVENTS GO BELOW                   *)
(***********************************************************)
DEFINE_EVENT

(***********************************************************)
(*                 THE MAINLINE GOES BELOW                 *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*          DO NOT PUT ANY CODE BELOW THIS COMMENT         *)
(***********************************************************)
#end_if
