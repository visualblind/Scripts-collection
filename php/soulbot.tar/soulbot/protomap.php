<?
/*
	-Joel De Gan
	the protocol map for the soulseek network.

	there is a guy who did one in php to log in and get a list of rooms but
	he could not make it further than that. In discussions with him on the soulseek network
	I found that he got hung up on the Msg83 which is a server message that I have seen 
	two different explainations of. In this work I just discard that packet. His basic work
	is what got me started here. Thanks Jan.

	My primary sources for the following are these great resources for soulseek:

	http://cvs.sourceforge.net/viewcvs.py/soleseek/SoleSeek/doc/protocol.html?rev=HEAD
	http://thread.gmane.org/gmane.network.ethereal.devel/3751

	This file is kind of like a big secret-decoder-ring used only by functions in protocol.php

	(((config.php | mysql.php) => protomap.php) => protocol.php) => scripts
	
*/
// These are sent from PEERS to us..
$peerinbound = array(
	PEERINIT => array(
		array(TYPE_BYTE, 'msgCode'),
		array(TYPE_STRING, 'username'),
		array(TYPE_STRING, 'type'),	# 'P' or 'F' if files..
		array(TYPE_INT, 'const'),	# 300 or 0x0000012c
		array(TYPE_INT, 'token')	# uid token
	),
	USERINFOREPLY => array(
		array(TYPE_INT, 'msgCode'),
		array(TYPE_STRING, 'description'),
		array(TYPE_BYTE, 'hasPic'),
		array(TYPE_STRING, 'picString'), #only present if the previous byte is true
		array(TYPE_INT, 'userUploads'),
		array(TYPE_INT, 'totalUploads'),
		array(TYPE_INT, 'queueSize'),
		array(TYPE_INT, 'slotsAvail'),
	),
	SHAREDFILELIST => array(
	array(TYPE_INT, 'numDirs'),
	array(TYPE_ENUM, array('directoryName1', 'numDirs', TYPE_STRING)),
		array(TYPE_ENUM, array('numFilesD', 'directoryName1', TYPE_ENUM)),
		#array(TYPE_INT, 'numFilesD'),

			array(TYPE_BYTE, 'code'),
			array(TYPE_STRING, 'filename'),
			array(TYPE_INT, 'size1'),
			array(TYPE_INT, 'size2'),
			array(TYPE_STRING, 'ext'),
			array(TYPE_INT, 'numAttribs'),

		
			#array(TYPE_ENUM, array('code', 		'numFilesD', TYPE_BYTE)),
			#array(TYPE_ENUM, array('filename', 	'numFilesD', TYPE_STRING)),
			#array(TYPE_ENUM, array('size1', 	'numFilesD', TYPE_INT)),
			#array(TYPE_ENUM, array('size2', 	'numFilesD', TYPE_INT)),
			#array(TYPE_ENUM, array('ext', 		'numFilesD', TYPE_STRING)),
			#array(TYPE_ENUM, array('numAttribs', 	'numFilesD', TYPE_INT)),
			
			#	array(TYPE_ENUM, array('size2', 'numAttribs', TYPE_INT))
	)
);


// these are send from the SERVER to us
$inbound = array(
        ROOMLIST => array(
	    #array(TYPE_INT, 'RoomListLength'),
	    #array(TYPE_INT, 'ROOMLIST'),
            array(TYPE_INT, 'numRooms'), 				# integer	number of rooms
            array(TYPE_ENUM, array('rooms', 'numRooms', TYPE_STRING)), 	# string	name of room #1
            array(TYPE_INT, 'numUsers'),				# integer	user count records
            array(TYPE_ENUM, array('users', 'numUsers', TYPE_INT))	# integer	user count in room #1
	    
        ),
        LOGIN => array(
            array(TYPE_BYTE, 'success'),
            array(TYPE_STRING, 'message'),
	    array(TYPE_INT, 'unknownint'),
	    # the server auto-sends us this roomlist with the login packet
	    array(TYPE_INT, 'RoomListLength'),
	    array(TYPE_INT, 'ROOMLIST'),
            array(TYPE_INT, 'numRooms'), 				# integer	number of rooms
            array(TYPE_ENUM, array('rooms', 'numRooms', TYPE_STRING)), 	# string	name of room #1
            array(TYPE_INT, 'numUsers'),				# integer	user count records
            array(TYPE_ENUM, array('users', 'numUsers', TYPE_INT))	# integer	user count in room #1
	    
        ),
	JOINROOM => array(
		array(TYPE_STRING, 'room'),					# string	room
		array(TYPE_INT, 'numUsers'),					# integer	number of users in this room
		array(TYPE_ENUM, array('users', 'numUsers', TYPE_STRING)),	# string	username #1
		
		array(TYPE_INT, 'statUsers'),					# integer	number of status code intgers
		array(TYPE_ENUM, array('intStats', 'statUsers', TYPE_INT)),	# integer	status code of username #1
		
		array(TYPE_INT, 'statCodes'),					# integer	number of statistics records
		array(TYPE_ENUM, array('avgspeed', 'statCodes', TYPE_INT)), 	# integer	avgspeed of username #1
		array(TYPE_ENUM, array('downloadnum', 'statCodes', TYPE_INT)),	# integer	downloadnum of username #1
		array(TYPE_ENUM, array('something', 'statCodes', TYPE_INT)),	# integer	something of username #1
		array(TYPE_ENUM, array('files', 'statCodes', TYPE_INT)),	# integer	files of username #1
		array(TYPE_ENUM, array('dirs', 'statCodes', TYPE_INT)),		# integer	dirs of username #1

		array(TYPE_INT, 'slotsFull'),					# integer	number of slotsfull records
		array(TYPE_ENUM, array('slots', 'slotsFull', TYPE_INT))		# integer	slotsfull field of username #1
	),
	USERJOINEDROOM => array(
		#array(TYPE_INT, 'messageid'),
		array(TYPE_STRING, 'room'),
		array(TYPE_STRING, 'username')
	),
	GLOBALUSERLIST => array(
		array(TYPE_INT, 'numUsers'),					# integer	number of users in this room
		array(TYPE_ENUM, array('users', 'numUsers', TYPE_STRING)),	# string	username #1
		
		array(TYPE_INT, 'statUsers'),					# integer	number of status code intgers
		array(TYPE_ENUM, array('intStats', 'statUsers', TYPE_INT)),	# integer	status code of username #1
		
		array(TYPE_INT, 'statCodes'),					# integer	number of statistics records
		array(TYPE_ENUM, array('avgspeed', 'statCodes', TYPE_INT)), 	# integer	avgspeed of username #1
		array(TYPE_ENUM, array('downloadnum', 'statCodes', TYPE_INT)),	# integer	downloadnum of username #1
		array(TYPE_ENUM, array('something', 'statCodes', TYPE_INT)),	# integer	something of username #1
		array(TYPE_ENUM, array('files', 'statCodes', TYPE_INT)),	# integer	files of username #1
		array(TYPE_ENUM, array('dirs', 'statCodes', TYPE_INT)),		# integer	dirs of username #1

		array(TYPE_INT, 'slotsFull'),					# integer	number of slotsfull records
		array(TYPE_ENUM, array('slots', 'slotsFull', TYPE_INT))		# integer	slotsfull field of username #1
	),
	PRIVILEGEDUSERS => array(
		array(TYPE_INT, 'pUserNum'),
		array(TYPE_ENUM, array('user', 'pUserNum', TYPE_STRING))
	),
	GETPEERADDRESS => array(
	   array(TYPE_STRING, 'username'),
	   array(TYPE_INT, 'ipaddress'),
	   array(TYPE_INT, 'portnumber')
	),
	MSG83 => array(
		array(TYPE_STRING, 'message')
	),
	MSG84 => array(
		array(TYPE_STRING, 'message')
	),
	MSG85 => array(
		array(TYPE_STRING, 'message')
	)	
);
#print_r($inbound );
?>
