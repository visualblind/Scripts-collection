#A3tra3rpi 2019
#Absolutely no warranty
#Work in progress. Battery levels are not 100% accurate > mostly guesses based on logged values. Also currently disconnects audio temporarily for the communication
#Requires pyusb and needs to be ran as su
#Usage: sudo python3 g933battery.py

import usb.core
import usb.util
import time #For automatic polling

VID = 0x046d #Logitech
PID = 0x0a5b #G933 (G930 might work? Not tested)

def status(i):
    return {
        0: "Disconnected",
        1: "Idle",
	3: "Charging",
    }.get(i, "Not implemented({})".format(hex(i)))

def get_battery_level(b1, b2): #CHARGING AND DISCHARGING LEVELS ARE DIFFERENT. This is based on the levels seen when discharging
    #b1 from d to f (might temporarily go c and 10)
    #b2 from 0 to 255 for every b1 value
    #Shutdown at about b1:0xd, b2:0x0 and full capacity about b1:0xf, b2:0xff
    lvl = b1 - 13 #13-15 > 0-2
    mx = 0xff
    return int(((b2 + lvl * mx) * 100)/(3 * mx))

def print_hex(st): #For printing in hex
    s = "Received:"
    for i in st:
    	s += "{} ".format(hex(i))
    print(s)

def get_battery_state():
    dev = usb.core.find(idVendor=VID, idProduct=PID)
    if not dev:
        print("Could not find device")
        exit
    #print("Device found")
    #dev.reset()
    for cfg in dev: #Detach all the drivers
        for intf in cfg:
            if dev.is_kernel_driver_active(intf.bInterfaceNumber):
                try:
                    dev.detach_kernel_driver(intf.bInterfaceNumber)
                except usb.core.USBError as e:
                    sys.exit("Could not detach kernel driver from interface({0}):{1}".format(intf.bInterfaceNumber, str(e)))
    #dev.set_configuration()
    endpoint_in = dev[0][(3,0)][0] #.bEndpointAddress
    while True:
        try:
            #21 09 11 02 03 00 00 00
            #|  |  |     |     |
            #|  |  Value Index Length
            #|  Request
            #Request type
            #0x21, 0x09, 0x0211, 0x0003
            #and data:
            #11ff080a00000000000000000000000000000000
            #or     |
            #11ff080b00000000000000000000000000000000
            #or     |
            #11ff080c00000000000000000000000000000000
            dev.ctrl_transfer(0x21, 0x09, 0x0211, 0x0003, [0x11,0xFF,0x08,0x0a,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
            data = dev.read(endpoint_in.bEndpointAddress, endpoint_in.wMaxPacketSize, 0) #Receive data from usb
            #print_hex(data) #Print received data
            #Received packet contains supposed battery data from byte[3] to byte[6]:
            #0xa 0xf 0xe9 0x1
            #|   |   |    |
            #|   |   |    Headset status
            #|   |   Battery level pt2
            #|   Battery level pt1
            #Unknown level. Often 0xa or 0xc
            if len(data) > 6 and not 135 == data[6] and not 145 == data[6]: #Packet with byte 6 of 135 or 145 is some other packet and might not contain any data about the battery
                state = data[6]
                battery_status = 0
                if state != 0: #Current best effort trying to extract battery status
                    battery_status = get_battery_level(data[4], data[5])
                print("Battery:~{}% (estimated from:{}/2,{}/255)".format(battery_status, data[4] - 13, data[5]),"Status:", status(state))
                break
        except Exception as e:
            print("Exception:", e)
            break

    #Attach drivers again. For some reason attaching only first does the job?
    dev.attach_kernel_driver(0)

    #Reattaching all the drivers for special cases
    """
    try:
    for config in dev:
        for i in range(config.bNumInterfaces):
            dev.attach_kernel_driver(i)
    except:
        print("Can't close propperly")
    print("Reattached drivers")
    """
    usb.util.dispose_resources(dev)

#while True:
#    get_battery_state()
#    time.sleep(5)
get_battery_state()
