(***********************************************************
    BSS SOUNDWEB LONDON PROTOCOL
    TESTS
    
    Website: https://sourceforge.net/projects/amx-lib-bss/
    
    
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

//dvTelnet = 0:first_local_port:0;

(***********************************************************)
(*              CONSTANT DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_CONSTANT

TEST_OBJECT[] = {$01, $02, $03, $04, $05, $06, $07, $08};

TEST_OBJECT_ESCAPED[] = {$01, BSS_ESC, $82, BSS_ESC, $83, $04, $05, BSS_ESC, $86, $07, $08};

DEFINE_VARIABLE

//char debug[BSS_MAX_PACKET_LEN];

(***********************************************************)
(*                TEST DEFINITIONS GO BELOW                *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

define_function testSuiteRun()
{
    //ip_client_open(first_local_port, '10.0.20.51', 23, IP_TCP);
    //combine_devices(vdvBSS, dvTelnet);
 
    testLongToByte();
    testCommands();
    
    //uncombine_devices(vdvBSS);
    //ip_client_close(first_local_port);
}

define_function testLongToByte()
{
    char bytes[4];
    
    bytes = _bssLongToByte($01b2c3d4);
    
    testSuitePrint("'Bytes: ', bytes");
    
    assertString(bytes, "$01, $b2, $c3, $d4", 'Assert long to byte.');
}

define_function testCommands()
{
    bssSet(TEST_OBJECT, 0);
    assertEventString(vdvBSS, "BSS_STX, BSS_DI_SETSV, TEST_OBJECT_ESCAPED, $00, $00, $00, $00, $80, BSS_ETX", 'BSS set.');
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
	
	//debug = data.text;
	
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
