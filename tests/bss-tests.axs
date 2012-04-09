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

(***********************************************************)
(*                TEST DEFINITIONS GO BELOW                *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

define_function testSuiteRun()
{
    //ip_client_open(first_local_port, '10.0.20.51', 23, IP_TCP);
    //combine_devices(vdvBSS, dvTelnet);
 
    testLongToByte();
    testEncodeDecode();
    testCommands();
    
    //uncombine_devices(vdvBSS);
    //ip_client_close(first_local_port);
}

define_function testLongToByte()
{
    char bytes[4];
    
    bytes = _bssLongToByte($01b2c3d4);
    assertString(bytes, "$01, $b2, $c3, $d4", 'Assert long to byte.');
    
    bytes = _bssLongToByte(type_cast(-11163017));
    assertString(bytes, "$ff, $55, $aa, $77", 'Assert negative long to byte.');
}

define_function testEncodeDecode()
{
    double d;
    slong l;
    
    d = -20; // Test -20dB.
    
    // PROBLEMS WITH HOW AMX HANDLES THE SOUNDWEB GAIN SCALING EQUATION.
    // It looks like log10 is returning 0 due to a function call error.
    
    //testSuitePrint("'fn: ', ftoa((log10_value(abs_value(d / 10)) * -1 * 200000) - 100000)");
    
    //testSuitePrint("'slong: ', ftoa(d)");
    //testSuitePrint("'value: ', itoa(bssEncodeGain(d))");
    //testSuitePrint("'value: ', itohex(bssEncodeGain(d))");
    
    //assert(bssEncodeGain(d) == -160205, 'Encode gain.');
}

define_function testCommands()
{
    bssSet(TEST_OBJECT, 0);
    assertEventString(vdvBSS, "BSS_STX, BSS_DI_SETSV, TEST_OBJECT_ESCAPED, $00, $00, $00, $00, $80, BSS_ETX", 'BSS set.');
    
    bssSubscribe(TEST_OBJECT, 0);
    assertEventString(vdvBSS, "BSS_STX, BSS_DI_SUBSCRIBESV, TEST_OBJECT_ESCAPED, $00, $00, $00, $00, $81, BSS_ETX", 'BSS subscribe.');
    
    bssUnsubscribe(TEST_OBJECT);
    assertEventString(vdvBSS, "BSS_STX, BSS_DI_UNSUBSCRIBESV, TEST_OBJECT_ESCAPED, $00, $82, BSS_ETX", 'BSS unsubscribe.');
    
    bssVenueRecall(0);
    assertEventString(vdvBSS, "BSS_STX, BSS_DI_VENUE_PRESET_RECALL, $00, $00, $00, $00, $8B, BSS_ETX", 'BSS venue recall.');
    
    bssPresetRecall(0);
    assertEventString(vdvBSS, "BSS_STX, BSS_DI_PARAM_PRESET_RECALL, $00, $00, $00, $00, $8C, BSS_ETX", 'BSS preset recall.');
    
    bssSetPercent(TEST_OBJECT, 0);
    assertEventString(vdvBSS, "BSS_STX, BSS_DI_SETSVPERCENT, TEST_OBJECT_ESCAPED, $00, $00, $00, $00, $85, BSS_ETX", 'BSS set percent.');
    
    bssSubscribePercent(TEST_OBJECT, 0);
    assertEventString(vdvBSS, "BSS_STX, BSS_DI_SUBSCRIBESVPERCENT, TEST_OBJECT_ESCAPED, $00, $00, $00, $00, $86, BSS_ETX", 'BSS subscribe percent.');
    
    bssUnsubscribePercent(TEST_OBJECT);
    assertEventString(vdvBSS, "BSS_STX, BSS_DI_UNSUBSCRIBESVPERCENT, TEST_OBJECT_ESCAPED, $00, $87, BSS_ETX", 'BSS unsubscribe percent.');
    
    bssBumpPercent(TEST_OBJECT, 0);
    assertEventString(vdvBSS, "BSS_STX, BSS_DI_BUMPSVPERCENT, TEST_OBJECT_ESCAPED, $00, $00, $00, $00, $98, BSS_ETX", 'BSS bump percent.');
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
