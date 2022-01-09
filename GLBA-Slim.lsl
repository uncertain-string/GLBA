/**
BSD 3-Clause License

Copyright (c) 2022 frick.teardrop

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, 
   this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation 
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors 
   may be used to endorse or promote products derived from this software without 
   specific prior written permission.
**/
integer hp=50;//Current AP
integer hpmax=50;//Max AP
integer link=2;//Text Display Link
integer hex;
key me;
updateAP(){
        if(hp<1) {
            llDie();
        }
        llSetTimerEvent(0.15);
}
default{
    on_rez(integer s){
        hp = hpmax;
        llSetObjectDesc("LBA.v.L.NTLBA.1.02");
        me=llGetKey();
        hex=(integer)("0x" + llGetSubString(llMD5String((string)me,0), 0, 3));
        llListen(hex, "","","");
        updateAP();
    }
    timer() {
        llSetLinkPrimitiveParamsFast(link,[
            PRIM_TEXT,"[GLBA-S] \n AP: " + (string)(hp) + "/" +(string)(hpmax),<0.0,1.0,0.0>,1.0,
            PRIM_LINK_TARGET, LINK_THIS,
            PRIM_DESC, "LBA.v.L.2.22," + (string)hp + "," + (string)hpmax
        ]);
        llSetTimerEvent(0);
    }
    
    collision_start(integer n){
        while(n--){
            if(llVecMag(llDetectedVel(n)) > 25)
            {
                --hp;
            }
        }
        updateAP();
    }
    listen(integer i, string s, key k, string m){
        list l = llParseString2List(m,[","],[]);
        string prefix = llList2String(l,0);
        string suffix = llList2String(l,1);
        if(i==hex){
            if (prefix==(string)me){
                hp-=(integer)suffix;
                if(hp > hpmax) hp = hpmax;
                updateAP();
            }
        }
    }
}
