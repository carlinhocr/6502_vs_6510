450 input "record # desired";re
460 if re <1 or re > 65536 then 450
470 rh = int(re/256) : rem hight byte
480 rl = re-256*rh : rem low byte
490 print#15,"P"+chr$ (98)+chr$(rl)+chr$(rh)
570 input "channel, record, & offset desired";ch,re,of
580 print#15,"P"+chr$ (ch+96)+chr$(rl)+chr$(rh)+chr@(of)