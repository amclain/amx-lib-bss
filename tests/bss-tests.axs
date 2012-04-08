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

DEFINE_DEVICE

dvTelnet = 0:49000:0;

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
    ip_client_open(49000, '192.168.0.37', 23, IP_TCP);
    combine_devices(vdvBSS, dvTelnet);
    
    testCommands();
    
    uncombine_devices(vdvBSS);
    ip_client_close(49000);
}

define_function testCommands()
{
    local_var char str[BSS_MAX_PACKET_LEN];
    str = "TEST_OBJECT, $00, $00, $00, $00";
    
    bssSet(TEST_OBJECT, 0);
    assertEventString(vdvBSS, "BSS_STX, BSS_DI_SETSV, str, _bssChecksum(str), BSS_ETX", 'BSS set.');
}

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
	
	/*
	// WIRESHARK VERIFICATION
	{
	local_var char temp[BSS_MAX_PACKET_LEN];
	temp = data.text;
	
	ip_client_open(49000, '192.168.0.37', 23, IP_TCP);
	wait 5
	{
	    send_string 0:49000:0, temp;
	    wait 5
	    {
		ip_client_close(49000);
	    }
	}
	}
	*/
    }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*          DO NOT PUT ANY CODE BELOW THIS COMMENT         *)
(***********************************************************)
