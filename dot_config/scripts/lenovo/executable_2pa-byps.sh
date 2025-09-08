#!/bin/sh
# echo Turn on log!
# set -x
# clear
function clear_stdin()
(
    old_tty_settings=`stty -g`
    stty -icanon min 0 time 0

    while read none; do :; done

    stty "$old_tty_settings"
)

if [ $# -ne 1 ];
then
	echo Kindly specify the i2c bus number. The default i2c bus number is 3.
	echo Command as following:
	echo $0 i2c-bus-number
	i2c_bus=3
else
	i2c_bus=$1
fi

echo i2c bus is $i2c_bus
i2c_addr=(0x3f 0x38)

count=0
for value in ${i2c_addr[@]};
do
val=$((${count} % 2))
i2cset -f -y $i2c_bus $value 0x00 0x00
i2cset -f -y $i2c_bus $value 0x7f 0x00
i2cset -f -y $i2c_bus $value 0x01 0x01
i2cset -f -y $i2c_bus $value 0x0e 0xc4
i2cset -f -y $i2c_bus $value 0x0f 0x40
i2cset -f -y $i2c_bus $value 0x5c 0xd9
i2cset -f -y $i2c_bus $value 0x60 0x10
if [ $val -eq 0 ];
then
	i2cset -f -y $i2c_bus $value 0x0a 0x1e
else
	i2cset -f -y $i2c_bus $value 0x0a 0x2e
fi
i2cset -f -y $i2c_bus $value 0x0d 0x01
i2cset -f -y $i2c_bus $value 0x16 0x40
i2cset -f -y $i2c_bus $value 0x00 0x01
i2cset -f -y $i2c_bus $value 0x17 0xc8
i2cset -f -y $i2c_bus $value 0x00 0x04
i2cset -f -y $i2c_bus $value 0x30 0x00
i2cset -f -y $i2c_bus $value 0x31 0x00
i2cset -f -y $i2c_bus $value 0x32 0x00
i2cset -f -y $i2c_bus $value 0x33 0x01

i2cset -f -y $i2c_bus $value 0x00 0x08
i2cset -f -y $i2c_bus $value 0x18 0x00
i2cset -f -y $i2c_bus $value 0x19 0x00
i2cset -f -y $i2c_bus $value 0x1a 0x00
i2cset -f -y $i2c_bus $value 0x1b 0x00
i2cset -f -y $i2c_bus $value 0x28 0x40
i2cset -f -y $i2c_bus $value 0x29 0x00
i2cset -f -y $i2c_bus $value 0x2a 0x00
i2cset -f -y $i2c_bus $value 0x2b 0x00

i2cset -f -y $i2c_bus $value 0x00 0x0a
i2cset -f -y $i2c_bus $value 0x48 0x00
i2cset -f -y $i2c_bus $value 0x49 0x00
i2cset -f -y $i2c_bus $value 0x4a 0x00
i2cset -f -y $i2c_bus $value 0x4b 0x00
i2cset -f -y $i2c_bus $value 0x58 0x40
i2cset -f -y $i2c_bus $value 0x59 0x00
i2cset -f -y $i2c_bus $value 0x5a 0x00
i2cset -f -y $i2c_bus $value 0x5b 0x00

i2cset -f -y $i2c_bus $value 0x00 0x00
i2cset -f -y $i2c_bus $value 0x02 0x00
count=$((${count} + 1))
done;
# clear_stdin
