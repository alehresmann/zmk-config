where I am at:

dongle doesnt work, I think its because the pairs are incorrectly being labelled as central or peripheral or whatever.

moreover, when the left hand side is designated as the central one and you connect the left hand side by cable, it automatically works without needing to connect via bluetooth. not so when they're both looking for the dongle as the master. can it ever work in cable when the dongle is the master? I don't think so but uncomfirmed. 

last nondongle firmware that works:

https://github.com/alehresmann/zmk-config/actions/runs/18423241834

probably need to make two branches or something.





tips and tricks:

bluetooth pairing:
flash the reset firmware on ALL devices to ensure they can pair to each other

if we suppose the KEY is:

LEFT_HAND           RIGHT_HAND
    T1 T2           T1 T2

to get the menu when booting the computer to select boot device: F11 -> T2 + leftmost key on middle row, left hand
bluetooth pair: 
LT2 + RT1 -> bluetooth layer
          + rightmost key on upper row, left hand: bluetooth reset
          + any other key on upper row: pick that bluetooth profile


when flashing significantly different firmware such that you may need the pairs to repair, flash the settings reset firmware on all involved parts FIRST, before flashing new firmware.

to trigger a pair between halves, start them at the same time, or press reset once at the same time.

on the dongle commits, usb logging is enabled for debugging purposes. once you're done, disable it, it eats battery.

debugging: plug in the part then:

``` 
sudo minicom -D /dev/ttyACM0 -o

```
