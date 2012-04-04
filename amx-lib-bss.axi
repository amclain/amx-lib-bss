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
    
    Underscores prefixing function names indicate low-level
    functions used by this library.  These functions typically
    won't need to be used by the control system developer.
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

(***********************************************************)
(*              CONSTANT DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_CONSTANT

//   BSS DIRECT INJECT MESSAGING PROTOCOL DEFINITIONS   //

// Special bytes.
BSS_STX		= $02;	// Start of packet.
BSS_ETX		= $03;	// End of packet.
BSS_ACK		= $06;  // Packet acknowledgement (not used for TCP/IP).
BSS_NAK		= $15;	// Negative acknowledgement.
BSS_ESC		= $18;	// Escape character.

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
define_function bssSet()
{

}

/*
 *  Subscribe to variable.
 */
define_function bssSubscribe()
{

}

/*
 *  Unsubscribe from variable.
 */
define_function bssUnsubscribe()
{

}

/*
 *  Recall a venue preset.
 */
define_function bssVenueRecall()
{

}

/*
 *  Recall a parameter preset.
 */
define_function bssPresetRecall()
{

}

/*
 *  Subscribe to variable as percent.
 */
define_function bssSubscribePercent()
{

}

/*
 *  Unsubscribe from variable as percent.
 */
define_function bssUnsubscribePercent()
{

}

/*
 *  Bump the state variable by the given percent.
 *  += up, -= down
 */
define_function bssBumpPercent()
{

}

/*
 *  Calculate data checksum.
 */
define_function char _bssChecksum()
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
