(***********************************************************
    BSS SOUNDWEB LONDON PROTOCOL
    TESTS
    
    Website: https://sourceforge.net/projects/[Future]
    
    
    These functions test the library's functionality.
************************************************************)

PROGRAM_NAME='bss-tests'
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(*                    INCLUDES GO BELOW                    *)
(***********************************************************)

#include 'amx-test-suite'
#include 'amx-lib-bss'

(***********************************************************)
(*              CONSTANT DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_CONSTANT

TEST_OBJECT[] = {$01, $02, $03, $04, $05, $06, $07, $08};


DEFINE_VARIABLE

char debug[BSS_MAX_PACKET_LEN];

(***********************************************************)
(*                TEST DEFINITIONS GO BELOW                *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

define_function testSuiteRun()
{
    testCommands();
}

define_function testCommands()
{
    local_var char str[BSS_MAX_PACKET_LEN];
    str = "TEST_OBJECT, $00, $00, $00, $00";
    
    debug = "BSS_STX, BSS_DI_SETSV, str, _bssChecksum(str), BSS_ETX";
    //testSuitePrint("'Length: ', itoa(length_array(debug))");
    send_string 0, "BSS_STX, BSS_DI_SETSV, str, _bssChecksum(str), BSS_ETX";
    
    ip_client_open(49000, '192.168.0.37', 23, IP_TCP);
    wait 5
    {
	send_string 0:49000:0, "BSS_STX, BSS_DI_SETSV, str, _bssChecksum(str), BSS_ETX";
	wait 5
	{
	    ip_client_close(49000);
	}
    }
    
    bssSet(TEST_OBJECT, 0);
    assertEventString(vdvBSS, "BSS_STX, BSS_DI_SETSV, str, _bssChecksum(str), BSS_ETX", 'BSS set.');
}

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                   THE EVENTS GO BELOW                   *)
(***********************************************************)
DEFINE_EVENT

data_event[vdvBSS]
{
    string:
    {
	testSuiteEvent e;
	
	e.device = vdvBSS;
	e.str = data.text;
	e.type = TEST_SUITE_EVENT_STRING;
	
	testSuiteEventTriggered(e);
    }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*          DO NOT PUT ANY CODE BELOW THIS COMMENT         *)
(***********************************************************)
