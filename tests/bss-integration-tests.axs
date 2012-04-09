PROGRAM_NAME='bss-integration-tests'
(***********************************************************
    BSS SOUNDWEB LONDON API
    INTEGRATION TESTS
    
    This system tests the amx-lib-bss API connected to a
    physical BLU device.
************************************************************)

(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    History:
*)
(***********************************************************)
(*                    INCLUDES GO BELOW                    *)
(***********************************************************)



(***********************************************************)
(*           DEVICE NUMBER DEFINITIONS GO BELOW            *)
(***********************************************************)
DEFINE_DEVICE

vdvListener = 36000:1:0;
//dvBLU = 0:first_local_port:0;
vdvBSS = 0:first_local_port:0;

#include 'amx-lib-bss'
(***********************************************************)
(*              CONSTANT DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_CONSTANT

IPADDRESS[] = '192.168.0.51';
//IPADDRESS[] = '192.168.0.37';

INTEGRATION_OBJECT[] = {$10, $01, $03, $00, $01, $00, $00, $00}; // A mono gain block on a physical device.

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

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                   THE EVENTS GO BELOW                   *)
(***********************************************************)
DEFINE_EVENT

data_event[vdvListener]
{
    string:
    {
	ip_client_open(first_local_port, IPADDRESS, BSS_TCP_PORT, IP_TCP);
	//ip_client_open(first_local_port, IPADDRESS, 23, IP_TCP);
	//combine_devices(vdvBSS, dvBLU);
	
	wait 5
	{
	    bssSetPercent(INTEGRATION_OBJECT, 50);
	    
	    wait 5
	    {
		//uncombine_devices(vdvBSS);
		ip_client_close(first_local_port);
	    }
	}
    }
}

(***********************************************************)
(*                 THE MAINLINE GOES BELOW                 *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*          DO NOT PUT ANY CODE BELOW THIS COMMENT         *)
(***********************************************************)
